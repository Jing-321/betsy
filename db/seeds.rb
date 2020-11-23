# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)

require 'csv'


categories = [
    {
        name: "Family"
    },
    {
        name: "Romantic"
    },
    {
        name: "Educational"
    },
    {
        name: "Cultural"
    },
    {
        name: "Fun"
    },
]

count = 0
categories.each do |category|
  if Category.create(category)
    count += 1
  end
end

puts "Created #{count} categories"






USER_FILE = Rails.root.join('db', 'users-seeds.csv')
puts "Loading raw word data from #{USER_FILE}"

user_failures = []
CSV.foreach(USER_FILE, headers: true) do |row|
  user = User.new
  user.username = row['username']
  user.email = row['email']
  user.uid = row['uid']
  user.provider = row['provider']
  user.photo_url = row['photo_url']
  successful = user.save
  if !successful
    product_failures << user
    puts "Failed to save user: #{user.inspect}"
  else
    puts "Created user: #{user.inspect}"
  end
end

puts "Added #{User.count} user records"
puts "#{user_failures.length} users failed to save"


PRODUCT_FILE = Rails.root.join('db', 'products-seeds.csv')
puts "Loading raw word data from #{PRODUCT_FILE}"

product_failures = []
CSV.foreach(PRODUCT_FILE, headers: true) do |row|
  product = Product.new
  product.name = row['name']
  product.price = row['price']
  product.description = row['description']
  product.stock = row['stock']
  product.photo_url = row['photo_url']
  product.categories << Category.all.sample
  product.user = User.all.sample
  product.active = true
  successful = product.save
  if !successful
    product_failures << product
    puts "Failed to save product: #{product.inspect}"
  else
    puts "Created product: #{product.inspect}"
  end
end

puts "Added #{Product.count} product records"
puts "#{product_failures.length} products failed to save"

