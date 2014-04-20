require 'securerandom'
require 'digest'

not_found do
  haml :notfound
end

get '/' do
  @user_id = Digest::SHA2.hexdigest(request.ip.to_s)
  haml :index
end

get '/blog' do
  
  file = File.join('.', 'posts', 'posts.yml')
  
  @posts = YAML.load(File.read(file))
  
  haml :blog
  
end

get '/blog/:path' do |path|
  
  slug = path.split('.').first
  
  file = File.join('.', 'posts', 'posts.yml')
  @posts = YAML.load(File.read(file))

  post = @posts.values.select { |p| p['slug'] == slug }
  @post = post.first
  
  not_found if post.empty?
  date = @posts.key(@post)
  @key = date.dup
  
  path = "./posts/#{date}.md"
  not_found unless File.readable?(path)
  
  text = File.read(path)
  
  formatter = Slodown::Formatter.new(text)
  @content = formatter.complete.to_s
  
  time = Date.parse(date).to_time
  @date = time.strftime("%A %B #{time.day.ordinalize}")
  
  haml :blogpost
  
end

get '/unsubscribe/:email/:token' do |email, token|
  
  begin
    
    warn email.inspect
    warn Base64.strict_decode64(email)
      
    email = Base64.strict_decode64(email)
    
    user = begin
      User.find_by(email: email)
    rescue Mongoid::Errors::DocumentNotFound
      redirect '/'
    end
  
    recipient = CGI.escape(Base64.strict_encode64(email))
    
    hash = Digest::SHA2.hexdigest(recipient + settings.email_salt)
  
    warn hash.inspect
    
    raise if token != hash
  
    warn user.inspect
    
    user.unsubscribed = true
    user.save!

  rescue
    
    redirect '/'
    
  end
  
  haml :unsubscribe, layout: false

end

get '/*' do |path|
  
  not_found unless ['blog', 'contact', 'notfound', 'features', 'signup'].include?(path)
  
  @user_id = Digest::SHA2.hexdigest(request.ip.to_s)
  
  haml path.to_sym
  
end