
user = User.find_by(email: "rahul@example.com") || User.create!(
  name: "Rahul",
  email: "rahul@example.com",
  password: "password123", 
  phone: "1234567890"
)
puts "Using or created user: #{user.name} (ID: #{user.id})"


months = (1..12).to_a  
categories = ["Food", "Rent", "Transport", "Entertainment", "Shopping", "Bills"]


months.each do |month|

  income_amount = rand(8000..15000)
  Expenditure.create!(
    user_id: user.id,  
    year: 2025,        
    month: month,     
    income: income_amount 
  )
  puts "Added ₹#{income_amount} income for #{month}/2025"


  num_expenses = rand(1..3)
  num_expenses.times do

    category = categories.sample  
    amount = rand(1000..14699)       

    Expense.create!(
      user_id: user.id,
      year: 2025,
      month: month.to_s,  
      category: category,
      amount_spent: amount
    )
    puts "Added ₹#{amount} #{category} expense for #{month}/2025"
  end
end

puts "All done! Added income and expenses for all months of 2025."