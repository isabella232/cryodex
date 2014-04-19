def get_params(request)
  text = request.body.read.to_s
  text == "" ? {} : symbolize(JSON.parse(text))
end

def symbolize(obj)
  return obj.inject({}){|memo,(k,v)| memo[k.to_sym] = symbolize(v); memo} if obj.is_a? Hash
  return obj.inject([]){|memo,v| memo << symbolize(v); memo} if obj.is_a? Array
  return obj
end

def empty_response(code = 200)
  status code
  {}.to_json
end