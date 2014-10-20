'use strict'

describe 'Controller: MainCtrl', ->

  beforeEach module 'reInspectorWebApp'

  MainCtrl = {}
  scope = {}
  location = {}

  beforeEach inject ($controller, $rootScope, $location) ->
    scope = $rootScope.$new()
    location = $location

    MainCtrl = $controller 'MainCtrl', {$scope: scope }

  it 'has an empty query', ->
    expect(scope.query).toEqual ''

  describe 'search', ->
    it 'redirects to the search controller', ->
      scope.query = 'to_search'

      scope.search()

      expect(location.path()).toEqual "/search"

    it 'applies the search query in the parameters', ->
      scope.query = 'to_search'

      scope.search()

      expect(location.$$url).toEqual "/search?q=to_search"

