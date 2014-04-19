class Event

  include Mongoid::Document
  include Mongoid::Timestamps
  
  embedded_in :space
  
  field :action, type: String
  field :actor_ids, type: Array, default: []
  
  field :group_id, type: String
  
  field :target_type, type: String
  field :target_id, type: String

end