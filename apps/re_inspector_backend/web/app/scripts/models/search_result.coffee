class @SearchResult
  constructor: (http_data = {}) ->
    @isCollapsed = false
    @data = http_data
    @name = http_data.request_name

  toggle: ->
    @isCollapsed = !@isCollapsed

  responseType: ->
    status = @data.response.status
    switch
      when status < 400 then 'bs-callout-info'
      when status < 500 then 'bs-callout-warning'
      else 'bs-callout-danger'

  requestBody: ->
    format(@data.request.body)

  responseBody: ->
    format(@data.response.body)

  url: ->
    "#{@data.request.method.toUpperCase()} #{@data.request.path}"

  duration: ->
    duration = moment.duration(parseInt @data.duration)
    if duration.asMilliseconds() < 1100
      "#{duration.asMilliseconds()}ms"
    else
      "#{duration.asSeconds().toFixed(1)}s"

  correlations: ->
    @data.correlations

  requestHeaders: ->
    @data.request.headers

  responseHeaders: ->
    @data.response.headers

  executedAt: ->
    @__executionDate__().format('dddd, MMMM Do YYYY, hh:mm:ss')

  timeAgo: ->
    @__executionDate__().fromNow()

  service: ->
    "#{@data.service.name} - #{@data.service.version} - #{@data.service.env}"

  __executionDate__: ->
    moment @data.requested_at

  format = (json) ->
    return null unless json
    try
      JSON.stringify JSON.parse(json), null, 2
    catch SyntaxError
      json
