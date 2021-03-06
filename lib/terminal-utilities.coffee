cp = require 'child_process'
{Disposable} = require 'atom'

module.exports =

  execute: (cb, command, params = {}) ->
    outBuf = ''
    proc = cp.exec command.join ' ', { 'encoding': 'utf-8' }
    proc.stderr.on 'data', (data) ->
      if params.includeStdErr then outBuf += data
      params?.onstderr?(data)
    proc.stdout.on 'data', (data) ->
      outBuf += data
      params?.onstdout?(data)
    proc.on 'exit', (c, o, e) ->
      cb c, outBuf
    return proc

  executeSync: (command) ->
    proc = cp.execSync command.join ' ', { 'encoding': 'utf-8' }
    return proc.stdout.read()

  executeInConsole: (command) =>
    if Boolean(@consoleService)
      return @consoleService.run
        identifier: 'pros'
        heading: 'Hello World!'
        command: [command.join ' ']
        options: {}
    else return null

  runInConsole: (params...) =>
    if Boolean(@consoleService)
      return @consoleService.run params
    else return null
