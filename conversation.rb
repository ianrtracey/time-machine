class Conversation
 include Mongoid::Document
 field :date, type: String
 field :is_sent?, type: Boolean, default: false
 embeds_many :messages
end