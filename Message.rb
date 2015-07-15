class Message
  include Mongoid::Document

  field :content, type: String
  embedded_in :conversation
end