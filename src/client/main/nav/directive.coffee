class NavCtrl
    constructor: ($rootScope, $location)->
        $rootScope.$on '$locationChangeSuccess', =>
            @setLocation($location.path())

    setLocation: (path)->
        @page =
            if path in ['/leaderboard', '/students', '/hunts', '/grades']
                'leaders'
            else if path in ['', '/']
                'submit'
            else if path in ['/login']
                'login'
            else
                'Other'
                # throw new Error "Unexpected Location: `#{path}`"

NavCtrl.$inject = [
    '$rootScope'
    '$location'
]

angular.module('teals.nav.directive', [
    'teals.templates'
])
.controller('NavCtrl', NavCtrl)
.directive 'topnav', ->
    replace: true
    controller: 'NavCtrl'
    controllerAs: 'nav'
    templateUrl: 'main/nav'
    restrict: 'AE'
