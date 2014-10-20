# Karma configuration
# http://karma-runner.github.io/0.12/config/configuration-file.html
# Generated on 2014-07-12 using
# generator-karma 0.8.3

module.exports = (config) ->
  config.set
    basePath: '../..'

    frameworks: ['jasmine']

    files: [
      'bower_components/jquery/dist/jquery.js'
      'bower_components/angular/angular.js'
      'bower_components/angular-mocks/angular-mocks.js'
      'bower_components/angular-animate/angular-animate.js'
      'bower_components/angular-cookies/angular-cookies.js'
      'bower_components/angular-resource/angular-resource.js'
      'bower_components/angular-route/angular-route.js'
      'bower_components/angular-sanitize/angular-sanitize.js'
      'bower_components/angular-touch/angular-touch.js'
      'bower_components/underscore/underscore.js'
      'bower_components/angular-bootstrap/ui-bootstrap.js'
      'bower_components/highlightjs/highlight.pack.js'
      'bower_components/angular-highlightjs/angular-highlightjs.js'
      'bower_components/angular-highlightjs/angular-highlightjs.js'
      'bower_components/momentjs/moment.js'
      'web/app/scripts/**/*.coffee'
      'priv/static/scripts/templates.js'
      'test/web/support/**/*.coffee'
      'test/web/mock/**/*.coffee'
      'test/web/spec/**/*.coffee'
    ],

    exclude: []

    port: 8080

    logLevel: config.LOG_INFO

    # Start these browsers, currently available:
    # - Chrome
    # - ChromeCanary
    # - Firefox
    # - Opera
    # - Safari (only Mac)
    # - PhantomJS
    # - IE (only Windows)
    browsers: [
      'PhantomJS'
      # 'Chrome'
    ]

    plugins: [
      'karma-phantomjs-launcher'
      'karma-chrome-launcher'
      'karma-jasmine'
      'karma-coffee-preprocessor'
    ]

    autoWatch: true

    singleRun: false

    colors: true

    preprocessors: '**/*.coffee': ['coffee']
