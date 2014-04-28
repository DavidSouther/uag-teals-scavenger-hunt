spawn = require('child_process').spawn

runFile = (file, cb)->
    log = ''
    python = spawn 'python', [file]
    python.stdout.on 'data', (data)-> log += data
    python.stderr.on 'data', (data)-> log += data
    python.on 'exit', (code)->
        if code is 0
            cb null, log
        else
            cb code, log

    end = (signal, code)->
        python.kill signal
        _cb = cb
        cb = ->
        _cb code, log

    term = -> end 'SIGTERM', 15
    kill = -> end 'SIGKILL', 9
    setTimeout kill, 100
    setTimeout term, 1000

module.exports = runFile
