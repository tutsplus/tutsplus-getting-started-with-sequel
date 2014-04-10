require "bundler"
Bundler.require
require "yaml"

def connect_regular
  db = Sequel.connect("postgres://jose@localhost/my_app")

  puts db[:posts].inspect
  puts db[:posts].all.inspect
end

def connect_yaml
  file_path = File.expand_path("../../test/assets/database.yaml", __FILE__)
  data = YAML.load_file file_path
  db = Sequel.connect(data)

  puts db[:posts].inspect
  puts db[:posts].all.inspect
end
