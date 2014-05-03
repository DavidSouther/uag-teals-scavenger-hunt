angular.module('teals.scavenger')
.run ($rootScope, $location, $cookies)->
    loginRedirect = ->
        unless $cookies.li or $location.path() is '/login'
            $location.path('/login')
    $rootScope.$on '$locationChangeStart', loginRedirect
    loginRedirect()

class LoginCtrl
    constructor: ($cookies)->
        @mocks = $cookies.NODE_ENV is 'development'

LoginCtrl.$inject = [
    '$cookies'
]

angular.module('teals.login.directive', [
    'teals.templates'
    'ngCookies'
])
.controller('LoginCtrl', LoginCtrl)
.directive 'login', ->
    controller: 'LoginCtrl'
    controllerAs: 'login'
    templateUrl: 'main/login'
    restrict: 'AE'
