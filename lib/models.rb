require "bundler"
Bundler.require
require "yaml"
require "logger"

require_relative "bootstrap"

class Product < Sequel::Model
  one_to_many :orders, join_table: :order_items
  one_to_many :order_items
end

class Order < Sequel::Model
  one_to_many :products, join_table: :order_items
  one_to_many :order_items
end

class OrderItem < Sequel::Model
  many_to_one :order
  many_to_one :product
end

def all
  ap Product.all.map { |p| p.name }
end

def associations
  order = Order.new
  order.save

  products = Product.first, Product.last

  ap products

  products.each { |p| order.add_order_item product: p } # Change to nil
end

def transactions
  puts %(There are #{Order.count} orders.)
  begin
    DB.transaction do
      associations
    end
  rescue
  end
  puts %(There are #{Order.count} orders.)
end

transactions
