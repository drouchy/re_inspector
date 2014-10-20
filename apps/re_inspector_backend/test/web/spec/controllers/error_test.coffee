'use strict'

describe 'Controller: ErrorCtrl', ->

  beforeEach module 'reInspectorWebApp'

  MainCtrl = {}
  rootScope = {}
  scope = {}
  location = {}

  beforeEach inject ($controller, $rootScope, $location) ->
    rootScope = $rootScope
    scope = $rootScope.$new()
    location = $location

    MainCtrl = $controller 'ErrorCtrl', {$scope: scope }

  it 'watches the changes on the rootScope networkError', ->
    rootScope.networkError = "an error"

    rootScope.$digest()

    expect(scope.error).toEqual "an error"

