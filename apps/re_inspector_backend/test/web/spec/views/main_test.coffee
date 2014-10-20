"use strict"

describe "main", ->

  beforeEach module("reInspectorWebApp")

  template = undefined
  scope = {}
  compile = {}
  view = {}

  beforeEach inject ($templateCache, $rootScope, $compile) ->
    template = $templateCache.get('/views/main.html')
    scope = $rootScope.$new()
    compile = $compile

  xit 'loads the template', ->
    expect(template).toBeDefined()

  xdescribe 'when loading the page', ->
    beforeEach ->
      console.log 'loading the page'
      scope.errors = undefined
      scope.results = []
      scope.query = ''

      compileTemplate()

    it 'hides the errors alert', ->
      alerts = view.find('div.alert')

      expect(alerts.length).toBe 0

    it 'hides the errors image', ->
      image = view.find('#yeoman-error')

      expect(image.hasClass('ng-hide')).toBe true

    it 'shows the yeoman image', ->
      image = view.find('#yeoman')

      expect(image.hasClass('ng-hide')).toBe false

  xdescribe 'with an error on the page', ->
    beforeEach ->
      console.log 'loading the page'
      scope.error = 'an error message'

      compileTemplate()

    # odd
    xit 'hides the errors alert', ->
      alerts = view.find('div.alert')

      expect(alerts.length).toBe 1

    it 'shows the errors image', ->
      image = view.find('#yeoman-error')

      expect(image.hasClass('ng-hide')).toBe false

    it 'hides the yeoman image', ->
      image = view.find('#yeoman')

      expect(image.hasClass('ng-hide')).toBe true

  compileTemplate = ->
    dom = "<div ng-view>#{template}</div>"
    view = compile(angular.element(dom).contents())(scope)

    scope.$apply()
