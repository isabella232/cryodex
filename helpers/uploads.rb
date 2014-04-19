# Additional mime types
Rack::Mime::MIME_TYPES.merge!({
  ".eot" => "application/vnd.ms-fontobject",
  ".ttf" => "application/x-font-ttf",
  ".otf" => "font/otf",
  ".svg" => "image/svg+xml",
  ".woff" => "application/x-font-woff"
})

# http://docs.aws.amazon.com/AWSRubySDK/latest/AWS/S3/S3Object.html
# http://blog.fineuploader.com/2013/08/16/fine-uploader-s3-upload-directly-to-amazon-s3-from-your-browser/#chunking
# http://mikeferrier.com/2011/10/27/granting-access-to-a-single-s3-bucket-using-amazon-iam/
# https://console.aws.amazon.com/iam/home?region=us-east-1#groups
# https://github.com/Widen/fine-uploader-server/blob/master/php/s3/s3demo.php
# http://fineuploader.com/demos
# http://docs.fineuploader.com/endpoint_handlers/amazon-s3.html
# https://devcenter.heroku.com/articles/s3

class FineUploaderS3

  require 'openssl'
  
  ClientPublicKey = 'AKIAIA4O4WOKMRZJMYSQ'
  ClientPrivateKey = 'lRD4e9c48dkJW21TlKLvBWSAKZnK2h3pjw7ymdbb'
  
  def initialize(s3, bucket_name, max_file_size = 5000000 * 10)
    
    @s3, @bucket_name = s3, bucket_name
    @max_file_size = max_file_size
    
  end
  
  def verify_exists(key)
    
    { url: get_temp_link(key),
      size: find_key(key).content_length
    }
    
  end
  
  def get_object_size(key)
    file = find_key(key)
    file.size
  end
  
  def get_temp_link(key)
    
    file = find_key(key)
    
    file.url_for(:read)
    
  end
  
  def find_key(key)
    
    @s3.buckets[@bucket_name].objects[key]
    
  end

  def delete(key)
    
    find_key(key).delete
    
  end
  
  def sign_request(request_body)
    
    content = JSON.parse(request_body)
    json_str = content.to_json
    
    headers_str = content['headers']
    
    if headers_str
      sign_rest_request(headers_str)
    else
      sign_policy(json_str)
    end
    
  end
  
  def sign_rest_request(headers_str)
    
    if is_valid_request?(headers_str)
      { signature: sign(headers_str) }
    else
      raise "Invalid request: #{headers_str}"
      { invalid: true }
    end
    
  end
  
  def is_valid_request?(headers_str)
    
    headers_str.index(@bucket_name)
    
  end

  def sign_policy(policy_str)
    
    policy_obj = JSON.parse(policy_str)
    
    if is_valid_policy?(policy_obj)
      
      encoded_policy = Base64.strict_encode64(policy_str)
      
      { policy: encoded_policy,
        signature: sign(encoded_policy)
      }
    
    else
      
      raise "Invalid policy: #{policy_str}"
      { invalid: true }
      
    end
    
  end
  
  def is_valid_policy?(policy)
    
    conditions = policy['conditions']
    
    bucket, parsed_max_size = nil, nil
    
    conditions.each do |condition|
      if condition.is_a?(Hash) &&
        condition['bucket']
        bucket = condition['bucket']
      elsif condition.is_a?(Array) &&
        condition[0] && condition[0] ==
        'content-length-range'
        parsed_max_size = condition[2]
      end
    end
    
    bucket == @bucket_name        &&
    parsed_max_size.to_i == @max_file_size
    
  end
  
  def sign(string_to_sign)
    
    Base64.encode64(
      OpenSSL::HMAC.digest(
        OpenSSL::Digest::Digest.new('sha1'),
        ClientPrivateKey,
        string_to_sign
      )
    ).gsub(/\n/, '')
    
  end
  
  def self.set_preflight_headers(response)
    
    self.set_cors_headers(response)
    
    response.headers["Access-Control-Allow-Methods"] = "POST"
    response.headers["Access-Control-Allow-Headers"] = "Content-Type"
    response.headers['Access-Control-Max-Age'] = '1728000'

  end

  def self.set_cors_headers(response)
    
    response.headers['Access-Control-Allow-Origin'] = '*'
    
  end
  
end