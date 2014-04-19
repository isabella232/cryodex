before do
  
  # Obfuscate the server type
  response.headers['Server'] = 'syme'
  
  session[:id] ||= SecureRandom.uuid
  @user_id = session[:id]
  last_modified settings.last_modified
  expires 60, :public, :must_revalidate
  
end