'use strict';

/**
  * @ngdoc overview
  * @name reInspectorWebApp
  * @description
  * # reInspectorWebApp
  *
  * Main module of the application.
 */
angular.module('reInspectorWebApp', ['ngAnimate', 'ngCookies', 'ngResource', 'ngRoute', 'ngSanitize', 'ngTouch', 'ui.bootstrap', 'hljs']).config(function($routeProvider, $httpProvider, $locationProvider, $provide) {
  $routeProvider.when('/', {
    templateUrl: '/views/main.html',
    controller: 'MainCtrl'
  }).when('/live', {
    templateUrl: '/views/live.html',
    controller: 'LiveCtrl'
  }).when('/search', {
    templateUrl: '/views/search.html',
    controller: 'SearchCtrl'
  }).when('/about', {
    templateUrl: '/views/about.html',
    controller: 'AboutCtrl'
  }).when('/login', {
    templateUrl: '/views/login.html',
    controller: 'LoginCtrl'
  }).when('/not_found', {
    templateUrl: '/views/not_found.html',
    controller: 'NotFoundCtrl'
  }).otherwise({
    redirectTo: '/not_found'
  });
  $provide.factory("authenticationInterceptor", function($q, $cookies, $location, $rootScope) {
    return {
      request: function(config) {
        config.headers['Authorization'] = "token " + $cookies.authentication_token;
        $rootScope.networkError = null;
        return config;
      },
      responseError: function(rejection) {
        if (rejection.status === 401) {
          console.log("unauthenticated", rejection.data);
          $cookies.authentication_token = null;
          $cookies.login = null;
          $location.path("/login");
        } else {
          $rootScope.networkError = "something went wrong :-( Please retry later - or not -";
        }
        return $q.reject(rejection);
      }
    };
  });
  $httpProvider.interceptors.push('authenticationInterceptor');
  return $locationProvider.html5Mode(true);
});

this.Phoenix = {};

this.Phoenix.Channel = (function() {
  Channel.prototype.bindings = null;

  function Channel(channel, topic, message, callback, socket) {
    this.channel = channel;
    this.topic = topic;
    this.message = message;
    this.callback = callback;
    this.socket = socket;
    this.reset();
  }

  Channel.prototype.reset = function() {
    return this.bindings = [];
  };

  Channel.prototype.on = function(event, callback) {
    return this.bindings.push({
      event: event,
      callback: callback
    });
  };

  Channel.prototype.isMember = function(channel, topic) {
    return this.channel === channel && this.topic === topic;
  };

  Channel.prototype.off = function(event) {
    var bind;
    return this.bindings = (function() {
      var _i, _len, _ref, _results;
      _ref = this.bindings;
      _results = [];
      for (_i = 0, _len = _ref.length; _i < _len; _i++) {
        bind = _ref[_i];
        if (bind.event !== event) {
          _results.push(bind);
        }
      }
      return _results;
    }).call(this);
  };

  Channel.prototype.trigger = function(triggerEvent, msg) {
    var callback, event, _i, _len, _ref, _ref1, _results;
    console.log("phoenix trigger", triggerEvent, msg);
    _ref = this.bindings;
    _results = [];
    for (_i = 0, _len = _ref.length; _i < _len; _i++) {
      _ref1 = _ref[_i], event = _ref1.event, callback = _ref1.callback;
      if (event === triggerEvent) {
        _results.push(callback(msg));
      }
    }
    return _results;
  };

  Channel.prototype.send = function(event, message) {
    return this.socket.send({
      channel: this.channel,
      topic: this.topic,
      event: event,
      message: message
    });
  };

  Channel.prototype.leave = function(message) {
    if (message == null) {
      message = {};
    }
    this.socket.leave(this.channel, this.topic, message);
    return this.reset();
  };

  return Channel;

})();

