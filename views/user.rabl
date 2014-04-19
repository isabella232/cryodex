object @user
attributes :id, :name, :email, :online, :has_spaces, :notification_count

node(:tiny_avatar_url) do |user|
  Gravatar.new(user.email).image_url(size: 25, ssl: true)
end

node(:contacts) do |user|
  JSON.parse(user.contacts)
end