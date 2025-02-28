user = User.find(1)  # Changed to user ID 4
puts "Using existing user: #{user.name} (ID: #{user.id})"

# Clear existing data for this user
puts "Clearing existing data for user #{user.id}..."
user.expenses.destroy_all
user.expenditures.destroy_all

months = (1..12).to_a
categories = ["Food", "Rent", "Transport", "Entertainment", "Shopping", "Bills"]

months.each do |month|
  # Create monthly income first
  income_amount = rand(80000..150000)
  Expenditure.create!(
    user_id: user.id,
    year: 2025,
    month: month,
    income: income_amount
  )
  puts "Added ₹#{income_amount} income for #{month}/2025"

  # Track total expenses to ensure they don't exceed income
  total_expenses = 0
  
  # Create 3-5 expenses per month
  num_expenses = rand(3..5)
  num_expenses.times do |i|
    category = categories.sample
    
    # For the last expense, ensure we don't exceed income
    if i == num_expenses - 1
      max_amount = income_amount - total_expenses
      amount = [rand(10000..40000), max_amount].min
    else
      # For other expenses, ensure we leave room for remaining expenses
      remaining_expenses = num_expenses - i
      max_possible = (income_amount - total_expenses) / remaining_expenses
      amount = rand(10000...[40000, max_possible].min)
    end

    # Only create expense if amount is positive
    if amount > 0
      Expense.create!(
        user_id: user.id,
        year: 2025,
        month: month.to_s,
        category: category,
        amount_spent: amount
      )
      total_expenses += amount
      puts "Added ₹#{amount} #{category} expense for #{month}/2025"
    end
  end

  savings = income_amount - total_expenses
  puts "Month #{month}/2025 Summary:"
  puts "Income: ₹#{income_amount}"
  puts "Total Expenses: ₹#{total_expenses}"
  puts "Savings: ₹#{savings}"
  puts "-------------------"
end

puts "All done! Added income and expenses for all months of 2025 for user #{user.id}."
