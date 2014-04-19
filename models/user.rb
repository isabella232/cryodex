class User
  
  include Mongoid::Document
  
  field :email, type: String
  field :unsubscribed, type: Boolean, default: false

end