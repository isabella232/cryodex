object @message
attributes :id, :content

node(:poster_id) do |m|
  m.user.id.to_s
end

node(:poster) do |m|
  m.user.name.to_s
end

node(:poster_avatar_url) do |message|
  Gravatar.new(message.user.email).image_url(size: 48, ssl: true)
end

node(:spaceId) do |m|
  m.space.id.to_s
end

node(:created_at) do |message|
  message.created_at.strftime("%b %-d, %H:%M")
end