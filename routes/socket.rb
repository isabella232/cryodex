post '/eshq/socket' do
  
  channel = params[:channel]
  
  socket = ESHQ.open(channel: channel)
  
  { socket: socket }.to_json
  
end