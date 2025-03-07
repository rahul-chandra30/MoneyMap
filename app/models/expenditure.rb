class Expenditure < ApplicationRecord
  belongs_to :user
  validates :year, :month, :income, presence: true
  validates :income, numericality: { greater_than_or_equal_to: 0 }

  after_commit :broadcast_dashboard_update

  private

  def broadcast_dashboard_update
    return unless user
    data = DashboardController.new.send(:fetch_data_for_broadcast, user, year, Date::MONTHNAMES[month])
    ::DashboardChannel.broadcast_to(user, data)
  rescue => e
    Rails.logger.error "Failed to broadcast dashboard update: #{e.message}"
  end
end
