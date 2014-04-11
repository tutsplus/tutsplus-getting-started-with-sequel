DB = Sequel.sqlite(":memory:", loggers: [Logger.new($stdout)])

DB.create_table :products do
  primary_key :id
  String :name
  String :category
end

[
  %w(Apple Fruit),
  %w(Veal Meat),
  %w(Broccoli Vegetable),
  %w(Tomato Fruit),
  %w(Hammer Tool),
  %w(Screwdriver Tool),
  %w(Onion Vegetable)
].each do |item|
  title = item[0]
  category = item[1]
  DB[:products].insert name: title, category: category
end
