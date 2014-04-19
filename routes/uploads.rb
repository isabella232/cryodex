post '/spaces/:space_id/uploads' do |space_id|
  
  params = get_params(request)
    
  space = Space.find(space_id)
  
  @upload = space.uploads.create(params)
  
  space.uploads << @upload
  space.save!
  
  @upload.save!
  
  rabl :upload, format: 'json'
  
end

put '/spaces/:space_id/uploads/:upload_id' do |space_id, upload_id|

  params = get_params(request)
  
  space = @user.spaces.find(space_id)
  
  @upload = space.uploads.find(upload_id)
  
  @upload.update_attributes(params)
  
  space.save!
  @upload.save!

  rabl :upload, format: 'json'
  
end

get '/spaces/:space_id/uploads/:upload_id' do |space_id, upload_id|
  
  params = get_params(request)
  
  space = @user.spaces.find(space_id)
  
  @upload = space.uploads.find(upload_id)

  rabl :upload, format: 'json'
  
end

delete '/spaces/:space_id/uploads/:upload_id' do |space_id, upload_id|
  
  params = get_params(request)
  
  space = @user.spaces.find(space_id)
  
  @upload = space.uploads.find(upload_id)
  
  @upload.destroy!
  
  empty_response
  
end