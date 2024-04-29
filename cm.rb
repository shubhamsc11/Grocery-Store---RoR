require "io/console"
require "byebug"

class SignLogin
	$u_id = 0
	$user1 = {}
	$user2 = []
	$user3 = []
	$c_id = 0
	$s_id = 0
	
	def signup
		$u_id += 1
		puts "\n-----------------------"
	  puts "\t Sign-Up ".red.on_light_yellow.bold 
	  puts "-----------------------\n"
	  print "User id : "
	  user_id = gets.chomp
	  # puts '* NOTE:- Password can be 6-8 characters & in this range only- [A..Z,a..z,1..9,sp.char.(@$#%..etc.)]'.light_green
	  print "Password : " 
	  pswd = gets.chomp.to_i
	  # pswd = STDIN.noecho(&:gets).chomp
	  # regex = /\A[\w+\-.]+@[a-z\d\-]+(\.[a-z\d\-]+)*\.[a-z]+\z/i
	  # pswd_regex = /^(?=.*[a-zA-Z])(?=.*[0-9]).{4,10}$/ #pswd should be 4 to 10 chars.
    # if user_id =~ regex && pswd =~ pswd_regex
    # Ex:- email_id = shubh@gmail.com     pswd = Shubh@123

    if user_id == 'abc' && pswd == 123
    	case $user_role
	  	when 'shopper'
	  		$user1[:u_id] = $u_id
	  		$user1[:sp_id] = 1
	      $user1[:user_id] = user_id
	      $user1[:pswd]	= pswd
	    	puts "\nSign Up Successfully. Now login to continue...\n\n"
	    	ShopperPanel.new.shopper_panel
	    
	    when 'customer'
	    	$c_id += 1
	    	$user2 << ({
	      	u_id: $u_id,
	      	c_id: $c_id,
	        user_id: user_id,
	        pswd: pswd
	        })
	    	puts "\nSign Up Successfully. Now login to continue...\n\n"
	    	CustomerPanel.new.buyer_panel

	    when 'salesman'
	    	$s_id += 1
	    	$user3 << ({
	      	u_id: $u_id,
	      	s_id: $s_id,
	        user_id: user_id,
	        pswd: pswd
	        })
	    	puts "\nSign Up Successfully. Now login to continue...\n\n"
	    	SalesmanPanel.new.saler_panel
	    end

    else
      puts "\nYou entered something wrong. Try again!"
      signup
    end
  end

	def login
    if $u_id != 0
      puts "\n----------------------"
      puts "\t Login ".red.on_light_yellow.bold  
      puts "----------------------\n"
      print 'User id: '
      user_id2 = gets.chomp
      print 'Password: '
      # pswd2 = STDIN.noecho(&:gets).chomp
	  	pswd2 = gets.chomp.to_i
      
      case $user_role
    	when 'shopper'
    		if $sp_id != 0
	    		if user_id2 == $user1[:user_id] && pswd2 == $user1[:pswd]
	    			puts "\nLogin Successfully!!! Welcome #{$user_role}"
	        else
	      		puts "\n=> Sorry, Match not found!!! Please Try again...\n=> #{'NOTE'.light_red.bold}:- Please enter correct credentials! OR Sign Up with new credentials!"
	      		ShopperPanel.new.shopper_panel
	      	end
	      else
	      	puts "\nNo shopper sign-up yet! Sign up firstly before login..."
	      end

    	when 'customer'
    		if $c_id != 0
	    		$user2.each do |user2|
	    			if user_id2 == user2[:user_id] && pswd2 == user2[:pswd]
	    				puts "\nLogin Successfully!!! Welcome #{$user_role}"
	    			end
	    		end

	      	if $user2.any? {|user2| user_id2 != user2[:user_id] && pswd2 != user2[:pswd]}
	      		puts "Sorry, Incorrect Credentials! Try again...\n"
	      		login
	      	end
	      else
	      	puts "\nNo customer sign-up yet! Sign up firstly before login..."
	      	signup
	      end

    	when 'salesman'
    		if $s_id != 0
		  		$user3.each do |user3|
		  			if user_id2 == user3[:user_id] && pswd2 == user3[:pswd]
		  				puts "\nLogin Successfully!!! Welcome #{$user_role}"
		  			end
		  		end

		  		if $user3.any? {|user3| user_id2 != user3[:user_id] && pswd2 != user3[:pswd]}
		    		puts "Sorry, Incorrect Credentials! Try again...\n"
		    		login
		    	end
		    else
		    	puts "\nNo salesman signup yet! Sign up firstly before login..."
	      	signup
	      end
    	end
        
    else
      puts "No users sign-up yet! Please sign up firstly...\n\n"
      # Login.new.select_choice
      signup
    end
  end
