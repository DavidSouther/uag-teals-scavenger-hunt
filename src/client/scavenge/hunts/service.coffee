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

    byId: (id)->
        for hunt in @hunts
            if hunt._id is id
                return hunt
        {name: 'INVALID'}

    findHunt: (name)->
        for hunt in @hunts
            if hunt._map[name]?
                return hunt
        {name: 'INVALID'}

    findScript: (name)->
        # HACK for currDayOfWeek
        if name is 'currDayOfWeek.py' then name = 'currDayOfWeek'
        # END HACK
        for hunt in @hunts
            if hunt._map[name]?
                return hunt._map[name]
        {name: 'INVALID.py', points: 0}

    checkScriptName: (name)->
        @findScript(name) isnt null

angular.module('teals.hunts.service', [
    'ngResource'
])
.service 'huntservice', ScavengerHuntsService
