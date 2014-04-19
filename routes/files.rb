options '/s3/file' do
  
  FineUploaderS3.set_preflight_headers(response)
  
  status 200
  
end

delete '/s3/file/:uuid' do |uuid|
  
  FineUploaderS3.set_cors_headers(response)
  
  s3 = AWS::S3.new
  
  uploader = FineUploaderS3.new(s3, 'fine-uploader-app')
  
  uploader.delete(params[:key])
  
  status 200
  
end

post '/s3/file' do
  
  FineUploaderS3.set_cors_headers(response)
  
  s3 = AWS::S3.new
  
  uploader = FineUploaderS3.new(s3, 'fine-uploader-app')
  
  if params[:success]
    uploader.verify_exists(params[:key])
    .merge( name: params[:name] ).to_json
  else
    request_body = request.body.read.to_s
    uploader.sign_request(request_body).to_json
  end
  
end

post '/s3/success' do
  
  status 200

end