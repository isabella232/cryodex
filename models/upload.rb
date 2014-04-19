class Upload

  include Mongoid::Document
  include Mongoid::Timestamps
  
  belongs_to :space
  
  field :url, type: String
  field :type, type: String
  field :size, type: Integer
  
  field :source, type: String
  field :store, type: String

end