this.Phoenix.Socket = (function() {
  Socket.prototype.conn = null;

  Socket.prototype.endPoint = null;

  Socket.prototype.channels = null;

  Socket.prototype.sendBuffer = null;

  Socket.prototype.sendBufferTimer = null;

  Socket.prototype.flushEveryMs = 50;

  Socket.prototype.reconnectTimer = null;

  Socket.prototype.reconnectAfterMs = 5000;

  function Socket(endPoint) {
    this.endPoint = endPoint;
    this.channels = [];
    this.sendBuffer = [];
    this.resetBufferTimer();
    this.reconnect();
  }

  Socket.prototype.close = function(callback) {
    if (this.conn != null) {
      this.conn.onclose = (function(_this) {
        return function() {};
      })(this);
      this.conn.close();
      this.conn = null;
    }
    return typeof callback === "function" ? callback() : void 0;
  };

  Socket.prototype.reconnect = function() {
    return this.close((function(_this) {
      return function() {
        _this.conn = new WebSocket(_this.endPoint);
        _this.conn.onopen = function() {
          return _this.onOpen();
        };
        _this.conn.onerror = function(error) {
          return _this.onError(error);
        };
        _this.conn.onmessage = function(event) {
          return _this.onMessage(event);
        };
        return _this.conn.onclose = function(event) {
          return _this.onClose(event);
        };
      };
    })(this));
  };

  Socket.prototype.resetBufferTimer = function() {
    clearTimeout(this.sendBufferTimer);
    return this.sendBufferTimer = setTimeout(((function(_this) {
      return function() {
        return _this.flushSendBuffer();
      };
    })(this)), this.flushEveryMs);
  };

  Socket.prototype.onOpen = function() {
    clearInterval(this.reconnectTimer);
    return this.rejoinAll();
  };

  Socket.prototype.onClose = function(event) {
    if (typeof console.log === "function") {
      console.log("WS close: " + event);
    }
    clearInterval(this.reconnectTimer);
    return this.reconnectTimer = setInterval(((function(_this) {
      return function() {
        return _this.reconnect();
      };
    })(this)), this.reconnectAfterMs);
  };

  Socket.prototype.onError = function(error) {
    return typeof console.log === "function" ? console.log("WS error: " + error) : void 0;
  };

  Socket.prototype.connectionState = function() {
    var _ref, _ref1;
    switch ((_ref = (_ref1 = this.conn) != null ? _ref1.readyState : void 0) != null ? _ref : 3) {
      case 0:
        return "connecting";
      case 1:
        return "open";
      case 2:
        return "closing";
      case 3:
        return "closed";
    }
  };

  Socket.prototype.isConnected = function() {
    return this.connectionState() === "open";
  };

  Socket.prototype.rejoinAll = function() {
    var chan, _i, _len, _ref, _results;
    _ref = this.channels;
    _results = [];
    for (_i = 0, _len = _ref.length; _i < _len; _i++) {
      chan = _ref[_i];
      _results.push(this.rejoin(chan));
    }
    return _results;
  };

  Socket.prototype.rejoin = function(chan) {
    var channel, message, topic;
    chan.reset();
    channel = chan.channel, topic = chan.topic, message = chan.message;
    console.log("send channel event 'join'", channel);
    this.send({
      channel: channel,
      topic: topic,
      event: "join",
      message: message
    });
    return chan.callback(chan);
  };

  Socket.prototype.join = function(channel, topic, message, callback) {
    var chan;
    chan = new Phoenix.Channel(channel, topic, message, callback, this);
    this.channels.push(chan);
    if (this.isConnected()) {
      return this.rejoin(chan);
    }
  };

  Socket.prototype.leave = function(channel, topic, message) {
    var c;
    if (message == null) {
      message = {};
    }
    this.send({
      channel: channel,
      topic: topic,
      event: "leave",
      message: message
    });
    return this.channels = (function() {
      var _i, _len, _ref, _results;
      _ref = this.channels;
      _results = [];
      for (_i = 0, _len = _ref.length; _i < _len; _i++) {
        c = _ref[_i];
        if (!(c.isMember(channel, topic))) {
          _results.push(c);
        }
      }
      return _results;
    }).call(this);
  };

  Socket.prototype.send = function(data) {
    var callback;
    callback = (function(_this) {
      return function() {
        return _this.conn.send(JSON.stringify(data));
      };
    })(this);
    if (this.isConnected()) {
      return callback();
    } else {
      return this.sendBuffer.push(callback);
    }
  };

  Socket.prototype.flushSendBuffer = function() {
    var callback, _i, _len, _ref;
    if (this.isConnected() && this.sendBuffer.length > 0) {
      _ref = this.sendBuffer;
      for (_i = 0, _len = _ref.length; _i < _len; _i++) {
        callback = _ref[_i];
        callback();
      }
      this.sendBuffer = [];
    }
    return this.resetBufferTimer();
  };

  Socket.prototype.onMessage = function(rawMessage) {
    var chan, channel, event, message, topic, _i, _len, _ref, _ref1, _results;
    if (typeof console.log === "function") {
      console.log(rawMessage);
    }
    _ref = JSON.parse(rawMessage.data), channel = _ref.channel, topic = _ref.topic, event = _ref.event, message = _ref.message;
    _ref1 = this.channels;
    _results = [];
    for (_i = 0, _len = _ref1.length; _i < _len; _i++) {
      chan = _ref1[_i];
      if (chan.isMember(channel, topic)) {
        _results.push(chan.trigger(event, message));
      }
    }
    return _results;
  };

  return Socket;

})();

