module Cryodex

  require './base'

  class Application < Base

    VERSION = '0.3.6'

    Bundler.require :default, settings.environment

    # Configure with globals defined in config.ru
    configure do
      set root:         $root
      set store:        $store
      set environment:  $env
    end

    configure { require_all 'config' }
    helpers   { require_all 'helpers' }

    require_directory 'models'
    require_directory 'observers'
    require_directory 'generators'

    require_all 'routes'

    Rabl.register!
    
    Mongoid.observers = MessageObserver,
    MemberObserver, UserObserver
    Mongoid.instantiate_observers
    
  end

end
