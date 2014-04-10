require "bundler"
Bundler.require
require "yaml"

require_relative "bootstrap"

result = DB[:products].where(id: [ 3, 4 ]).delete
item = DB[:products].where(id: [ 3, 4 ]).first

ap item
ap result
