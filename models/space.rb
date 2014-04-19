class Space

  include Mongoid::Document
  include Mongoid::Timestamps

  embeds_many :events
  embeds_one :space_avatar

  has_and_belongs_to_many :users

  has_many :members
  has_many :uploads
  has_many :messages

  field :name, type: String
  field :title, type: String

  field :admin_id, type: String
  
  def admin
    begin
      User.find(admin_id)
    rescue
      nil
    end
  end

  def notification_count_for_user(user)
    
    member = members.find_by(user_id: user.id.to_s)
    
    query = { created_at: { "$gt" => member.last_seen } }
    
    messages.where(query).size
    
  end
  
  def readable_name
    
    return name if name
    return file_name
    
  end
  
  def file_name
    
    uploads.first.name if uploads.size > 0
    
  end
  
end