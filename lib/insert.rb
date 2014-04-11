require "bundler"
Bundler.require
require "yaml"
require "logger"

require_relative "bootstrap"

id = DB[:products].insert(name: "Cellphone", category: "Electronics")
ap DB[:products].where(id: id).first
