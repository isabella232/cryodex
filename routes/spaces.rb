post '/spaces' do

  params = get_params(request)

  @space = if @user
    
    space = @user.spaces.create(params)
    @user.save!
    
    space.admin_id = @user.id.to_s
    
    @user.spaces << space
    space.users << @user
    
    @user.save!
    space.save!
    
    space.members.create({
      name: @user.name,
      email: @user.email,
      user_id: @user.id.to_s
    })
    
    space.save!

    Analytics.track(@user.id.to_s, 'create_space')
     
    space
  
  else
    
    Space.create(params)
    
  end
  
  session[:create_space_id] = @space.id.to_s
  
  @space.save!
  

  rabl :space, format: 'json'

end

put '/spaces/:space_id' do |space_id|

  params = get_params(request)

  @space = @user.spaces.find(space_id)

  @space.update_attributes(params)

  rabl :space, format: 'json'

end

get '/spaces/:space_id' do |space_id|

  params = get_params(request)

  @space = Space.find(space_id)
  
  # Try to find member by ID first
  member = begin
    
    @space.members.find_by(user_id: @user.id.to_s)
  
  # Otherwise, try to find member by e-mail
  rescue
    
    # Try to find member by e-mail
    begin
      
      member = @space.members.find_by(email: @user.email)
    
      # Check if user integrated in group
      begin
        user = @space.users.find(@user.id.to_s)
        
      # If not integrated, then integrate
      rescue
        
        warn "integrating"
        
        member.user_id = @user.id.to_s
        member.save!
      
        @space.users << @user
        @user.spaces << @space
      
        @user.save!
        @space.save!
      
      end
      
      # Return the member object
      member
  
    # Member not found by e-mail or ID
    rescue
      
      raise "Not authorized to view"
      
    end
  
  end
  
  Analytics.track(@user.id.to_s, 'view_space')

  member.update_attribute :last_seen, Time.now
  
  rabl :space, format: 'json'

end

delete '/spaces/:space_id' do |space_id|

  params = get_params(request)

  @space = @user.spaces.find(space_id)

  @space.destroy
  
  Analytics.track(@user.id.to_s, 'delete_space')

  rabl :space, format: 'json'

end

get '/spaces/:space_id/users' do |space_id|

  @space = @user.spaces.find(space_id)

  @users = @space.users

  rabl :users, format: 'json'

end

get '/spaces/:space_id/uploads' do |space_id|

  @space = Space.find(space_id)

  # verify user is authorized to view space
  
  @uploads = @space.uploads

  rabl :uploads, format: 'json'

end