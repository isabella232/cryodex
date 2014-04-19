require 'bundler/setup'
require 'sinatra/base'

$root = File.dirname(__FILE__)

case $env = ENV['RACK_ENV'].downcase.to_sym
when :production

  # Enable GZIP compression.
  use Rack::Deflater

  # Enforce SSL for all connections.
  # require 'rack/ssl'
  # use Rack::SSL

when :development



end

# Setup server-side sessions.
use Rack::Session::Memcache,
  key: 'session',
  expire_after: 60 * 60 * 24 * 3,
  secure: $env == :production,
  sidbits: 256,
  path: '/',
  secret: '8gr718743g8738bf8f143'

use Rack::Protection, except: [:http_origin, :remote_token]

require './app'

map '/assets' do

  environment = Sprockets::Environment.new

  environment.append_path 'public/js'
  environment.append_path 'public/css'

  if $env == :production
    environment.js_compressor = Closure::Compiler.new
    environment.css_compressor = :sass
  end

  run environment

end

use Rack::NoIE, { redirect: 'http://whatbrowser.org/', minimum: 9 }

run SymeShowcase::Application