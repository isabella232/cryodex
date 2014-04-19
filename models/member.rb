class Member

  include Mongoid::Document
  include Mongoid::Timestamps
  
  PendingState = 1
  AcceptedState = 2
  StaleState = 3
  
  belongs_to :space
  
  field :token, type: String,
    default: -> { SecureRandom.uuid }
  
  field :name, type: String
  field :email, type: String
  field :state, type: Integer
  
  field :user_id, type: String
  field :inviter_id, type: String
  
  field :last_emailed, type: Time
  field :last_seen, type: Time
  
  field :unsubscribed, type: Boolean
  
  def user
    begin
      @user ||= User.find(user_id)
    rescue
      nil
    end
  end
  
  def inviter
    begin
      @inviter ||= User.find(inviter_id)
    rescue
      nil
    end
  end

end