wrench = require 'wrench'
fs     = require 'fs'
_      = require 'underscore'
_.str  = require 'underscore.string'
_.mixin  _.str.exports()

### Coffeescript Documentation Generator
###
module.exports = class Codoc
  ### Generate Documentation

  args:
    paths: [] - array of file paths

  ###
  generateDocs: (args)->
    createOutputDir args.output

    files = getFilePaths args.paths

    for file in files
      sections = parseFile fs.readFileSync file, 'utf8'

    _(sections).each (section) ->
      parseComment section.comment
    
    
###! PRIVATE ###

###
Return the list of file paths.
###
getFilePaths = (paths) ->
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

  
###
Create the output directory, recursively.
###
createOutputDir = (path) ->
  wrench.mkdirSyncRecursive path, 0o0777

parseFile = (source) ->
  inComment = false
  commentString = ""
  codeString = ""
  sections = []
  isPrivate = false
  
  for line in source.split '\n'
    line = _(line).trim()
    isPrivate = true if line is "###! PRIVATE ###"
    if _(line).startsWith('###') or inComment
      if not inComment and _(line).startsWith('###')
        # store current commentString and codeString
        unless commentString is "" and codeString is ""
          sections.push
            comment: commentString
            code: codeString
          commentString = ""
          codeString = ""
        inComment = true
      else if _(line).startsWith('###')
        inComment = false
        commentString += line + '\n'

      if inComment
        commentString += line + '\n'
    else
        codeString += line + '\n'

    if isPrivate
      return sections
  sections.push
    comment: commentString
    code: codeString
  commentString = ""
  codeString = ""
  
  # _(sections).each (section) -> console.log 'section', section
  sections = _(sections).reject (section) -> section.comment is ""
  sections

parseComment = (comment) ->
  arr = comment.split '\n'
  arr = _(arr).reject (str) -> 
    return true if _.str.include str, '###'
    return true if str is ''

  console.log comment

renderFile = () ->