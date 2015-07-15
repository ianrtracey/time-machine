require 'mongoid'
require './conversation'
require './message'

#Check if in development,test or production mode
Mongoid.load!("./database.yml", :development)
Conversation.collection.drop
Message.collection.drop

convo = Conversation.create(date: "January-13-2015")
messages = [ "I: How are you?",
			 "S: Just woke up:] i feel alright",
			 "S: i am so incredibly sorry by the way:[ i dont remember much of what i said but the stuff i do remember makes me cringe. I suck :[",
			 "I: You don't suck. Hhaha trust me it was no problem.",
			 "S: :[ i feel so horrible about last night. Are u okay?",
			 "I: Don't feel horrible, seriously. I am good! Dodged a hangover surprisingly have my shit together today - which is a surprise. Haha",
			 "S: Thats good! I had the worst hangover of my entire life and i pretty sure i barfed like 3 times:[ definitely not my finest",
			 "I: Oh jeez. Well I hope you feel better. Don't you work today?",
			 "S: Yeah. In an hourish. Are u working or just doing ra stuff?",
			 "I: That does not sound like fun, haha. I had a few meetings this morning but I don't have to work today.", 
			 "S: Thats good! you can relax before the hell starts tomorrow haha",
			 "I: Yeah, definitely. Well best of luck today at Starbs, I would not be able to handle it.",
			 "S: thanks! Haha i hoping i can survive"]
  
  messages.each do |message|
  	m = Message.new(content: message)
    convo.messages << m
  end
  puts "succeess! #{Conversation.count} loaded"

