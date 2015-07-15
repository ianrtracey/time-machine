class Conversation
 include Mongoid::Document
 field :date, type: String
 embeds_many :messages
end