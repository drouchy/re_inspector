'use strict'

describe 'Controller: AboutCtrl', ->

  beforeEach module 'reInspectorWebApp'

  AboutCtrl = {}
  scope = {}
  mockBackend = {}

  beforeEach inject ($controller, $rootScope, $httpBackend) ->
    mockBackend = $httpBackend
    scope = $rootScope.$new()

    mockBackend.expectGET('/api/version').respond({version: {backend: "0.0.2", app: "0.0.3"}})

    AboutCtrl = $controller 'AboutCtrl', {
      $scope: scope
    }

  it 'has a basic version before receiving the data from the backend', ->
    version = scope.version

    expect(version).toEqual {backend: "fetching", app: "fetching"}

  it 'queries the backend for the version', ->
    mockBackend.flush()

    mockBackend.verifyNoOutstandingExpectation()
    mockBackend.verifyNoOutstandingRequest()

  it 'sets the version in the scope', ->
    mockBackend.flush()

    version = scope.version

    expect(version).not.toBe(null)
    expect(version).not.toBe(undefined)

  it 'sets the version with the backend values', ->
    mockBackend.flush()

    version = scope.version

    expect(version.backend).toEqual "0.0.2"

  it 'shows when there is an error', ->
    mockBackend.resetExpectations()
    mockBackend.when('GET', '/api/version').respond(502, 'no gateway')
    mockBackend.flush()

    version = scope.version

    expect(version).toEqual {backend: "error while fetching", app: "error while fetching"}
