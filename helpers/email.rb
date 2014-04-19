class Mailer
  
  # Email sending helper. All email helpers call it.
  def self.send_email_to(email, subject, body)

    Pony.mail({
      to: email,
      from: "Syme <team@getsyme.com>",
      subject: subject,
      headers: { 'Content-Type' => "text/html" },
      body: body,
      via: :smtp,
      via_options: {
        address: 'smtp.mandrillapp.com',
        port: '587',
        user_name: 'louis.mullie@gmail.com',
        password: 'tjCX49k-tDIYzmqnW0ZjYw',
        authentication: :plain,
        domain: "localhost.localdomain"
      }
    })

  end

  # Manual HAML rendering in order to put mail templates
  # outside of /views directory.
  def self.email_template(template, locals = {})

    root = File.join(File.dirname(__FILE__), '..')
    
    template  = File.join(root, 'mails', "#{template.to_s}.haml")
    layout    = File.join(root, 'mails', "layout.haml")

    Haml::Engine.new(File.read(layout)).render do
      Haml::Engine.new(File.read(template)).render(Object.new, locals)
    end

  end

  def self.send_welcome(email)

    subject = "Thanks for your interest in Syme"

    message = self.email_template :send_welcome

    self.send_email_to(email, subject, message)

  end

end