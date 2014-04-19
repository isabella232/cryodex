post '/signup' do

  email = params[:email].strip.downcase
  ip    = @env['REMOTE_ADDR']

  requester = Subscriber.new(email: email, ip: ip)

  begin
    requester.save!
  rescue Mongoid::Errors::Validations
    error 400, requester.errors.messages
  rescue Exception => e
    error 500, { server: ['save_error'] }, e
  end

  status 200
  
end