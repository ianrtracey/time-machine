##ß
class Message
  include Mongoid::Document

  field :content, type: String
  field :sender, type: String
  embedded_in :conversation
end