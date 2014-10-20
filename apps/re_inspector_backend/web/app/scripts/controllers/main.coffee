'use strict'

###*
 # @ngdoc function
 # @name reInspectorWebApp.controller:MainCtrl
 # @description
 # # MainCtrl
 # Controller of the reInspectorWebApp
###
angular.module('reInspectorWebApp')
  .controller 'MainCtrl', ($scope, $http, $location, $routeParams, $cookies, $route) ->
    console.log "main ctrl", $routeParams
    $scope.query = ''

    $scope.authenticate = ->
      console.log "authenticated"
      $cookies.authentication_token = $routeParams.authentication_token
      $cookies.login = $routeParams.login

      $routeParams = {}

    $scope.search = ->
      console.log("searching '#{$scope.query}'")
      $location.search("q", $scope.query)
      $location.path("/search")

    $scope.authenticate() if $routeParams['authentication_token']
