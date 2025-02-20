# This file should ensure the existence of records required to run the application in every environment (production,
# development, test). The code here should be idempotent so that it can be executed at any point in every environment.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Example:
#
#   ["Action", "Comedy", "Drama", "Horror"].each do |genre_name|
#     MovieGenre.find_or_create_by!(name: genre_name)
#   end
#

# Create test users
puts "Creating test users..."
user = User.create!(
  name: "Test User",
  email: "user@example.com",
  password: "password123",
  phone: "1234567890"
)

expert = Expert.create!(
  name: "Test Expert",
  email: "expert@example.com",
  password: "password123",
  phone: "0987654321",
  designation: "Financial Advisor",
  charges_per_session: 1000.00
)

puts "Creating test chat room..."
chat_room = ChatRoom.create!(
  user: user,
  expert: expert
)

puts "Creating test messages..."
Message.create!(
  chat_room: chat_room,
  sender: user,
  content: "Hello, I need financial advice"
)

Message.create!(
  chat_room: chat_room,
  sender: expert,
  content: "Hi! I'll be happy to help"
)

puts "Seed data created successfully!"
