class Message

  include Mongoid::Document
  include Mongoid::Timestamps
  
  belongs_to :space

  field :user_id, type: String
  field :mentions, type: Array, default: []
  field :content, type: String, default: ''
  
  def user
    space.users.find(user_id)
  end
  
end