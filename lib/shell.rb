require 'io/console'

require 'shellwords'
class Shell
	attr_accessor :input, :output
	def initialize()
		self.input  = $stdin
    	self.output = $stdout
	end

	def start
		while true
			printf ">"		
			#printf self.input.gets.chomp	
			actions = Shellwords.split(self.input.gets.chomp)
			action = method(actions.first().sub("-", "_"))
			args = actions[1..actions.size]
			action.call(*args)
		end
	end

	def quit
		Process.exit(1)
	end

	def prompt(text)
		self.output.puts text
	end

 
	# Reads keypresses from the user including 2 and 3 escape character sequences.
	def read_char
	  STDIN.echo = false
	  STDIN.raw!
	 
	  input = STDIN.getc.chr
	  if input == "\e" then
	    input << STDIN.read_nonblock(3) rescue nil
	    input << STDIN.read_nonblock(2) rescue nil
	  end
	ensure
	  STDIN.echo = true
	  STDIN.cooked!
	 
	  return input
	end
 
	# oringal case statement from:
	# http://www.alecjacobson.com/weblog/?p=75
	def show_single_key
	  c = read_char
	 
	  case c
	  when " "
	    puts "SPACE"
	  when "\t"
	    puts "TAB"
	  when "\r"
	    puts "RETURN"
	  when "\n"
	    puts "LINE FEED"
	  when "\e"
	    puts "ESCAPE"
	  when "\e[A"
	    puts "UP ARROW"
	  when "\e[B"
	    puts "DOWN ARROW"
	  when "\e[C"
	    puts "RIGHT ARROW"
	  when "\e[D"
	    puts "LEFT ARROW"
	  when "\177"
	    puts "BACKSPACE"
	  when "\004"
	    puts "DELETE"
	  when "\e[3~"
	    puts "ALTERNATE DELETE"
	  when "\u0003"
	    puts "CONTROL-C"
	    exit 0
	  when /^.$/
	    puts "SINGLE CHAR HIT: #{c.inspect}"
	  else
	    puts "SOMETHING ELSE: #{c.inspect}"
	  end
	end
end
