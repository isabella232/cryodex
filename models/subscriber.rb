class Subscriber

  include Mongoid::Document
  include Mongoid::Timestamps

  field :email, type: String
  field :ip, type: String
  field :name, type: String
  field :message, type: String
  field :title, type: String


  validates :email, presence:   { message: 'email_cannot_be_blank' },
                    format:     { with: /^([^@\s]+)@((?:[-a-z0-9]+\.)+[a-z]{2,})$/i,
                                  message: 'invalid_email_format' },
                    uniqueness: { message: 'email_must_be_unique' }

end