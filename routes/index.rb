['/', '/login', '/show/:id', '/create/:id', '/list', '/upload'].each do |path|
  
  get path do

    if path == '/show/:id' && params[:id]
      session[:redirect_space_id] = params[:id]
    end
    
    content_type 'text/html'
  
    layout = File.read(settings.layout_file)
    Haml::Engine.new(layout).render

  end

end