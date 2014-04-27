angular.module('teals.scavenger', [
    'ngRoute'
    'ui.bootstrap'
    'ui.codemirror'
    'teals.leaders.directive'
    'teals.submissions.directive'
    'teals.hunts.directive'
    'teals.nav.directive'
    'teals.templates'
]).config (
    $routeProvider,
    $locationProvider
)->
    $locationProvider.html5Mode true
    $routeProvider.when '/leaderboard',
        template: '<leaders></leaders>'
    $routeProvider.otherwise
        template: '<submissions></submissions>'
