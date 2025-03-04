# db/seeds.rb
require 'bcrypt'

# Clear tables in reverse dependency order
Message.delete_all
ChatRoom.delete_all
Booking.delete_all
Expenditure.delete_all
Expense.delete_all
Notification.delete_all
User.delete_all
Expert.delete_all

# Seed Users
users = 10.times.map do |i|
  User.create!(
    name: ["Rahul Chandra", "Priya Sharma", "Amit Kumar", "Neha Gupta", "Suresh Patel", 
           "Anjali Desai", "Vikram Singh", "Pooja Mehra", "Karan Joshi", "Divya Nair"][i],
    email: "user#{i + 1}@example.com",
    password_digest: BCrypt::Password.create("password123"),
    phone: "123456789#{i}",
    created_at: Time.now - rand(30..60).days,
    updated_at: Time.strptime("2025-0#{rand(1..2)}-#{rand(1..27)}", "%Y-%m-%d")
  )
end

# Seed Experts
designations = ["Financial Advisor", "Tax Consultant", "Budget Coach", "Investment Planner"]
experts = 10.times.map do |i|
  Expert.create!(
    name: ["Amit Patel", "Neha Gupta", "Suresh Iyer", "Anjali Rao", "Vikram Malhotra", 
           "Pooja Verma", "Karan Shah", "Divya Kapoor", "Ravi Menon", "Sneha Reddy"][i],
    email: "expert#{i + 1}@example.com",
    password_digest: BCrypt::Password.create("expert123"),
    phone: "98765432#{i}0",
    experience: rand(1..15),
    charges_per_session: rand(1..15) * 100,
    designation: designations[rand(0..3)],
    age: rand(25..55),
    gender: ["Male", "Female"].sample,
    about: "Experienced #{designations[rand(0..3)]} helping clients manage finances effectively.",
    created_at: Time.now - rand(30..60).days,
    updated_at: Time.strptime("2025-0#{rand(1..2)}-#{rand(1..27)}", "%Y-%m-%d")
  )
end

# Seed Expenditures for Rahul Chandra
rahul = users.find { |u| u.name == "Rahul Chandra" }
monthly_incomes = [50000, 52000, 48000, 55000, 51000, 53000, 60000, 54000, 52000, 51000, 53000, 58000]
(1..12).each do |month|
  Expenditure.create!(
    user_id: rahul.id,
    year: 2025,
    month: month,  # Integer 1-12
    income: monthly_incomes[month - 1],
    created_at: Time.strptime("2025-#{month}-01", "%Y-%m-%d"),
    updated_at: Time.strptime("2025-#{month}-01", "%Y-%m-%d")
  )
end

# Seed Expenses for Rahul Chandra
categories = ["Rent", "Food", "Utilities", "Entertainment"]
(1..12).each do |month|
  categories.each do |category|
    Expense.create!(
      user_id: rahul.id,
      year: 2025,
      month: Date::MONTHNAMES[month],  # String "January" etc.
      category: category,
      amount_spent: category == "Rent" ? 15000 : rand(500..5000),
      created_at: Time.strptime("2025-#{month}-01", "%Y-%m-%d"),
      updated_at: Time.strptime("2025-#{month}-01", "%Y-%m-%d")
    )
  end
end

# Seed sample data for other users
users.reject { |u| u == rahul }.each_with_index do |user, i|
  Expenditure.create!(
    user_id: user.id,
    year: 2025,
    month: (i % 2) + 1,
    income: rand(10000..50000),
    created_at: Time.now,
    updated_at: Time.now
  )
  Expense.create!(
    user_id: user.id,
    year: 2025,
    month: Date::MONTHNAMES[(i % 2) + 1],
    category: categories.sample,
    amount_spent: rand(1000..4000),
    created_at: Time.now,
    updated_at: Time.now
  )
end

puts "Seeded 10 users, 10 experts, #{Expenditure.count} expenditures, #{Expense.count} expenses"