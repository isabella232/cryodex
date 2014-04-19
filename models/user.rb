class User

  include Mongoid::Document
  include Mongoid::Timestamps
  
  has_and_belongs_to_many :spaces
  
  has_many :messages
  
  embeds_one :user_avatar
  
  field :email, type: String
  field :name, type: String
  field :token, type: String
  field :contacts, type: String
  
  field :last_emailed, type: Time
  
  field :unsubscribed, type: Boolean
  
  def online
    updated_at > (Time.now - 60)
  end
  
  def has_spaces
    spaces.size > 0
  end

  def notification_count
    
    count = 0
    
    spaces.each do |space|
      count += space.notification_count_for_user(self)
    end
    
    count
    
  end
  
end