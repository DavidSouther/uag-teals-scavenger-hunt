describe 'File Input', ->
    beforeEach module 'teals.scavenger.fileInput'

    it.skip 'renders', ->
        $element = render 'file-input'
        $element[0].attr('type').should.equal 'file'
