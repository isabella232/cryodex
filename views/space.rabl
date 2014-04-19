object @space
attributes :id, :name, :file_name

node(:admin_id) do |space|
  space.admin ? space.admin.id.to_s : ''
end

node(:admin_name) do |space|
  space.admin ? space.admin.name : 'you'
end

node(:notification_count) do |space|
  @user ? space.notification_count_for_user(@user) : 0
end

node(:created_at) do |space|
  space.created_at.strftime("%B %d, %Y")
end

node(:file_name_without_extension) do |space|
  file_name = space.file_name
  space.file_name.split('.')[0...-1] if file_name
end

node(:file_extension) do |space|
 file_name = space.file_name
  space.file_name.split('.').last if file_name
end

node(:other_people_count) do |space|
  (space.members.size - 1).to_s
end