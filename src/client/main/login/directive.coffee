angular.module('teals.scavenger')
.run ($rootScope, $location, $cookies)->
    loginRedirect = ->
        unless $cookies.li or $location.path() is '/login'
            $location.path('/login')
    $rootScope.$on '$locationChangeStart', loginRedirect
    loginRedirect()

class LoginCtrl
    constructor: ->

LoginCtrl.$inject = []

angular.module('teals.login.directive', [
    'teals.templates'
])
.controller('LoginCtrl', LoginCtrl)
.directive 'login', ->
    controller: 'LoginCtrl'
    controllerAs: 'login'
    templateUrl: 'main/login'
    restrict: 'AE'
