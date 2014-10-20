'use strict'

###*
 # @ngdoc function
 # @name reInspectorWebApp.controller:MainCtrl
 # @description
 # # MainCtrl
 # Controller of the reInspectorWebApp
###
angular.module('reInspectorWebApp')
  .controller 'LoginCtrl', ($scope, $routeParams) ->
    console.log "login ctrl", $routeParams
    $scope.query = ''
