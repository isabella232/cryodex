class SubscriberObserver < Mongoid::Observer

  def after_create(requester)

    # Mailer.send_welcome(requester.email)

  end

end
