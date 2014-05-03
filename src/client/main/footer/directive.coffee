class FooterCtrl
    constructor: ($cookies)->
        @loggedin = $cookies.li is '1'
        @admin = false

FooterCtrl.$inject = [
    '$cookies'
]

angular.module('teals.footer.directive', [
    'teals.templates'
    'ngCookies'
]).controller('FooterCtrl', FooterCtrl)
.directive 'footer', ->
    restrict: 'AE'
    replace: false
    controller: 'FooterCtrl'
    controllerAs: 'footer'
    templateUrl: 'main/footer'
