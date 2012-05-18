fs = require 'fs'
jade = require 'jade'

file = fs.readFileSync './lib/templates/index.jade', 'utf8'

options = 
  locals: 
    foo: 'hello!'

fn = jade.compile file

console.log fn
  foo: 'hello'