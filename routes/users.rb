post '/users' do
  
  params = get_params(request)
  
  @user = User.create(params)
  
  rabl :user, format: 'json'
  
end

put '/users/:user_id' do |user_id|
  
  if @user.id != user_id
    error 403, 'unauthorized'
  end
  
  params = get_params(request)
  
  params.delete(:contacts)
  
  @user = User.find(user_id)
  
  @user.update_attributes(params)
  
  @user.save!
  
  rabl :user, format: 'json'
  
end

get '/users/:user_id' do |user_id|
  
  params = get_params(request)
  
  @user = User.find(user_id)
  
  rabl :user, format: 'json'
  
end

delete '/users/:user_id' do |user_id|
  
  params = get_params(request)
  
  @user = User.find(user_id)
  
  @user.destroy
  
  empty_response
  
end


get '/users/:user_id/spaces' do |user_id|
  
  params = get_params(request)
  
  @spaces = @user.spaces.desc(:updated_at)
  
  rabl :spaces, format: 'json'
  
end