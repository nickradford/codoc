wrench = require 'wrench'
fs     = require 'fs'
_      = require 'underscore'
_.str  = require 'underscore.string'
_.mixin  _.str.exports()


module.exports = class Codoc
  ###
  Generate Documentation

  args:
    paths: [] - array of file paths

  ###
  generateDocs: (args)->
    createOutputDir args.output

    files = readFiles args.paths

    console.log files

readFiles = (paths) ->
  files = []
  for path in paths
    _f = wrench.readdirSyncRecursive path
    _f = _.reject _f, (p) ->
      return true if _.str.include p, '.git'
      return true if _.str.include p, 'node_modules'
      return true if fs.statSync(p).isDirectory()
      return true unless _.str.endsWith p, '.coffee'

    files.push _f
    
  _.flatten files
  

createOutputDir = (path) ->
  wrench.mkdirSyncRecursive path, 0o0777