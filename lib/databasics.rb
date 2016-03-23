require "active_record"
require "yaml"
require "pry"

require "databasics/version"
require "databasics/user"
require "databasics/address"
require "databasics/order"
require "databasics/item"

db_config = YAML.load(File.open("config/database.yml"))
ActiveRecord::Base.establish_connection(db_config)
ActiveRecord::Base.logger = Logger.new(STDOUT)

module Databasics
  class App
    def add_user
      puts "What's your first name?"
      first = gets.chomp
      puts "What's your last name?"
      last = gets.chomp
      puts "What's your stupid email/"
      email = gets.chomp
      user = User.create(first_name: first, last_name: last, email: email)
#      user = User.find_by_or_create_by(first_name: first, last_name: last)
#      user = User.new(first_name: first, last_name: last, email: email)
#      user.save
      puts "Your shiny new User ID is #{user.id}"
    end

    def show_addresses
      puts "What is your first name?"
      first = gets.chomp
      puts "What's your last name?"
      last = gets.chomp
      user = User.find_by(first_name: first, last_name: last)
      addresses = Address.where(user_id: user.id)
      addresses.each do |address|
        puts "Address: #{address.street}, #{address.state}, #{address.city} #{address.zip}"
      end
    end

    def show_orders
      puts "What is your ID?"
      user_id = gets.chomp
      orders = Order.where(user_id: user_id)
      orders.each do |order|
        "SELECT items.title, orders.quantity FROM orders INNER JOIN items
         ON orders.item_id=items.id WHERE orders.user_id=39;"
        item = Item.find(order.item_id)
        puts "You ordered #{order.quantity} #{item.title.pluralize}"
      end
    end

    def better_show_orders
      puts "What is your ID?"
      user_id = gets.chomp
      ## The code below works because we defined an association for Order.
      orders = Order.includes(:item).where(user_id: user_id)
      orders.each do |order|
        puts "You ordered #{order.quantity} #{order.item.title.pluralize}"
      end
    end
  end
end

app = Databasics::App.new

binding.pry
