# db/seeds.rb
require 'bcrypt'

# Clear all dependent tables in reverse dependency order
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

# Seed Expenditures for Rahul Chandra (user_id: 1)
rahul = users.find { |u| u.name == "Rahul Chandra" }
monthly_incomes = [
  50000,  # Jan
  52000,  # Feb
  48000,  # Mar
  55000,  # Apr
  51000,  # May
  53000,  # Jun
  60000,  # Jul (bonus?)
  54000,  # Aug
  52000,  # Sep
  51000,  # Oct
  53000,  # Nov
  58000   # Dec (holiday bump)
]

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

# Seed Expenditures for other users (sample data)
users.reject { |u| u == rahul }.each_with_index do |user, i|
  Expenditure.create!(
    user_id: user.id,
    year: 2025,
    month: (i % 2) + 1,  # Jan or Feb
    income: rand(10000..50000),
    created_at: Time.now,
    updated_at: Time.now
  )
end

# Seed Expenses for Rahul Chandra (multiple per month)
expense_categories = ["Rent", "Food", "Utilities", "Entertainment"]
(1..12).each do |month|
  expense_categories.each do |category|
    Expense.create!(
      user_id: rahul.id,
      year: 2025,
      month: Date::MONTHNAMES[month],  # String "January", etc.
      category: category,
      amount_spent: case category
                    when "Rent" then 15000  # Fixed
                    when "Food" then rand(3000..5000)
                    when "Utilities" then rand(1000..2000)
                    when "Entertainment" then rand(500..1500)
                    end,
      created_at: Time.strptime("2025-#{month}-01", "%Y-%m-%d"),
      updated_at: Time.strptime("2025-#{month}-01", "%Y-%m-%d")
    )
  end
end

# Seed Expenses for other users (sample data)
users.reject { |u| u == rahul }.each_with_index do |user, i|
  Expense.create!(
    user_id: user.id,
    year: 2025,
    month: Date::MONTHNAMES[(i % 2) + 1],  # Jan or Feb
    category: expense_categories.sample,
    amount_spent: rand(1000..4000),
    created_at: Time.now,
    updated_at: Time.now
  )
end

puts "Seeded 10 users, 10 experts, #{Expenditure.count} expenditures, #{Expense.count} expenses"