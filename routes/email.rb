get '/email/:template' do |template|

  locals = {
    inviter_name: 'Louis-Antoine Mullie',
    inviter_avatar: Gravatar.new('louis.mullie@gmail.com').image_url(size: 48, ssl: true)
  }

  template  = File.join($root, 'emails', "#{template.to_s}.haml")
  layout    = File.join($root, 'emails', "layout.haml")

  content_type :html
  Haml::Engine.new(File.read(layout)).render(Object.new, locals) do
    Haml::Engine.new(File.read(template)).render(Object.new, locals)
  end

end