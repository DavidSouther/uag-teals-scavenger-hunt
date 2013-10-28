if angular.mock
    window.render = angular.mock.render = (directive, attrs, data)->
        $element = null
        inject ($compile, $rootScope)->
            $scope = $rootScope.$new()

            # Copy data into $scope
            $scope[key] = val for key, val of data
            # Build an array of attribute 'name="value"' strings
            attributes = ["#{key}=\"#{attrs[key]}\"" for key of attrs].join ' '

            template = $compile("<div #{directive} #{attributes}></div>")
            $element = template($scope)

            try $scope.$digest()

        $element
