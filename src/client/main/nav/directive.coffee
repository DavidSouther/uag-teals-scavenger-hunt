class NavCtrl
    constructor: ($rootScope, $location)->
        $rootScope.$on '$locationChangeSuccess', =>
            @setLocation($location.path())

    setLocation: (path)->
        @page =
            if path is '/leaderboard'
                'leaders'
            else if path in ['', '/']
                'submit'
            else
                throw new Error "Unexpected Location: `#{path}`"

NavCtrl.$inject = [
    '$rootScope'
    '$location'
]

angular.module('teals.nav.directive', [
    'teals.templates'
])
.controller('NavCtrl', NavCtrl)
.directive 'topnav', ->
    controller: 'NavCtrl'
    controllerAs: 'nav'
    templateUrl: 'main/nav'
    restrict: 'AE'
