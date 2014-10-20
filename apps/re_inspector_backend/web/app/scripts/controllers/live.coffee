'use strict'

angular.module('reInspectorWebApp')
  .controller 'LiveCtrl', ($scope, $location, $cookies, searchService) ->
    console.log "Live controller", $location.host()

    $scope.filter  = ""
    $scope.results = []

    socket = new Phoenix.Socket("ws://" + $location.host() + "/ws")
    socket.join "re_inspector", "api_request", {authentication: $cookies.authentication_token}, (channel) ->
      channel.on "join", (message) ->
        console.log "joined successfully"

      channel.on "new:request", (message) ->
        $scope.newRequestReceived(message)

    $scope.newRequestReceived = (message) ->
      console.log "new message", message
      searchService.find(message.path).then(
        (api_request) -> $scope.newRequest api_request
        (error)       -> console.log "error: ", error
      )

    $scope.filterResults = ->
      console.log "filter results with #{$scope.filter}"

    $scope.newRequest = (api_request) ->
      $scope.results.unshift api_request
      while($scope.results.length > 100)
        $scope.results.pop()
