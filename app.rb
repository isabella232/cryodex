module SymeShowcase

  require 'securerandom'
  require './base'

  class Application < Base
    
    require 'base64'

    Bundler.require :default,
      settings.environment

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