'use strict'

###*
 # @ngdoc overview
 # @name reInspectorWebApp
 # @description
 # # reInspectorWebApp
 #
 # Main module of the application.
###
angular
  .module('reInspectorWebApp', [
    'ngAnimate',
    'ngCookies',
    'ngResource',
    'ngRoute',
    'ngSanitize',
    'ngTouch',
    'ui.bootstrap',
    'hljs'
  ])
  .config ($routeProvider, $httpProvider, $locationProvider, $provide) ->
    $routeProvider
      .when '/',
        templateUrl: '/views/main.html'
        controller: 'MainCtrl'
      .when '/live',
        templateUrl: '/views/live.html'
        controller: 'LiveCtrl'
      .when '/search',
        templateUrl: '/views/search.html'
        controller: 'SearchCtrl'
      .when '/about',
        templateUrl: '/views/about.html'
        controller: 'AboutCtrl'
      .when '/login',
        templateUrl: '/views/login.html'
        controller: 'LoginCtrl'
      .when '/not_found',
        templateUrl: '/views/not_found.html'
        controller: 'NotFoundCtrl'
      .otherwise
        redirectTo: '/not_found'

    $provide.factory "authenticationInterceptor", ($q, $cookies, $location, $rootScope) ->
      request: (config) ->
        config.headers['Authorization'] = "token #{$cookies.authentication_token}"
        $rootScope.networkError = null
        config

      responseError: (rejection) ->
        if rejection.status == 401
          console.log "unauthenticated", rejection.data
          $cookies.authentication_token = null
          $cookies.login = null
          $location.path("/login")
        else
          $rootScope.networkError = "something went wrong :-( Please retry later - or not -"
        $q.reject(rejection)

    $httpProvider.interceptors.push 'authenticationInterceptor'


    $locationProvider.html5Mode(true)

