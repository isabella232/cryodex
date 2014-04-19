# Useful Ruby libraries.
require 'base64'
require 'securerandom'
require 'digest'
require 'cgi'
require 'ostruct'

# Logging preferences
enable :logging

# Path configuration
set :upload_path, File.join($root, '../../uploads')
set :layout_path, File.join($root, 'app', 'js', 'templates')
set :layout_file, File.join(settings.layout_path, 'layout.hamlbars')

# Templating configuration
set :haml, layout: false
set :reload_templates, true

# Security options
set :show_exceptions, false
set :raise_errors, false

set :protection, except: [:http_origin]