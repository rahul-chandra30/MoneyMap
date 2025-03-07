class Expense < ApplicationRecord
  belongs_to :user
  validates :year, :month, :category, :amount_spent, presence: true
  validates :amount_spent, numericality: { greater_than: 0 }

  scope :for_month_year, ->(month, year) { where(month: month, year: year) }
  scope :total_spent, -> { sum(:amount_spent) }

  before_save :format_amount
  after_commit :broadcast_dashboard_update

  private

  def format_amount
    self.amount_spent = amount_spent.to_i
  end

  def broadcast_dashboard_update
    return unless user
    data = DashboardController.new.send(:fetch_data_for_broadcast, user, year, month)
    ::DashboardChannel.broadcast_to(user, data)
  rescue => e
    Rails.logger.error "Failed to broadcast dashboard update: #{e.message}"
  end
end
