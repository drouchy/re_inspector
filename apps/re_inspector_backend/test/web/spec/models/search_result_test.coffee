'use strict'

describe 'Model: SearchResult', ->

  data = {}
  headers = ""

  beforeEach ->
    data = {
      duration: 300,
      request: {
        method: 'GET'
        path: '/uri_1'
      }
      response: {
        body: '{"a":1, "foo":"bar"}'
        status: 200
      },
      service: {
        name: "service 1",
        version: "12.4",
        env: "production"
      }
    }

    headers = {"HTTP_ACCEPT":"application/json","HTTP_AUTHORIZATION":"Bearer 12345","HTTP_HOST":"example.com","HTTP_USER_AGENT":"faraday","HTTP_VERSION":"HTTP/1.0","HTTP_X_FORWARDED_FOR":"::ffff:79.125.112.11","HTTP_X_FORWARDED_PROTO":"https","HTTP_X_NEWRELIC_ID":"VwIOV1dUGwAJV1FXBgQ=","HTTP_X_NEWRELIC_TRANSACTION":"PxQVTQACVEBVOQ==","HTTP_X_REAL_IP":"::ffff:79.125.112.11"}


  describe '#constructor', ->
    it 'is not collapsed', ->
      subject = new SearchResult(data)

      expect(subject.isCollapsed).toBe false

    it 'keeps the data', ->
      subject = new SearchResult(data)

      expect(subject.data).toBe data

  describe '#url', ->
    it 'concatenates the method & path', ->
      subject = new SearchResult(data)

      expect(subject.url()).toEqual 'GET /uri_1'

    it 'upcases the method', ->
      data.request.method = 'get'

      subject = new SearchResult(data)

      expect(subject.url()).toEqual 'GET /uri_1'

  describe '#responseType', ->
    it 'returns "bs-callout-info" for a 2xx', ->
      data.response.status = 201

      subject = new SearchResult(data)

      expect(subject.responseType()).toEqual 'bs-callout-info'

    it 'returns "bs-callout-info" for a 3xx', ->
      data.response.status = 302

      subject = new SearchResult(data)

      expect(subject.responseType()).toEqual 'bs-callout-info'


    it 'returns "bs-callout-warning" for a 4xx', ->
      data.response.status = 404

      subject = new SearchResult(data)

      expect(subject.responseType()).toEqual 'bs-callout-warning'


    it 'returns "bs-callout-danger" for a 5xx', ->
      data.response.status = 500

      subject = new SearchResult(data)

      expect(subject.responseType()).toEqual 'bs-callout-danger'

  describe '#name', ->
    it 'has the name of the data', ->
      data.request_name = 'the name'

      subject = new SearchResult(data)

      expect(subject.name).toEqual 'the name'

  describe '#toggle', ->
    it 'collapses the result when expanded', ->
      subject = new SearchResult()
      subject.isCollapsed = false

      subject.toggle()

      expect(subject.isCollapsed).toBe true

    it 'expand the result when collapsed', ->
      subject = new SearchResult()
      subject.isCollapsed = true

      subject.toggle()

      expect(subject.isCollapsed).toBe false

  describe 'responseBody', ->
    it 'prettyfies the json', ->
      data.response.body = '{"a":1,"b":[1,2,3]}'

      subject = new SearchResult(data)

      expect(subject.responseBody()).toEqual '{\n  "a": 1,\n  "b": [\n    1,\n    2,\n    3\n  ]\n}'

    it 'does not crash with invalid json', ->
      data.response.body = 'invalid'

      subject = new SearchResult(data)

      expect(subject.responseBody()).toEqual 'invalid'

    it 'does not crash with no content', ->
      data.response.body = null

      subject = new SearchResult(data)

      expect(subject.responseBody()).toEqual null

  describe 'requestBody', ->
    it 'prettyfies the json', ->
      data.request.body = '{"a":1,"b":[1,2,3]}'

      subject = new SearchResult(data)

      expect(subject.requestBody()).toEqual '{\n  "a": 1,\n  "b": [\n    1,\n    2,\n    3\n  ]\n}'

    it 'does not crash with invalid json', ->
      data.request.body = 'invalid'

      subject = new SearchResult(data)

      expect(subject.requestBody()).toEqual 'invalid'

    it 'does not crash with no content', ->
      data.request.body = null

      subject = new SearchResult(data)

      expect(subject.requestBody()).toEqual null

  describe 'duration', ->
    it 'formats the milliseconds', ->
      subject = new SearchResult(data)

      expect(subject.duration()).toEqual "300ms"

    it 'formats in second if the duration is more than 1100ms', ->
      data.duration = 1234

      subject = new SearchResult(data)

      expect(subject.duration()).toEqual "1.2s"

    it 'formats the duration even if passed as a string', ->
      data.duration = '1234'

      subject = new SearchResult(data)

      expect(subject.duration()).toEqual "1.2s"

  describe 'service', ->
    it 'concatenates the service name & version', ->
      subject = new SearchResult(data)

      expect(subject.service()).toEqual "service 1 - 12.4 - production"

  describe 'requestHeaders', ->
    it 'returns the headers of the request', ->
      data.request.headers = headers

      subject = new SearchResult(data)

      expect(subject.requestHeaders()).toEqual headers

  describe 'responseHeaders', ->
    it 'returns the headers of the response', ->
      data.response.headers = headers

      subject = new SearchResult(data)

      expect(subject.responseHeaders()).toEqual headers

  describe 'correlations', ->
    it 'returns the correlations in the data', ->
      data.correlations = ["1", "2"]

      subject = new SearchResult(data)

      expect(subject.correlations()).toEqual ["1", "2"]
