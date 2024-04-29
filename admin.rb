require "byebug"
require_relative "cm.rb"

class AdminPanel
  def admin_panel
    puts "\n\t\t\t\t ************************************** "
    puts "\t\t\t\t\t || ADMIN PANEL || ".blue.on_light_white.bold
    puts "\t\t\t\t ************************************** "

    puts "\nAdmin Options:-"
    puts " 1. Login \n 2. Back \n 3. Exit "
    print 'Select option: '
    admin_choice = gets.chomp.to_i
    case admin_choice
    when 1
      admin_login
    when 2
      load 'login.rb'
    when 3
      PanelExit.new.panel_exits
    else
      puts 'Invalid Input. Try again!'
      admin_panel
    end
  end

  def admin_login
    puts "\n----------------------"
    puts "\t Login ".red.on_light_yellow.bold  
    puts "----------------------\n"
    print 'User id: '
    user_id = gets.chomp
    print 'Password: '
    pswd = gets.chomp.to_i

    if user_id == 'admin' && pswd == 123
      puts "Login Successfully!!! Welcome #{$user_role}"
      admin_options
    else
      puts "\nSorry, Match not found! Please Try Again..."
      admin_panel
    end
  end


  def admin_options
    puts "\n-------------------------------------"
    puts "\t Admin Options ".light_yellow.bold
    puts "-------------------------------------\n"

    puts "\n 1. List of users \n 2. Shopper Panel \n 3. Customer Panel \n 4. Salesman Panel \n 5. Logout \n 6. Back \n 7. Exit " 
    print 'Select option: '
    admin_opt = gets.chomp.to_i
    case admin_opt
    when 1
      Users.new.users_exist
      admin_options
    when 2
      shopper_panel
    when 3
      customer_panel
    when 4
      salesman_panel
    when 5
      LogoutExit.new.logout
    when 6
      admin_panel
    when 7
      LogoutExit.new.exits
    else
      puts "Invalid Input. Please Try again!\n"
      shopper_options
    end
  end

  def shopper_panel
    puts "\n-------------"
    puts 'Shopper_Panel'.light_yellow
    puts "-------------\n"

    puts 'Admin Options:-'
    puts " 1. List of Products \n 2. Add Items \n 3. Update Item Details \n 4. Remove Items \n 5. Total Selling Amount \n 6. Back "
    print 'Choose option: '
    admin_opt = gets.chomp.to_i
    case admin_opt
    when 1
      ShopperPanel.new.product_list
      shopper_panel
    when 2
      ShopperPanel.new.add_items
    when 3
      ShopperPanel.new.update_details
    when 4
      ShopperPanel.new.remove_items
    when 5
      puts "Total Selling Amount by Shopper :- #{$total}\n".light_green.bold
      shopper_panel
    when 6
      admin_options
    else
      puts 'Invalid Input! Try again...'
      shopper_panel
    end
  end

  def customer_panel
    puts "\n--------------"
    puts 'Customer_Panel'.light_yellow
    puts "-------------\n"

    puts 'Admin Options:-'
    puts " 1. List of Available of Products \n 2. Select Product to Purchase \n 3. List of Purchased Products \n 4. Return Product \n 5. Total Purchasing Amount \n 6. Back "
    print 'Choose option: '
    admin_opt = gets.chomp.to_i
    case admin_opt
    when 1
      CustomerPanel.new.p_list
      customer_panel
    when 2
      CustomerPanel.new.select_items
    when 3
      CustomerPanel.new.buy_list
      customer_panel
    when 4
      CustomerPanel.new.return_product
      customer_panel
    when 5
      puts "Total Purchasing Amount by Customer :- #{$total}\n".light_green.bold
      customer_panel
    when 6
      admin_options
    else
      puts 'Invalid Input! Try again...'
      customer_panel
    end
  end

  def salesman_panel
    puts "\n--------------"
    puts 'Salesman_Panel'.light_yellow
    puts "-------------\n"

    puts 'Admin Options:-'
    puts " 1. List of Products \n 2. Add Items \n 3. Sell Products \n 4. List of Sold Products \n 5. Total Selling Amount \n 6. Back "
    print 'Choose option: '
    admin_opt = gets.chomp.to_i
    case admin_opt
    when 1
      SalesmanPanel.new.saler_product_list
      salesman_panel
    when 2
      SalesmanPanel.new.saler_add_items
    when 3
      SalesmanPanel.new.sell_product
    when 4
      SalesmanPanel.new.sold_product_list
      salesman_panel
    when 5
      puts "Total Selling Amount by Salesman :- #{$sellamount}\n".light_green.bold
      salesman_panel
    when 6
      admin_options
    else
      puts 'Invalid Input! Try again...'
      salesman_panel
    end
  end
end