class ScavengerHuntsService
    constructor: (@$http)->
        @items = {}
        @itemList = []
        @$http.get('/assets/scavengerhunt.json').then (_)=>
            angular.extend @itemList, _.data.scripts
            # Distill itemList into items
            @itemList.reduce ((a, b)->a[b.name] = b; a), @items

    checkScriptName: (name)->
        @items[name]?

angular.module('teals.hunts.service', [])
.service 'huntservice', ($http)->
    new ScavengerHuntsService $http
