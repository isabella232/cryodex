post '/spaces/:space_id/members' do |space_id|
  
  params = get_params(request)
  
  @member, space = nil, nil
  
  if space_id == 'current'
     
    space_id = session[:create_space_id]
    
    space = Space.find(space_id)
    
    email = @user.email.to_s
    
    @member = begin
      space.members.find_by(email: email)
    rescue; nil; end
    
    if !@member
      
      @user.spaces << space
      space.users << @user
      
      space.admin_id = @user.id.to_s
      space.save!
      
      params.merge!({ user_id: @user.id.to_s })
      @member = space.members.create(params)
      
      @member.name = @user.name

      @user.save!
      @member.save!
      
      space.save!
      
    elsif !@member.user_id
      
      @member.user_id = @user.id.to_s
      @member.name = @user.name
      
      @user.spaces << space
      space.users << @user
      
      space.admin_id = @user.id.to_s
      
      @user.save!
      @member.save!
      
      space.save!
      
    else
      
      @member.user_id = @user.id.to_s
      @member.save!
      
    end
    
    session[:create_space_id] = nil
    
  else
  
    space = Space.find(space_id)
    
    user = begin
      User.find_by(email: params[:email])
    rescue; nil; end
    
    params.merge!({
      user_id: user ? user.id.to_s : nil,
      inviter_id: @user.id.to_s
    })
    
    Analytics.track(@user.id.to_s, 'add_to_space')
    Analytics.track(user.id.to_s, 'added_to_space') if user
    
    @member = space.members.create(params)
    
    @member.save!
    
    if user
      
      user.spaces << space
      space.users << user
      user.save!
    
    end
    
    space.save!

  end
  
  rabl :member, format: 'json'
  
end

get '/spaces/:space_id/members/:member_id' do |space_id, member_id|
  
  params = get_params(request)
  
  space = @user.spaces.find(space_id)
  
  @member = space.members.find(member_id)

  rabl :member, format: 'json'
  
end

get '/spaces/:space_id/members' do |space_id|
  
  params = get_params(request)
  
  # verify current user has membership!
  
  space = Space.find(space_id)
  
  @members = space.members
  
  rabl :members, format: 'json'
  
end

delete '/spaces/:space_id/members/:member_id' do |space_id, member_id|
  
  params = get_params(request)
  
  space = @user.spaces.find(space_id)
  
  Analytics.track(@user.id.to_s, 'remove_from_space')
  
  @member = space.members.find(member_id)
  
  @member.destroy

  empty_response
  
end