post '/spaces/:space_id/messages' do |space_id|
  
  params = get_params(request)
  
  space = @user.spaces.find(space_id)
  
  params.merge!({ user_id: @user.id.to_s })
  
  @message = space.messages.create(params)
  
  space.touch
  
  space.save!
  @message.save!

  Analytics.track(@user.id.to_s, 'post_message')
  
  member = space.members.find_by(user_id: @user.id.to_s)
  
  member.update_attribute :last_seen, Time.now
  
  rabl :message, format: 'json'
  
end

put '/spaces/:space_id/messages/:message_id' do |space_id, message_id|

  params = get_params(request)
  
  space = @user.spaces.find(space_id)
  
  @message = space.messages.find(message_id)
  
  @message.update_attributes(params)
  
  space.save!
  @message.save!

  rabl :message, format: 'json'
  
end

get '/spaces/:space_id/messages/:message_id' do |space_id, message_id|
  
  params = get_params(request)
  
  space = @user.spaces.find(space_id)
  
  @message = space.messages.find(message_id)

  rabl :message, format: 'json'
  
end

get '/spaces/:space_id/messages' do |space_id|
  
  params = get_params(request)
  
  space = Space.find(space_id)
  
  # verify user authorized to view
  
  @messages = space.messages

  rabl :messages, format: 'json'
  
end

delete '/spaces/:space_id/messages/:message_id' do |space_id, message_id|
  
  params = get_params(request)
  
  space = @user.spaces.find(space_id)
  
  @message = space.messages.find(message_id)
  
  @message.destroy
  
  Analytics.track(@user.id.to_s, 'delete_message')

  empty_response
  
end