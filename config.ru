require 'bundler/setup'
require 'sinatra/base'
require 'securerandom'

$env = ENV['RACK_ENV']
$root = File.dirname(__FILE__)

# Setup server-side sessions.
require 'dalli'
require 'rack/session/dalli'

use Rack::Session::Dalli,
  key: 'session',
  cache: Dalli::Client.new,
  expire_after: 60 * 60 * 24 * 3

# Require the main application class.
require './app'

# Main application access point.
map '/' do
  run Cryodex::Application
end

# Handlebars configuration
HandlebarsAssets::Config.compiler = 'handlebars.min.js'
HandlebarsAssets::Config.compiler_path =
File.join($root, 'app', 'js', 'vendor')

# For development, serve assets.
map '/assets' do

  environment = Sprockets::Environment.new

  if $env != :development

    #environment.js_compressor = Closure::Compiler.new
    #environment.css_compressor = :sass

    HandlebarsAssets::Config.compiler = 'handlebars.min.js'
    HandlebarsAssets::Config.compiler_path =
    File.join($root, 'app', 'js', 'vendor')

  end

  environment.append_path 'app/js'
  environment.append_path 'app/css'
  environment.append_path 'app/fonts'

  environment.append_path HandlebarsAssets.path

  run environment

end