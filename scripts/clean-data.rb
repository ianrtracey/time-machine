def get_sender(line)
  line = line.to_s

	if line.include? "Savannah Kas"
		puts "Savy"
    return "sav"
	else
		puts "iany"
    return "ian"
	end
end

File.open("data2.txt", "r").each_line do |line|
  l = line.encode('UTF-8', 'binary', invalid: :replace, undef: :replace, replace: '')
  sender = get_sender(l)
    out = sender + l.split(":").last
      if out.include? "=" 
  		out =  sender + "<emoji>"
  	  end
  	 puts out
end
$stdout = File.new('console.out', 'w')



