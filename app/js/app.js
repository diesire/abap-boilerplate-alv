'use strict';


// Declare app level module which depends on filters, and services
angular.module('myApp', [
  'ngRoute',
  'myApp.filters',
  'myApp.services',
  'myApp.directives',
  'myApp.controllers',
  'ui.ace'
]).
config(['$routeProvider',
    function ($routeProvider) {
        $routeProvider.when('/alv_app', {
            templateUrl: 'partials/alv_app.html',
            controller: 'alv_app'
        });
        $routeProvider.when('/test', {
            templateUrl: 'partials/test.html',
            controller: 'test'
        });
        $routeProvider.otherwise({
            redirectTo: '/alv_app'
        });
}]).config(function ($logProvider) {
    $logProvider.debugEnabled(true);
});

angular.element(document).ready(function () {
    //console.log("ready go!");
});