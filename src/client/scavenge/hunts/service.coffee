class ScavengerHuntsService
    constructor: ($resource, $q)->
        defer = $q.defer()
        @loaded = defer.promise
        @Hunts = $resource('/api/v1/hunts/:id', {id: '@_id'})
        @hunts = @Hunts.query =>
            @hunts.forEach (hunt)->
                hunt._map = {}
                hunt.scripts.forEach (script, id)-> script.idx = id + 1
                hunt.scripts.reduce ((a, b)->a[b.name] = b; a), hunt._map
            defer.resolve(@hunts)

    findHunt: (name)->
        for hunt in @hunts
            if hunt._map[name]?
                return hunt
        null

    findScript: (name)->
        for hunt in @hunts
            if hunt._map[name]?
                return hunt._map[name]
        null

    checkScriptName: (name)->
        @findScript(name) isnt null

angular.module('teals.hunts.service', [
    'ngResource'
])
.service 'huntservice', ScavengerHuntsService
