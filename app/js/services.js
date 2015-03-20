'use strict';

/* Services */
var services = angular.module('myApp.services', ['ngResource']);

services.value('version', '0.1');

// Preferences
services.factory('ConfigTemplate', ['$resource',
    function($resource) {
        return $resource('templates/:templateId.json', {}, {
            query: {
                method: 'GET',
                params: {
                    templateId: 'config'
                },
                isArray: true
            }
        })
    }
]);


//Recuper los templates de código
services.factory('CodeTemplate', ['$http', '$q',
    function($http, $q) {
        return {
            get: function(node_name) {
                var deferred = $q.defer(),
                    path = 'templates/' + node_name + '.abap';
                //                    node = '_' + node_name;
                $http.get(path).success(function(data, status) {
                    deferred.resolve({
                        id: node_name,
                        data: data
                    });
                }).error(function(data, status) {
                    deferred.reject({
                        id: node_name,
                        data: data
                    });
                });
                return deferred.promise;
            }
        };
    }
]);


// Code dependency manager
services.factory('CodeDependency', ['$log',
    function($log) {
        var defined = {},
            required = {};

        function getDefined() {
            return Object.keys(defined);
        }

        function getRequired() {
            return Object.keys(required);
        }
        return {
            getDefined: getDefined,
            getRequired: getRequired,
            add: function(id, requires) {
                $log.log('id:', id, 'requires:', requires);
                defined[id] = requires;
                delete required[id];
                requires.forEach(function(value, i, array) {
                    if (defined[value] == undefined) {
                        required[value] = required[value] || []
                        required[value].push(id);
                        $log.info('add dependency:', value);
                    }
                });
                $log.debug('defined:', getDefined());
                $log.debug('required:', getRequired());
            }
        };
    }
]);


// Code generator
services.factory('CodeGenerator', ['CodeDependency', 'CodeTemplate', '$q', '$interpolate', '$rootScope', '$log',
    function(CodeDependency, CodeTemplate, $q, $interpolate, $scope, $log) {
        var sections = {},
            context = $scope;

        function setCharAt(str, index, chr) {
            if (index == -1 || index > str.length - 1) return str;
            return str.substr(0, index) + chr + str.substr(index + 1);
        }

        function interpolate(text, context) {
            if (context == undefined) {
                context = $scope;
            }
            $log.debug('scope:', context);
            return $interpolate(text)(context);
        }

        //New code section
        function section(id, requires, init) {
            var section_proto = {
                id: '',
                requires: [],
                hasTemplate: true,
                elements: [],
                element: undefined,
                index: undefined,
                compileForEach: undefined,
                source: '',
                gen: ''
            };

            init = init || function() {};
            requires = requires || [];

            section_proto.id = id;
            section_proto.requires = requires;

            CodeDependency.add(section_proto.id, section_proto.requires);
            sections[section_proto.id] = angular.extend(section_proto, init.apply(section_proto, []));
            context[section_proto.id] = sections[section_proto.id]; //add to scope
            $log.info('Section created:', section_proto.id, sections[section_proto.id])
            return sections[section_proto.id];
        }

        function load() {
            var promises = [];

            CodeDependency.getDefined().forEach(function(value, i, array) {
                $log.info('loading...', value);
                if (sections[value].hasTemplate && !sections[value].inDictionary) {
                    promises.push(CodeTemplate.get(value).then(function(result) {
                        sections[result.id].source = result.data;
                        return {
                            id: sections[result.id].id,
                            value: sections[result.id].source
                        };
                    }, function(result) {
                        sections[result.id].source = '';
                        $log.error('error loading...', value);
                        return {
                            id: sections[result.id].id,
                            value: sections[result.id].source
                        };
                    }));
                }

            });

            return $q.all(promises).then(function(data) {
                return data;
            });
        }

        //Interpolate template. Create temporal isolated scope
        function _compile(section_id, context) {
            $log.info(section_id, 'dependencies:', sections[section_id].requires);

            sections[section_id].requires.forEach(function(value, i, array) {
                _compile(value);
            });

            $log.info('compiling section', section_id);
            //
            if (sections[section_id].compileForEach !== undefined) {
                $log.info("compileForEach defined");
                var gen = '';
                sections[section_id].elements.forEach(function(element, index, elements) {
                    sections[section_id].compileForEach.apply(sections[section_id], [element, index, elements]);
                    var generatedElement = '';
                    sections[section_id].element = element;
                    sections[section_id].index = index;
                    generatedElement = interpolate(sections[section_id].source, context);
                    $log.debug('Code.compileForEach generated:', generatedElement);
                    gen += generatedElement + '\n';
                });
                sections[section_id].gen = setCharAt(gen, gen.lastIndexOf(','), '.');

            } else {
                sections[section_id].gen = interpolate(sections[section_id].source, context);
            }
            $log.debug('Code generated:\n', sections[section_id].gen);

            return sections[section_id].gen
        }

        //Load section templates and compile
        function compile(section_id) {
            var compilerScope = $scope.$new(true);

            $log.info('Init compilation:', section_id);
            Object.keys(sections).forEach(function(value, i, array) {
                var property = {};
                property[value] = sections[value];
                angular.extend(compilerScope, property);
            });
            $log.log('Compiler Scope:', compilerScope);

            return load().then(function(result) {
                return _compile(section_id, compilerScope);
            }, function(result) {
                $log.error('Compilation fails:', result.data);
                return '';
            }).finally(function() {
                compilerScope.$destroy();
            });
        }

        //Public interface
        return {
            sections: sections,
            section: section,
            load: load,
            compile: compile
        };
    }
]);


/////////////////////////////////////////////////////////////////////////////////////////////////
// Code dependency manager
services.factory('Report', ['$log',
    function($log) {
        function section(id, type, requires, init) {
            var _proto = {
                id: '',
                requires: [],
                hasTemplate: true,
                elements: [],
                element: undefined,
                index: undefined,
                compileForEach: undefined,
                source: '',
                gen: ''
            };

            init = init || function() {};
            requires = requires || [];

            section_proto.id = id;
            section_proto.requires = requires;

            CodeDependency.add(section_proto.id, section_proto.requires);
            sections[section_proto.id] = angular.extend(section_proto, init.apply(section_proto, []));
            context[section_proto.id] = sections[section_proto.id]; //add to scope
            $log.info('Section created:', section_proto.id, sections[section_proto.id])
            return sections[section_proto.id];
        }
        
        var types = {
            report: {
                name:'',
                includes: [],
                events: []
            }
        };
        
        return {
            name: '',
            includes:[],
            events:[]
        };
    }
]);