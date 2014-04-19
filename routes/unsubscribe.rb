get '/unsubscribe/:user_id/:token' do |user_id, token|
  
  user = User.find(user_id)
  
  Analytics.track(user.id.to_s, 'email_unsubscribe')
  
  if token == Mailer.unsubscribe_token(user.email)
    
    user.update_attribute :unsubscribed, true
    
    content_type 'text/html'

    "You've been unsubscribed"
    
  else
  
    content_type 'text/html'

    "Invalid unsubscribe link"
    
  end
  
  
end