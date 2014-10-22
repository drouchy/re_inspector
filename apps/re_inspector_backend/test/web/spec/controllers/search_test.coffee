'use strict'

describe 'Controller: SearchCtrl', ->

  beforeEach module 'reInspectorWebApp'

  MainCtrl = {}
  scope = {}
  deferred = {}
  promise = {}
  service = {}
  routeParams = {}
  location = {}

  beforeEach inject ($controller, $rootScope, searchService, $q, $location, $routeParams) ->
    $routeParams['q'] = 'to_search'
    $location.search('q', 'to_search')

    buildPromise($q, searchService)

    scope = $rootScope.$new()
    location = $location

    MainCtrl = $controller 'SearchCtrl', {$scope: scope}

  it 'has a query set to the q params', ->
    expect(scope.query).toEqual 'to_search'

  it 'does not have no results', ->
    expect(scope.noResults).toBe false

  it 'has an empty result list', ->
    expect(scope.results).toEqual []

  it 'does not show all the results', ->
    expect(scope.showAllResults).toBe false

  describe 'search', ->
    it 'redirects to the search controller', ->
      scope.query = 'foo_bar'

      scope.search()

      expect(location.path()).toEqual "/search"

    it 'applies the search query in the parameters', ->
      scope.query = 'foo_bar'

      scope.search()

      expect(location.$$url).toEqual "/search?q=foo_bar"

    it 'launches the search', ->
      scope.query = 'foo_bar'

      scope.search()

      expect(service.search).toHaveBeenCalledWith('/api/search?q=foo_bar')

    it 'sets back the showAllResults flag', ->
      scope.showAllResults = true
      scope.query = 'foo'

      scope.search()

      expect(scope.showAllResults).toBe false

  describe 'search execution', ->
    it 'searches the query', ->
      expect(service.search).toHaveBeenCalledWith('/api/search?q=to_search')

    it 'start searching', ->
      scope.$apply()

      expect(scope.searching).toBe true

    it 'assigns the result of the search', ->
      results = ['REF1', 'REF2']

      deferred.resolve({results: results})
      scope.$apply()

      expect(scope.results).toEqual results

    it 'stops searching', ->
      expect(scope.searching).toBe true

      deferred.resolve({results: []})
      scope.$apply()

      expect(scope.searching).toBe false

    it 'does not have no results', ->
      deferred.resolve(results: ['REF1', 'REF2'])
      scope.$apply()

      expect(scope.noResults).toBe false

    it 'has no results with the service returns no results', ->
      results = []

      deferred.resolve({results: results})
      scope.$apply()

      expect(scope.noResults).toBe true

    describe 'with error', ->
      it 'marks as there is no results', ->
        scope.noResults = true

        deferred.reject('error')
        scope.$apply()

        expect(scope.noResults).toBe false

      it 'stops searching', ->
        expect(scope.searching).toBe true

        deferred.reject('error')
        scope.$apply()

        expect(scope.searching).toBe false

  describe 'loadAll', ->
    it 'sets the flag show all results', ->
      scope.loadAll()

      expect(scope.showAllResults).toBe true

    it 'launches the search', ->
      scope.pagination = { all_results: '/api/search?q=foo_bar' }

      scope.loadAll()

      expect(service.search).toHaveBeenCalledWith('/api/search?q=foo_bar')

    it 'discard all results before searching', ->
      results = ['new result 1', 'new result 2']
      scope.results = ['result 1', 'result 2']
      deferred.resolve({results: results})

      scope.loadAll()
      scope.$apply()

      expect(_.contains(scope.results,('result 1'))).toBe false
      expect(_.contains(scope.results,('result 2'))).toBe false

  buildPromise = (q, searchService) ->
    deferred = q.defer()
    promise = deferred.promise

    service = searchService
    spyOn(searchService, 'search').andReturn(promise)
