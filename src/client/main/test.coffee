describe 'Scavenger Main', ->
    beforeEach ->
        angular.module('ui.bootstrap', [])
        angular.module('ui.codemirror', [])
        module 'teals.scavenger'

    it 'should load a module', inject ($route)->
        should.exist $route.routes['/leaderboard']
