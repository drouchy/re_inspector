'use strict'

###*
 # @ngdoc function
 # @name reInspectorWebApp.controller:MainCtrl
 # @description
 # # MainCtrl
 # Controller of the reInspectorWebApp
###
angular.module('reInspectorWebApp')
  .controller 'SearchCtrl', ($scope, $http, $location, $routeParams, searchService) ->
    $scope.query = $routeParams.q
    $scope.noResults = false
    $scope.showAllResults = false
    $scope.results = []
    $scope.pagination = {}

    $scope.search = ->
      $scope.showAllResults = false
      $location.search("q", $scope.query)
      $location.path("/search")
      $scope.executeSearch()

    $scope.executeSearch = ->
      console.log "searching '#{$scope.query}'"
      $scope.__discard_results()
      $scope.__search("/api/search?q=#{$scope.query}")

    $scope.loadMore = ->
      console.log "loading page #{$scope.pagination.next_page}"
      $scope.__search($scope.pagination.next_page)

    $scope.loadAll = ->
      console.log "showing all results #{$scope.pagination.all_results}"
      $scope.showAllResults = true
      $scope.__discard_results()
      $scope.__search($scope.pagination.all_results)

    $scope.__search = (path) ->
      $scope.searching = true
      searchService.search(path).then(
        (data)  ->
          _.each(data.results, (v) -> $scope.results.push(v))
          $scope.pagination = data.pagination
          $scope.noResults = data.results.length == 0
          $scope.searching = false
        (error) ->
          $scope.noResults = false
          $scope.searching = false
      )

    $scope.__discard_results = ->
      while($scope.results.length > 0)
        $scope.results.shift()

    $scope.executeSearch()
