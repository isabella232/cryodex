get '/auth/:provider/callback' do
  
  session[:auth] = request.env['omniauth.auth'].to_hash
  warn session[:auth].inspect
  
  redirect '/'
  
end