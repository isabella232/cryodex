enable :logging

# Application-wide config.
set app_title: 'Syme'

# Render views in layout by default
set :haml, layout: true

set environment: $env
set root: $root

# HTTP Date according to RFC 2616
set last_modified: File.stat($root).ctime.strftime("%a, %d %b %Y %T GMT")

# Set caching for public assets to 14 days.
set :static, true

set :static_cache_control, [
  :public, { max_age: 60 * 60 * 24 * 14 }
]

# Environment-specific config.
if $env == :development
  set :reload_templates, true
end

set :root, File.dirname(__FILE__)

Analytics.init(secret: 'k6g05c9wep')
set :email_salt, '"a$$#!%@&Fe39n#?*4n4C$ni'