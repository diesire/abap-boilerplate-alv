'use strict';

/* Controllers */

angular.module('myApp.controllers', []).
controller('alv_app', ['$scope', 'ConfigTemplate', 'CodeDependency', 'CodeGenerator', '$log', '$timeout',
    'Report',
    function($scope, ConfigTemplate, CodeDependency, CodeGenerator, $log, $timeout, Report) {
        var timeout;
        var skippedUpdates = 0;

        function updateColumns(line) {
            $log.info("   function updateColumns()");
            var columns = parseLine(line);
            $scope.columnConstants.elements = columns;
            $scope.columnCatalog.elements = columns;
        }

        function _update() {
            $log.info("   function _update()");

            updateColumns($scope.columnsRaw);

            CodeGenerator.compile('report').then(function(result) {
                $log.info('compilation ok');
                $log.debug('report', result);
                $scope.result = result;
            }, function(result) {
                $log.error('compilation fails', result);
                $scope.result = result;
            });
        }

        function parseLine(line) {
            var elementsRaw = String(line).trim();
            var re = /\s*[,;.\s]\s*/;
            var result = elementsRaw.split(re);
            $log.debug("line parsing result", result);
            return result;
        }

        function update() {
            //cancel pending updates
            if (timeout) {
                $timeout.cancel(timeout);
            }

            //Calls _update with 500 ms delay. Enhances performance
            timeout = $timeout(function() {
                _update();
            }, 500);

            //timeout promise monitorization
            timeout.then(function sucess(result) {
                if (skippedUpdates > 0) {
                    $log.debug('Skipped updates', skippedUpdates);
                    skippedUpdates = 0;
                }
            }, function error(result) {
                skippedUpdates++;
            });
        }

        //Public interface
        $scope.result = '';
        $scope.generate = update;
        //Ace events
        $scope.aceLoaded = function(_editor) {
            // Options
            _editor.setReadOnly(false);
            $log.log(_editor.getReadOnly());
        };

        $scope.aceChanged = function(e) {
            //
        };

        //initialization
        $scope.columnsRaw = 'type message';

        CodeGenerator.section('report', ['top', 'events', 'app', 'screen9000'], function() {
            return {
                name: 'ZTEST001'
            }
        });
        CodeGenerator.section('top');
        CodeGenerator.section('events');
        CodeGenerator.section('screen9000', ['screen9000pbo', 'screen9000pai']);
        CodeGenerator.section('screen9000pbo', ['screen9000form']);
        CodeGenerator.section('screen9000pai');
        CodeGenerator.section('screen9000form');
        CodeGenerator.section('app', ['alv', 'zcl_util_ctx', 'dataInput']);
        CodeGenerator.section('alv', ['zcl_util_alv', 'types', 'columnConstants', 'columnCatalog']);
        CodeGenerator.section('zcl_util_ctx', [], function() {
            return {
                inDictionary: true
            }
        });
        CodeGenerator.section('zcl_util_alv', [], function() {
            return {
                inDictionary: true
            }
        });
        CodeGenerator.section('dataInput', [], function() {
            return {
                source: "data:\n      ls_BAPIRET2 type BAPIRET2.\n\n      ls_BAPIRET2-type = 'E'.\n      ls_BAPIRET2-message = 'Message 1'.\n      append ls_BAPIRET2 to et_data.\n",
                hasTemplate: false
            }
        });
        CodeGenerator.section('types', [], function() {
            return {
                table: 'bapiret2_tab',
                line: 'bapiret2',
                hasTemplate: false
            }
        });
        CodeGenerator.section('columnConstants', [], function() {
            return {
                compileForEach: function(element, index, elements) {}
            }
        });
        CodeGenerator.section('columnCatalog', [], function() {
            return {
                compileForEach: function(element, index, elements) {}
            }
        });

        $log.log('Available sections:', CodeDependency.getDefined());

        update();
    }
]).
controller('test', ['$scope', '$log', 'Report',
    function($scope, $log, Report) {


        //        CodeGenerator.section('report', ['top', 'events', 'app', 'screen9000'], function() {
        //            return {
        //                name: 'ZTEST001'
        //            }
        //        });

        $log.info('hi');

    }
]);