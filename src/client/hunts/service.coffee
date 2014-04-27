class ScavengerHuntsService
    constructor: (@$http, $q)->
        @items = {}
        @itemList = []
        defer = $q.defer()
        @loaded = defer.promise
        @$http.get('/assets/scavengerhunt.json').then (_)=>
            angular.extend @itemList, _.data.scripts
            # Distill itemList into items
            @itemList.reduce ((a, b)->a[b.name] = b; a), @items
            defer.resolve()

    checkScriptName: (name)->
        @items[name]?

angular.module('teals.hunts.service', [])
.service 'huntservice', ($http, $q)->
    new ScavengerHuntsService $http, $q
