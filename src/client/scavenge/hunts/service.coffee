class ScavengerHuntsService
    constructor: ($resource, $q)->
        defer = $q.defer()
        @loaded = defer.promise
        @Hunts = $resource('/api/v1/hunts/:id', {id: '@_id'})
        @hunts = @Hunts.query =>
            @hunts.forEach (hunt)->
                hunt._items = {}
                hunt.scripts.forEach (script, id)-> script.id = id + 1
                hunt.scripts.reduce ((a, b)->a[b.name] = b; a), hunt._items
            defer.resolve(@hunts)

    findScript: (name)->
        for hunt in @hunts
            if hunt._items[name]?
                return hunt._items[name]
        null

    checkScriptName: (name)->
        @findScript(name) isnt null

angular.module('teals.hunts.service', [
    'ngResource'
])
.service 'huntservice', ScavengerHuntsService
