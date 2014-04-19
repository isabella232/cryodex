before do

  content_type 'application/json'

  user_id = session[:user_id]

  @user = User.find(user_id) if user_id

end