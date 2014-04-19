module SymeShowcase

  require 'securerandom'
  require './base'

  class Application < Base
    
    require 'base64'

    Bundler.require :default,
      settings.environment

    # Initialize segment.io analytics
    Analytics.init(secret: '193d1167c7e3e40725c3efafa45e1b03')

    configure { require_all 'config'  }
    helpers   { require_all 'helpers' }

    Dir['./models/*.rb'].each { |file| require file }
    Dir['./helpers/*.rb'].each { |file| require file }
    Dir['./observers/*.rb'].each { |file| require file }

    require_all 'routes'

    Mongoid.observers = SubscriberObserver

    Mongoid.instantiate_observers

  end

end