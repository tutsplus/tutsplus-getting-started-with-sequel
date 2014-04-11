require "bundler"
Bundler.require
require "yaml"
require "logger"

require_relative "bootstrap"

def query_all
  ap DB[:products]
  ap DB[:products].all

end

def query_order
  ap DB[:products].reverse_order(:name)
  ap DB[:products].reverse_order(:name).all
end

def query_group
  ap DB[:products].group_and_count(:category).inspect
  ap DB[:products].group_and_count(:category).all
end

def query_limit
  ap DB[:products].limit(2).inspect
  ap DB[:products].limit(2).all

  ap DB[:products].order(:name).limit(2).offset(4).inspect
  ap DB[:products].order(:name).limit(2).offset(4).all
end

def query_on_condition
  ap DB[:products].where(id: 1)
  ap DB[:products].where(id: 1).first
end

query_all
