# db/seeds.rb
require 'bcrypt'

# Clear all dependent tables in reverse dependency order
Message.delete_all        # Depends on chat_rooms
ChatRoom.delete_all       # Depends on users, experts
Booking.delete_all        # Depends on users, experts
Expenditure.delete_all    # Depends on users
Expense.delete_all        # Depends on users
Notification.delete_all   # Depends on users


# Now clear users and experts
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
    charges_per_session: rand(1..15) * 100,  # ₹100-₹1500
    designation: designations[rand(0..3)],
    age: rand(25..55),
    gender: ["Male", "Female"].sample,
    about: "Experienced #{designations[rand(0..3)]} helping clients manage finances effectively.",
    created_at: Time.now - rand(30..60).days,
    updated_at: Time.strptime("2025-0#{rand(1..2)}-#{rand(1..27)}", "%Y-%m-%d")
  )
end

# Seed Expenditures (sample income for users)
users.each_with_index do |user, i|
  Expenditure.create!(
    user_id: user.id,
    year: 2025,
    month: (i % 2) + 1,  # Jan or Feb
    income: rand(10000..50000),  
    created_at: Time.now,
    updated_at: Time.now
  )
end

# Seed Expenses (sample expenses for users)
users.each_with_index do |user, i|
  Expense.create!(
    user_id: user.id,
    year: 2025,
    month: (i % 2) + 1,  # Jan or Feb
    category: ["Rent", "Food", "Utilities", "Entertainment"].sample,
    amount_spent: rand(1000..4000),  # ₹100-₹2000
    created_at: Time.now,
    updated_at: Time.now
  )
end



puts "Seeded 10 users, 10 experts, 10 expenditures, 10 expenses"