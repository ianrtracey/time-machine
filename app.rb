#This is the app.rb file. It is kind of like our bread and butter file.
#In sinatra we can do almost anything from this file though we generally parition
#things like configuration, databases and html/css/js stuff in other folders to keep this clean
# edited
require 'rubygems'
require 'bundler'
require 'yaml'
require 'date'
require 'twilio-ruby'
require 'rufus/scheduler'
#This now looks at our Gemfile and requires all of those gems for us
Bundler.require(:default) 
#note it dosn't want the .rb extension. It knows it wants a .rb
require './conversation.rb'
require './message.rb'
require './sender.rb'







set :public_folder, 'public'
  configure do
    if ENV['RACK_ENV'] == "production"
     puts "configuring db for production mode"
     Mongoid.load!("./database.yml", :production)
    else
     puts "configuring db for development mode"
     Mongoid.load!("./database.yml", :development)
    end
    ACCOUNT_SID = 'AC955cb60855da35fcec4d03be5c4b2a3f'
    AUTH_TOKEN = 'fbd863919c6ed0dc51686e05845916f4' 
    @client = Twilio::REST::Client.new ACCOUNT_SID, AUTH_TOKEN
    scheduler = Rufus::Scheduler.new
    scheduler.every '4h' do
      url = next_conversation_url
      if url != 'nil'
      @client.messages.create(
      from: "6235006454",
      to: "6238662766",
      body: "Hey Ian, you have a new timemachine flashback: https://ian-and-sav-time-machine.herokuapp.com/#{url}")
      @client.messages.create(
      from: "6235006454",
      to: "6027089125",
      body: "Hey Savannah, you have a new timemachine flashback: https://ian-and-sav-time-machine.herokuapp.com/#{url}")
      puts "message sent: #{url}"
      else
        puts "no more conversations left to send"
      end
    end

  end


  get '/' do
   "Welcome to time machine."
  end
  
  get "/random_cat_fact/?:num?" do
    content_type :json
    params[:num] ||= 1
    CatFact.all.pluck(:fact).sample(params[:num].to_i).to_json
  end

  get "/conv" do
   puts Conversation.all.pluck(:messages)
  end

  get "/conversations" do 
  	@conversations = Conversation.all
  	erb :index
  end

  get "/conversation/:date" do |date|
    @conversation = Conversation.find_by(date: date.capitalize)
    date = Date.strptime(@conversation.date, '%m-%d-%y')
    @date = "#{Date::MONTHNAMES[date.month]} #{date.day}, #{date.year}"
    erb :conversation
  end

  get "/new/conversation" do 
    protected!
    erb :new_conversation
  end

  get "/send/message" do
    @client = Twilio::REST::Client.new ACCOUNT_SID, AUTH_TOKEN
    @client.messages.create(
      from: "6235006454",
      to: "6238662766",
      body: "hey!")
  end

  post "/new/conversation" do 
    date = params[:data].split("\n")[0].split("]",2)[0].split(" ",2)[0].gsub("/", "-")
    date[0] = ""
    clean = sanitize(params[:data])
    puts "Date: #{date}"
    conversation = Conversation.create(date: date)
    clean.each do |clean_line|
      sender = ""
      content = ""
      if clean_line.split(":", 2).first.include? "I"
        sender = "Ian"
      else
        sender = "Savannah"
      end
      content = clean_line.split(":", 2).last.strip
    conversation.messages << Message.new(sender: sender ,content: content)
    end
    puts "Success! Find the conversation at localhost:9292/conversation/#{conversation.date}"
  end

  def sanitize(data)
    result = []
    s = data.split("\n")
      s.each do |d|
        atom = d.split(":", 3)
        if atom[1].include? "Savannah"
          result << "S: "+atom[2].strip
        else
          result << "I: " +atom[2].strip
        end
      end
    return result
  end

  def authorized?
    @auth ||= Rack::Auth::Basic::Request.new(request.env)
    @auth.provided? && @auth.basic? && @auth.credentials & @auth.credentials == ["ianrtracey", "ianandsav"]
  end

  def protected!
    unless authorized?
      response['WWW-Authenticate'] = %(Basic realm="Restricted Area")
      throw(:halt, [401, "Oops... we need your login name & password\n"])
    end
  end

  def next_conversation_url
    c = Conversation.where(:is_sent? => false).first
    if c.nil?
      return 'nil'
    else
      c.update_attributes(is_sent?: true)
      return "conversation/#{c.date}"
    end
  end



