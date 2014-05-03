mod = angular.module('teals.scavenger', [
    'ngRoute'
    'ui.bootstrap'
    'ui.codemirror'
    'teals.leaders.directive'
    'teals.students.directive'
    'teals.submissions.directive'
    'teals.hunts.directive'
    'teals.nav.directive'
    'teals.login.directive'
    'teals.footer.directive'
    'teals.templates'
    'ngCookies'
])
mod.config (
    $routeProvider,
    $locationProvider
)->
    $locationProvider.html5Mode true
    $routeProvider.when '/students',
        template: '<students></students>'
    $routeProvider.when '/leaderboard',
        template: '<leaders></leaders><huntlist></huntlist>'
    $routeProvider.when '/login',
        template: '<login></login>'
    $routeProvider.otherwise
        template: '<submissions></submissions><huntlist></huntlist>'