end

# list of users
class Users
	def users_exist
    if $u_id != 0 
      puts "LIST OF EXIST USERS:-\n".light_blue.bold
      if $sp_id != 0
	      table = Terminal::Table.new title: 'Shopper Details'.bold, headings: ['U.id.','Sp.id.','Email_id','Password'], rows: [$user1.values], style: {:alignment => :center}
	      puts table
		  end

		  if $c_id != 0
		  	table = Terminal::Table.new title: 'Customer Details'.bold do |t|
		      t.headings = ['U.id.', 'C.id.', 'Email_id', 'Password']
		      t.rows = $user2.map { |user| user.values }
		      t.style = {:alignment => :center}
	      end
	      puts table
	    end

	    if $s_id != 0
	    	table = Terminal::Table.new title: 'Salesman Details'.bold do |t|
		      t.headings = ['U.id.', 'S.id.', 'Email_id', 'Password']
		      t.rows = $user3.map { |user| user.values }
		      t.style = {:alignment => :center}
	      end
	      puts table
	    end
    else
      puts "No users sign-up yet!!!\n"
    end
  end
end


class LogoutExit
	def logout
		print "\n=> Do you want to logout, sure?(y/n): "
    logout_option = gets.chomp
    if logout_option.downcase == 'y'
      puts 'Logout Successfully!!!'
      puts '****Thank You, Please visit again****'
      load 'login.rb'

    elsif logout_option.downcase == 'n'
    	puts "Okay!!! Continue ...\n"
	  	case $user_role
    	when 'admin'
    		AdminPanel.new.admin_options
    	when 'shopper'
      	ShopperPanel.new.shopper_options
      when 'customer'
    		CustomerPanel.new.customer_options
    	when 'salesman'
    		SalesmanPanel.new.saler_options
    	end

    else
      puts "Invalid Input. Please press 'Y|y' or 'N|n' !\n"
      logout
    end
	end

	def exits
		print "\n=> Do you want to exit, sure?(y/n): "
    exit_option = gets.chomp
    if exit_option.downcase == 'y'
      puts '****Thank You, Please Visit Again!!!****'
      exit

    elsif exit_option.downcase == 'n'
    	puts "Okay!!! Continue ...\n"
      case $user_role
    	when 'admin'
    		AdminPanel.new.admin_options
    	when 'shopper'
      	ShopperPanel.new.shopper_options
      when 'customer'
    		CustomerPanel.new.customer_options
    	when 'salesman'
    		SalesmanPanel.new.saler_options
    	end

    else
      puts "Invalid Input. Please press 'Y|y' or 'N|n' !\n"
      exits
    end
	end
end


class PanelExit
	def panel_exits
		print "\n=> Do you want to exit, sure?(y/n): "
    exit_option = gets.chomp.to_s
    if exit_option.downcase == 'y'
      puts '****Thank You, Please visit again****'
      exit 

    elsif exit_option.downcase == 'n'
	  	puts "Okay!!! Continue ...\n"
	  	case $user_role
	  	when 'admin'
	  		AdminPanel.new.admin_panel
	    when 'shopper'
	    	ShopperPanel.new.shopper_panel
	    when 'customer'
	  		CustomerPanel.new.buyer_panel
	  	when 'salesman'
	  		SalesmanPanel.new.saler_panel
	  	when ''
	  		load 'login.rb'
	  	end

    else
      puts "Invalid Input. Please press 'Y|y' or 'N|n' !\n"
    	panel_exits
    end
	end
end

