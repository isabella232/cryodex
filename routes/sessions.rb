post '/users/current/sessions/current' do
  
  user = begin
    
    User.find_by(token: params[:token])
    
  rescue
    
    profile = LoginRadius::UserProfile.new({
      token: params[:token],
      secret: "8c591f13-9b31-4872-8b54-3fb759204345",
      async: false
    })
    
    profile.login
    
    email = profile.email.first['value']
    
    begin
      
      user = User.find_by(email: email)
      
      Analytics.track(user.id.to_s, 'login')
      
      user
      
    rescue Mongoid::Errors::DocumentNotFound
      
      contacts = profile.contacts ?
        JSON.parse(profile.contacts.to_json).map do |contact|
        {
          name: contact['name'],
          email: contact['email_id'],
          avatar_url: Gravatar.new(contact['email_id'])
                      .image_url(size: 15, ssl: true)
        }
      end : []
      
      user = User.create({
        token: params[:token],
        name: profile.full_name,
        email: profile.email.first['value'],
        contacts: contacts.to_json
      })
      
      Analytics.people.set(user.id.to_s, {
        name: profile.full_name,
        email: profile.email.first['value']
      })
      
      user
      
    end
    
  end
  
  user.save!
  
  session[:user_id] = user.id.to_s
  
  if session[:create_space_id]
    redirect '/create/' + session[:create_space_id] 
  elsif session[:redirect_space_id]
    redirect = session[:redirect_space_id].dup
    session[:redirect_space_id] = nil
    redirect '/show/' + redirect
  else
    redirect '/'
  end
  
end

get '/users/current/sessions/current' do
  
  if @user
    
    @session = OpenStruct.new
    @session.user_id = @user.id.to_s
    @session.id = session.id
  
    rabl :session, format: 'json'
    
  else
    halt 403, { error: 'unauthorized' }.to_json
  end
  
end

delete '/users/current/sessions/current' do
  
  Analytics.track(@user.id.to_s, 'logout')
  
  session.clear
  
  redirect '/'
  
end