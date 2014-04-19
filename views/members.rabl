collection @members

attributes :id, :name, :email, :token

node(:spaceId) do |member|
  member.space.id.to_s
end