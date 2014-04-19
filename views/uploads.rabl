collection @uploads
attributes :id, :type, :name, :size, :notification_count, :url

node(:name_without_extension) do |upload|
  upload.name.split('.')[0...-1].join('.')
end

node(:extension) do |upload|
  upload.name.split('.').last
end