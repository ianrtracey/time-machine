require './app'
require './conversation.rb'
require './message.rb'
require './cleaner.rb'
run Sinatra::Application


map "/images" do
	run Rack::Directory.new("./public/images")
end
map "/stylesheets" do
	run Rack::Directory.new("./public/stylesheets")
end