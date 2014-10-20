'use strict'

###*
 # @ngdoc function
 # @name reInspectorWebApp.controller:AboutCtrl
 # @description
 # # AboutCtrl
 # Controller of the reInspectorWebApp
###
angular.module('reInspectorWebApp')
  .controller 'AboutCtrl', ($scope, $http) ->
    $scope.version = { backend : 'fetching', app : 'fetching' }

    $http.get("/api/version").
      success((data, status, headers) -> $scope.version = data.version).
      error((data, status, headers) -> $scope.version = error_version())

    error_version = ->
      { backend : 'error while fetching', app : 'error while fetching' }
