class SubscriberObserver < Mongoid::Observer

  def after_create(requester)

    Analytics.identify(
      user_id: requester.id.to_s,
      traits: { email: requester.email }
    )

    Mailer.send_welcome(requester.email)

    Analytics.track(
      user_id: requester.id.to_s,
      event: 'Sent confirmation e-mail'
    )

  end

end
