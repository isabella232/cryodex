class MessageObserver < Mongoid::Observer
  
  def after_create(message)
    
    json = Rabl::Renderer.json(message, 'message')
    
    model = { model: 'Message', data: json }.to_json
    
    poster_id = message.user.id
    
    message.space.members.each do |member|
      
      user = member.user
      
      next if !user
      
      ESHQ.send(channel: user.id.to_s, data: model)

      next if (user.id == poster_id)
      
      next if member.last_emailed && 
        member.last_emailed > (Time.now - 60 * 10)
      
      send_activity_email(user)
      
      member.update_attribute :last_emailed, Time.now
      
    end
    
  end
  
  def send_activity_email(user)
    
    subject = "New activity in one of your FileQuote"
    
    Mailer.send_email(user,
      template: :space_activity,
      subject: subject
    )
    
  end

end