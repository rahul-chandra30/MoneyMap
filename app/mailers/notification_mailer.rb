
class NotificationMailer < ApplicationMailer
  default from: "moneymap66@gmail.com"  # Replace with your Gmail or custom email

  def chat_notification(user, title, message)
    @user = user
    @title = title
    @message = message
    mail(to: @user.email, subject: "#{@title} - MoneyMap")
  end

  def expense_notification(user, title, message)
    @user = user
    @title = title
    @message = message
    mail(to: @user.email, subject: "#{@title} - MoneyMap")
  end
end