'use strict';

/**
  * @ngdoc function
  * @name reInspectorWebApp.controller:AboutCtrl
  * @description
  * # AboutCtrl
  * Controller of the reInspectorWebApp
 */
angular.module('reInspectorWebApp').controller('AboutCtrl', function($scope, $http) {
  var error_version;
  $scope.version = {
    backend: 'fetching',
    app: 'fetching'
  };
  $http.get("/api/version").success(function(data, status, headers) {
    return $scope.version = data.version;
  }).error(function(data, status, headers) {
    return $scope.version = error_version();
  });
  return error_version = function() {
    return {
      backend: 'error while fetching',
      app: 'error while fetching'
    };
  };
});

'use strict';
angular.module('reInspectorWebApp').controller('ErrorCtrl', function($scope, $rootScope) {
  console.log("error ctrl");
  $scope.error = '';
  return $rootScope.$watch('networkError', (function(_this) {
    return function(newValue) {
      return $scope.error = newValue;
    };
  })(this));
});

'use strict';
angular.module('reInspectorWebApp').controller('LiveCtrl', function($scope, $location, $cookies, searchService) {
  var socket;
  console.log("Live controller", $location.host());
  $scope.filter = "";
  $scope.results = [];
  socket = new Phoenix.Socket("ws://" + $location.host() + "/ws");
  socket.join("re_inspector", "api_request", {
    authentication: $cookies.authentication_token
  }, function(channel) {
    channel.on("join", function(message) {
      return console.log("joined successfully");
    });
    return channel.on("new:request", function(message) {
      return $scope.newRequestReceived(message);
    });
  });
  $scope.newRequestReceived = function(message) {
    console.log("new message", message);
    return searchService.find(message.path).then(function(api_request) {
      return $scope.newRequest(api_request);
    }, function(error) {
      return console.log("error: ", error);
    });
  };
  $scope.filterResults = function() {
    return console.log("filter results with " + $scope.filter);
  };
  return $scope.newRequest = function(api_request) {
    var _results;
    $scope.results.unshift(api_request);
    _results = [];
    while ($scope.results.length > 100) {
      _results.push($scope.results.pop());
    }
    return _results;
  };
});

'use strict';

/**
  * @ngdoc function
  * @name reInspectorWebApp.controller:MainCtrl
  * @description
  * # MainCtrl
  * Controller of the reInspectorWebApp
 */
angular.module('reInspectorWebApp').controller('LoginCtrl', function($scope, $routeParams) {
  console.log("login ctrl", $routeParams);
  return $scope.query = '';
});

'use strict';

/**
  * @ngdoc function
  * @name reInspectorWebApp.controller:MainCtrl
  * @description
  * # MainCtrl
  * Controller of the reInspectorWebApp
 */
angular.module('reInspectorWebApp').controller('MainCtrl', function($scope, $http, $location, $routeParams, $cookies, $route) {
  console.log("main ctrl", $routeParams);
  $scope.query = '';
  $scope.authenticate = function() {
    console.log("authenticated");
    $cookies.authentication_token = $routeParams.authentication_token;
    $cookies.login = $routeParams.login;
    return $routeParams = {};
  };
  $scope.search = function() {
    console.log("searching '" + $scope.query + "'");
    $location.search("q", $scope.query);
    return $location.path("/search");
  };
  if ($routeParams['authentication_token']) {
    return $scope.authenticate();
  }
});

'use strict';

/**
  * @ngdoc function
  * @name reInspectorWebApp.controller:AboutCtrl
  * @description
  * # NotFoundCtrl
  * Controller of the reInspectorWebApp
 */
angular.module('reInspectorWebApp').controller('NotFoundCtrl', function($scope) {});

'use strict';

/**
  * @ngdoc function
  * @name reInspectorWebApp.controller:MainCtrl
  * @description
  * # MainCtrl
  * Controller of the reInspectorWebApp
 */
