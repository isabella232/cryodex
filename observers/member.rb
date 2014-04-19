class MemberObserver < Mongoid::Observer

  def after_create(member)
    
    admin = member.space.admin

    if admin && member.email == admin.email
      
      subject = "Your new FileQuote Space"

      Mailer.send_email(admin,
        template: :space_create,
        subject: subject,
        locals: {
          space_id: member.space.id.to_s
        }
      )
  
    else
      
      json = Rabl::Renderer.json(member, 'member')

      model = { model: 'Member', action: 'create', data: json }.to_json

      member.space.users.each do |user|

        ESHQ.send(channel: user.id.to_s, data: model)

      end

      file = member.space.uploads.all.first
      
      inviter = User.find(member.inviter_id)
      
      subject = "#{inviter.name} wants to share #{file.name} with you on FileQuote"

      inviter_avatar = Gravatar.new(inviter.email).image_url(size: 25, ssl: true)
      
      Mailer.send_email(member.email,
        template: :member_invite,
        subject: subject,
        locals: {
          inviter_name: inviter.name,
          inviter_avatar: inviter_avatar,
          file_name: file.name,
          space_id: member.space.id.to_s
        }
      )
      
    end

  end

  def before_destroy(member)

    json = Rabl::Renderer.json(member, 'member')

    model = { model: 'Member', action: 'delete', data: json }.to_json

    member.space.users.each do |user|

      ESHQ.send(channel: user.id.to_s, data: model)

    end

  end

end