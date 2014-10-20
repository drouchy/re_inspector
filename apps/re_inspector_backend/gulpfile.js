var gulp      = require('gulp');
var gutil     = require('gulp-util');
var connect   = require('gulp-connect');
var gulpif    = require('gulp-if');
var coffee    = require('gulp-coffee');
var concat    = require('gulp-concat');
var tplCache  = require('gulp-angular-templatecache');
var jade      = require('gulp-jade');
var less      = require('gulp-less');
var karma     = require('gulp-karma');

gulp.task('appJS', function() {
  gulp.src(['./web/app/scripts/**/*.js','./web/app/scripts/**/*.coffee'])
    .pipe(gulpif(/[.]coffee$/, coffee({bare: true}).on('error', gutil.log)))
    .pipe(concat('application.js'))
    .pipe(gulp.dest('./priv/static/scripts'))
});

gulp.task('testJS', function() {
  gulp.src([
      './test/web/**/*_test.js',
      './test/web/**/*_test.coffee',
      './test/web/support/*.coffee'
    ])
    .pipe(
      gulpif(/[.]coffee$/,
        coffee({bare: true})
        .on('error', gutil.log)
      )
    )
    .pipe(gulp.dest('./_build/test/web'))
});

gulp.task('test', function() {
  // Be sure to return the stream
  gulp.src(['./_build/test/web/**.js'])
    .pipe(karma({
      configFile: 'test/web/karma.conf.coffee',
      action: 'run'
    }))
    .on('error', function(err) {
      throw err;
    });
});

gulp.task('templates', function() {
  gulp.src(['./web/app/views/**/*.jade'])
    .pipe(gulpif(/[.]jade$/, jade().on('error', gutil.log)))
    .pipe(tplCache('templates.js',{standalone:false, root: '/views', module: 'reInspectorWebApp'}))
    .pipe(gulp.dest('./priv/static/scripts'))
});

gulp.task('libCSS', function() {
  gulp.src([
      './bower_components/bootstrap/dist/css/bootstrap.css',
      './bower_components/bootstrap/dist/css/bootstrap-theme.css',
      './bower_components/highlightjs/styles/default.css',
      './bower_components/font-awesome/css/font-awesome.css'
    ])
    .pipe(concat('vendor.css'))
    .pipe(gulp.dest('./priv/static/styles'))
});

gulp.task('fonts', function() {
    gulp.src([
      'bower_components/font-awesome/fonts/fontawesome-webfont.*',
      'bower_components/bootstrap/fonts/glyphicons-halflings-regular.*'
    ])
    .pipe(gulp.dest('./priv/static/styles/fonts'));
});

gulp.task('appCSS', function() {
  gulp
    .src('./web/app/styles/**/*.less')
    .pipe(less())
    .pipe(concat('application.css'))
    .pipe(gulp.dest('./priv/static/styles'))
});

gulp.task('libJS', function() {
  gulp.src([
    'bower_components/jquery/dist/jquery.js',
    'bower_components/angular/angular.js',
    'bower_components/json3/lib/json3.js',
    'bower_components/bootstrap-sass-official/assets/javascripts/bootstrap/affix.js',
    'bower_components/bootstrap-sass-official/assets/javascripts/bootstrap/alert.js',
    'bower_components/bootstrap-sass-official/assets/javascripts/bootstrap/button.js',
    'bower_components/bootstrap-sass-official/assets/javascripts/bootstrap/carousel.js',
    'bower_components/bootstrap-sass-official/assets/javascripts/bootstrap/collapse.js',
    'bower_components/bootstrap-sass-official/assets/javascripts/bootstrap/dropdown.js',
    'bower_components/bootstrap-sass-official/assets/javascripts/bootstrap/tab.js',
    'bower_components/bootstrap-sass-official/assets/javascripts/bootstrap/transition.js',
    'bower_components/bootstrap-sass-official/assets/javascripts/bootstrap/scrollspy.js',
    'bower_components/bootstrap-sass-official/assets/javascripts/bootstrap/modal.js',
    'bower_components/bootstrap-sass-official/assets/javascripts/bootstrap/tooltip.js',
    'bower_components/bootstrap-sass-official/assets/javascripts/bootstrap/popover.js',
    'bower_components/angular-resource/angular-resource.js',
    'bower_components/angular-cookies/angular-cookies.js',
    'bower_components/angular-sanitize/angular-sanitize.js',
    'bower_components/angular-animate/angular-animate.js',
    'bower_components/angular-touch/angular-touch.js',
    'bower_components/angular-route/angular-route.js',
    'bower_components/angular-bootstrap/ui-bootstrap.js',
    'bower_components/angular-bootstrap/ui-bootstrap-tpls.js',
    'bower_components/underscore/underscore.js',
    'bower_components/highlightjs/highlight.pack.js',
    'bower_components/angular-highlightjs/angular-highlightjs.js',
    'bower_components/momentjs/moment.js'
    ]).pipe(concat('vendor.js'))
      .pipe(gulp.dest('./priv/static/scripts'));
});

gulp.task('index', function() {
  gulp.src(['./app/index.jade', './app/index.html'])
    .pipe(gulpif(/[.]jade$/, jade().on('error', gutil.log)))
    .pipe(gulp.dest('./build'));
});

gulp.task('watch',function() {

  // reload connect server on built file change
  gulp.watch([
      'build/**/*.html',
      'build/**/*.js',
      'build/**/*.css'
  ], function(event) {
      return gulp.src(event.path)
          .pipe(connect.reload());
  });

  // watch files to build
  gulp.watch(['./app/**/*.coffee', '!./app/**/*_test.coffee', './app/**/*.js', '!./app/**/*_test.js'], ['appJS']);
  gulp.watch(['./app/**/*_test.coffee', './app/**/*_test.js'], ['testJS']);
  gulp.watch(['!./app/index.jade', '!./app/index.html', './app/**/*.jade', './app/**/*.html'], ['templates']);
  gulp.watch(['./app/**/*.less', './app/**/*.css'], ['appCSS']);
  gulp.watch(['./app/index.jade', './app/index.html'], ['index']);
});

gulp.task('connect', connect.server({
  root: ['build'],
  port: 9000,
  livereload: true
}));

gulp.task('default', ['connect', 'appJS', 'testJS', 'templates', 'appCSS', 'libCSS', 'fonts', 'index', 'libJS', 'libCSS', 'watch']);
