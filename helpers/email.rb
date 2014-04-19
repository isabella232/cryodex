class ::Mailer

  SALT = 'gPVS8BKeNG'

  def self.send_email_to(email, subject, body)

    begin

      Pony.mail({

        to: email,
        from: "FileQuote <team@filequote.io>",
        subject: subject,
        headers: { 'Content-Type' => "text/html" },
        body: body,
        via: :smtp,

        via_options: {
          address: 'smtp.mandrillapp.com',
          port: '587',
          user_name: 'syme.team@gmail.com',
          password: 'Zax_fIF8RHj5gcYFbEPyjw',
          authentication: :plain,
          domain: "localhost.localdomain"
        }

      })

    rescue

      warn "Failed to send e-mail to #{email}"

    end

  end

  def self.send_email(email_or_user, options)

    subject, template =
    options[:subject], options[:template]

    locals = options[:locals] || {}

    if email_or_user.is_a?(String)

      recipient = email_or_user

    else

      user = email_or_user
      recipient = user.email

      locals.merge!({
        user_id: user.id.to_s,
        name: user.name
      })

      return if user.unsubscribed

    end

    token = self.unsubscribe_token(recipient)
    locals.merge!({ token: token })

    template  = File.join($root, 'emails', "#{template.to_s}.haml")
    layout    = File.join($root, 'emails', "layout.haml")

    message = Haml::Engine.new(File.read(layout)).render(Object.new, locals) do
      Haml::Engine.new(File.read(template)).render(Object.new, locals)
    end

    self.send_email_to(recipient, subject, message)

  end

  def self.unsubscribe_token(email)

    Digest::SHA2.hexdigest(email +  SALT)

  end

end