angular.module('reInspectorWebApp').controller('SearchCtrl', function($scope, $http, $location, $routeParams, searchService) {
  $scope.query = $routeParams.q;
  $scope.noResults = false;
  $scope.showAllResults = false;
  $scope.results = [];
  $scope.pagination = {};
  $scope.search = function() {
    $scope.showAllResults = false;
    $location.search("q", $scope.query);
    $location.path("/search");
    return $scope.executeSearch();
  };
  $scope.executeSearch = function() {
    console.log("searching '" + $scope.query + "'");
    $scope.__discard_results();
    return $scope.__search("/api/search?q=" + $scope.query);
  };
  $scope.loadMore = function() {
    console.log("loading page " + $scope.pagination.next_page);
    return $scope.__search($scope.pagination.next_page);
  };
  $scope.loadAll = function() {
    console.log("showing all results " + $scope.pagination.all_results);
    $scope.showAllResults = true;
    $scope.__discard_results();
    return $scope.__search($scope.pagination.all_results);
  };
  $scope.__search = function(path) {
    $scope.searching = true;
    return searchService.search(path).then(function(data) {
      _.each(data.results, function(v) {
        return $scope.results.push(v);
      });
      $scope.pagination = data.pagination;
      $scope.noResults = data.results.length === 0;
      return $scope.searching = false;
    }, function(error) {
      $scope.noResults = false;
      return $scope.searching = false;
    });
  };
  $scope.__discard_results = function() {
    var _results;
    _results = [];
    while ($scope.results.length > 0) {
      _results.push($scope.results.shift());
    }
    return _results;
  };
  return $scope.executeSearch();
});

this.SearchResult = (function() {
  var format;

  function SearchResult(http_data) {
    if (http_data == null) {
      http_data = {};
    }
    this.isCollapsed = false;
    this.data = http_data;
    this.name = http_data.request_name;
  }

  SearchResult.prototype.toggle = function() {
    return this.isCollapsed = !this.isCollapsed;
  };

  SearchResult.prototype.responseType = function() {
    var status;
    status = this.data.response.status;
    switch (false) {
      case !(status < 400):
        return 'bs-callout-info';
      case !(status < 500):
        return 'bs-callout-warning';
      default:
        return 'bs-callout-danger';
    }
  };

  SearchResult.prototype.requestBody = function() {
    return format(this.data.request.body);
  };

  SearchResult.prototype.responseBody = function() {
    return format(this.data.response.body);
  };

  SearchResult.prototype.url = function() {
    return "" + (this.data.request.method.toUpperCase()) + " " + this.data.request.path;
  };

  SearchResult.prototype.duration = function() {
    var duration;
    duration = moment.duration(parseInt(this.data.duration));
    if (duration.asMilliseconds() < 1100) {
      return "" + (duration.asMilliseconds()) + "ms";
    } else {
      return "" + (duration.asSeconds().toFixed(1)) + "s";
    }
  };

  SearchResult.prototype.correlations = function() {
    return this.data.correlations;
  };

  SearchResult.prototype.requestHeaders = function() {
    return this.data.request.headers;
  };

  SearchResult.prototype.responseHeaders = function() {
    return this.data.response.headers;
  };

  SearchResult.prototype.executedAt = function() {
    return this.__executionDate__().format('dddd, MMMM Do YYYY, hh:mm:ss');
  };

  SearchResult.prototype.timeAgo = function() {
    return this.__executionDate__().fromNow();
  };

  SearchResult.prototype.service = function() {
    return "" + this.data.service.name + " - " + this.data.service.version + " - " + this.data.service.env;
  };

  SearchResult.prototype.__executionDate__ = function() {
    return moment(this.data.requested_at);
  };

  format = function(json) {
    var SyntaxError;
    if (!json) {
      return null;
    }
    try {
      return JSON.stringify(JSON.parse(json), null, 2);
    } catch (_error) {
      SyntaxError = _error;
      return json;
    }
  };

  return SearchResult;

})();

angular.module('reInspectorWebApp').factory('searchService', function($http, $q) {
  return {
    search: function(path) {
      var deferred;
      console.log("loading path " + path);
      deferred = $q.defer();
      $http.get(path).success((function(_this) {
        return function(data, status, headers) {
          return deferred.resolve(_this.transformData(data));
        };
      })(this)).error((function(_this) {
        return function(data, status, headers) {
          return deferred.reject(data);
        };
      })(this));
      return deferred.promise;
    },
    find: function(path) {
      var deferred;
      console.log("find request " + path);
      deferred = $q.defer();
      $http.get(path).success((function(_this) {
        return function(data, status, headers) {
          return deferred.resolve(_this.transformOneEntry(data['api_request']));
        };
      })(this)).error((function(_this) {
        return function(data, status, headers) {
          return deferred.reject(data);
        };
      })(this));
      return deferred.promise;
    },
    transformData: function(data) {
      return {
        results: _.map(data.results, (function(_this) {
          return function(entry) {
            return _this.transformOneEntry(entry);
          };
        })(this)),
        pagination: data.pagination
      };
    },
    transformOneEntry: function(entry) {
      return new SearchResult(entry);
    }
  };
});
