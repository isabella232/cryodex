object @upload
attributes :id, :type, :name, :size, :url

node(:name_without_extension) do |upload|
  upload.name.split('.')[0...-1].join('.')
end

node(:extension) do |upload|
  upload.name.split('.').last
end