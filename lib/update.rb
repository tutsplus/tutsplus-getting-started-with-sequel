require "bundler"
Bundler.require
require "yaml"

require_relative "bootstrap"

item = DB[:products].first
ap "Item is #{item[:name]}."
new_item = item.update name: "Goldfish"
ap new_item
