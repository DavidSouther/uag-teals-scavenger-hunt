Path = require "path"
client = Path.join global.root, 'build', 'client'

route = (app)->
    app.use (req, res, next)->
        if req.path.match /\.(html|css|js|map|png|svg|json|gif|ttf)$/
            # Statically serve .{asset} files
            next()
        else
            # Serve the index
            res.sendfile Path.join client, 'index.html'
    .use(require('st')(client))

module.exports = route
