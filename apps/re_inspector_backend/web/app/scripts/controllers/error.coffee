'use strict'

angular.module('reInspectorWebApp')
  .controller 'ErrorCtrl', ($scope, $rootScope) ->
    console.log "error ctrl"
    $scope.error = ''

    $rootScope.$watch('networkError', (newValue) => $scope.error = newValue)
