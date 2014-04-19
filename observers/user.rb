class UserObserver < Mongoid::Observer
  
  def after_create(user)
  
    subject = "Jonathan from FileQuote - Welcome to FileQuote!"
    
    Mailer.send_email(user,
      template: :user_register,
      subject: subject
    )
    
  end
  
end