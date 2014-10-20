'use strict'

describe 'Controller: LiveCtrl', ->

  beforeEach module 'reInspectorWebApp'

  LiveCtrl = {}
  rootScope = {}
  scope = {}
  service = {}
  q = {}

  beforeEach inject ($controller, $rootScope, searchService, $q) ->
    rootScope = $rootScope
    scope     = $rootScope.$new()
    service   = searchService
    q         = $q

    LiveCtrl = $controller 'LiveCtrl', {$scope: scope }

  describe 'initialization', ->
    it 'does not have any results', ->
      expect(scope.results).toEqual []

    it 'does not have any filter', ->
      expect(scope.filter).toEqual ""

  describe '.newRequest', ->
    request = {}

    beforeEach ->
      scope.results = [
        {id: 1}
        {id: 2}
        {id: 3}
        {id: 4}
      ]

      request = {id: 'new'}

    it 'adds the request in the results', ->
      scope.newRequest(request)

      expect(scope.results.length).toBe 5

    it 'adds the request at the head of the list', ->
      scope.newRequest(request)

      expect(scope.results[0]).toBe request

    it 'keeps only 100 api requests', ->
      _.times(96, (i) -> scope.results.push {id: "request_#{i}" })

      scope.newRequest(request)

      expect(scope.results.length).toBe 100

  describe '.newRequestReceived', ->
    request  = {}
    message  = {}
    deferred = {}

    beforeEach ->
      request  = {request_id: 1}
      message  = {path: '/api_request/1'}
      deferred = q.defer()

      spyOn(service, 'find').andReturn deferred.promise

    it 'requests the backend to get the api request in the message', ->
      scope.newRequestReceived(message)

      expect(service.find).toHaveBeenCalledWith '/api_request/1'

    it 'adds the api request in the results', ->
      scope.newRequestReceived(message)
      deferred.resolve(request)
      scope.$apply()

      expect(scope.results).toEqual [request]
