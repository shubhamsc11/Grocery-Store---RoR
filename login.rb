require "byebug"
require "colorize"
require_relative "cm.rb"
require_relative "admin.rb"
require_relative "shopper.rb"
require_relative "customer.rb"
require_relative "salesman.rb"

puts "\t\t\t ----------------------------------------------------------------------------- "
puts "\t\t\t\t\t|| { WELCOME TO SHRIFFLE GROCERY STORE } ||".black.on_light_yellow.bold
puts "\t\t\t ----------------------------------------------------------------------------- "
class Login
  def select_choice
    puts 'Please select your panel >>'.light_blue
    puts " 1. Admin Panel \n 2. Shopper Panel \n 3. Customer Panel \n 4. Salesman Panel \n 5. Exit "
    print 'Enter Your Choice: '
    choice = gets.chomp.to_i
    $user_role
    case choice
    when 1
      $user_role = 'admin'
      AdminPanel.new.admin_panel
    when 2
      $user_role = 'shopper'
      ShopperPanel.new.shopper_panel
    when 3
      $user_role = 'customer'
      CustomerPanel.new.buyer_panel
    when 4
      $user_role = 'salesman'
      SalesmanPanel.new.saler_panel
    when 5
      $user_role = ''
      PanelExit.new.panel_exits
    else
      puts "Invalid Input. Please Try again!\n"
      select_choice
    end
  end
end

login = Login.new
login.select_choice