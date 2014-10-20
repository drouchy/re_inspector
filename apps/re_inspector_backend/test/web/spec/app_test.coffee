'use strict'

describe 'Service: search', ->

  beforeEach module 'reInspectorWebApp'

  cookies = {}
  interceptor = {}
  q = {}
  location = {}
  rootScope = {}

  beforeEach inject (authenticationInterceptor, $cookies, $q, $location, $rootScope) ->
    interceptor = authenticationInterceptor
    cookies = $cookies
    q = $q
    location = $location
    rootScope = $rootScope

  describe 'authenticationInterceptor', ->
    it 'builds an interceptor', ->
      expect(interceptor).not.toBe undefined
      expect(interceptor).not.toBe null

    describe 'request', ->
      it 'adds a Authorization header with the authentication token in the cookies', ->
        cookies.authentication_token = "1234567890"

        config = interceptor.request({headers: {}})

        expect(config.headers['Authorization']).toEqual "token 1234567890"

      it 'clears the rootScope network error', ->
        rootScope.networkError = "something went wrong"

        interceptor.request({headers: {}})

        expect(rootScope.networkError).toBe null

    describe 'responseError', ->
      response = {}

      beforeEach ->
        response = {}

      it 'rejects the promise', ->
        spyOn(q, 'reject')

        interceptor.responseError(response)

        expect(q.reject).toHaveBeenCalledWith(response)

      describe 'status 401', ->
        beforeEach -> response.status = 401

        it 'clears the authentication cookie', ->
          cookies.authentication_token = "1234567890"

          interceptor.responseError(response)

          expect(cookies.authentication_token).toBeNull()

        it 'clears the login cookie', ->
          cookies.login = "username"

          interceptor.responseError(response)

          expect(cookies.login).toBeNull()

        it 'redirects to the login page', ->
          interceptor.responseError(response)

          expect(location.path()).toEqual('/login')

      describe 'status other error', ->
        beforeEach -> response.status = 500

        it 'keeps the authentication cookie', ->
          cookies.authentication_token = "1234567890"

          interceptor.responseError(response)

          expect(cookies.authentication_token).toEqual "1234567890"

        it 'clears the login cookie', ->
          cookies.login = "username"

          interceptor.responseError(response)

          expect(cookies.login).toEqual "username"

        it 'sets a network error in the rootScope', ->
          interceptor.responseError(response)

          expect(rootScope.networkError).not.toBe undefined
          expect(rootScope.networkError).not.toBe null
