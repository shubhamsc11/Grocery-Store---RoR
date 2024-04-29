require "byebug"
require_relative "cm.rb"
require 'terminal-table'

class SalesmanPanel
	def saler_panel
		puts "\t\t\t\t ************************************** "
  	puts "\t\t\t\t\t || #{'SALESMAN PANEL'.light_red.bold} || "
    puts "\t\t\t\t ************************************** "
    puts "\nSalesman Options:-"
    puts " 1. SignUp \n 2. Login \n 3. Back \n 4. Exit "
    print 'Select option: '
    saler_choice = gets.chomp.to_i
    case saler_choice
    when 1
      SignLogin.new.signup
    when 2
      SignLogin.new.login
      saler_options
    when 3
      load 'login.rb'
    when 4
      PanelExit.new.panel_exits
    else
      puts 'Invalid Input. Try again!'
      saler_panel
    end
  end

  def saler_options
    puts "\n-------------------------------------"
    puts "\t Salesman Options ".light_yellow.bold
    puts "-------------------------------------\n"
    puts "\n 1. Add Items \n 2. List of Products \n 3. Sell Products \n 4. List of Sold Products \n 5. Logout \n 6. Back \n 7. Exit "
    print 'Select option: '
    saler_opt = gets.chomp.to_i
    case saler_opt
    when 1
      saler_add_items
    when 2
      saler_product_list
      saler_options
    when 3
      sell_product
      saler_options
    when 4
      sold_product_list
      saler_options
    when 5
      LogoutExit.new.logout
    when 6
      saler_panel
    when 7
      LogoutExit.new.exits
    else
      puts 'Invalid Input. Please Try again!'
      saler_options
    end
  end

  $saler_products = [{sp_id: 1, p_name: 'sugar', p_price: 40, p_qty: 80},
    {sp_id: 2, p_name: 'tea', p_price: 50, p_qty: 30},
    {sp_id: 3, p_name: 'coffee', p_price: 25, p_qty: 60}]
  $sp_id = 3
  def saler_add_items
    $sp_id += 1
    puts "\n||  ADD ITEMS  ||"
    puts '-----------------'
    print "\nEnter Product Name: "
    p_name = gets.chomp
    print 'Enter Product Price: '
    p_price = gets.chomp.to_i
    print 'Enter Product Quantity: '
    p_qty = gets.chomp.to_i

    if $saler_products.any? { |prod| prod[:p_name] == p_name }
      $products.each do |prod|
        puts '**Product Found**'.light_blue.bold
        prod[:p_qty] += p_qty
        $sp_id -= 1
        puts 'Product Quantity added successfully!'
        next_step
      end
    
    else
      $saler_products.push({
        sp_id: $sp_id,
        p_name: p_name,
        p_price: p_price,
        p_qty: p_qty
        })

      if p_name != '' && p_price != '' && p_qty != ''
        puts "\n=> Product added successfully. You may see changes in '|List of Products|'..!!\n"
        next_step
      else
        puts "Product details should not be empty. Try again!\n"
        saler_add_items
      end
    end
  end

  def saler_product_list
    if $sp_id != 0 
      puts "\n|| LIST OF PRODUCTS ||"
      puts "----------------------\n"
      table = Terminal::Table.new do |t|
        t.headings = ['SP_id', 'P_Name', 'P_Price', 'P_Qty']
        t.rows = $saler_products.map { |sell| sell.values}
        t.style = { :alignment => :center }
      end
      puts table
    else
      puts 'Sorry, No products available!! Please add firstly..'
      saler_options
    end
  end

  $sellamount = 0
  $sold_products = []
  $sold_id = 0
  def sell_product
    unless $sp_id.zero?
      saler_product_list
      print "\nEnter Product id, Which you want to sell: "
      sell_id = gets.chomp.to_i
      print 'Enter Quantity: '
      sell_qty = gets.chomp.to_i

      $saler_products.each do |sell|
        if sell[:sp_id] == sell_id && (1..sell[:p_qty]).to_a.include?(sell_qty)
          check_sellamount
          sell_bill = sell[:p_price] * sell_qty
          $sellamount += sell_bill
          sell[:p_qty] -= sell_qty

          $sold_id += 1
          $sold_products.push ({
            sold_id: $sold_id,
            sold_p_id: sell[:sp_id],
            sold_p_name: sell[:p_name],
            sold_p_price: sell[:p_price],
            left_qty: sell[:p_qty],
            sold_p_qty: sell_qty  
          })

          sold_product_list
          
          sold_product_add_admin_items(sell[:p_name], sell[:p_price], sell[:p_qty])

          puts "\nCurrent Selling Bill:- #{sell_bill}".light_yellow
          puts "Total Selling Bill Amount:- #{$sellamount}".light_yellow
          puts 'Sold Product Successfully!!!'.light_blue
          next_step
        end 
      end

      if $saler_products.any? {|sell| sell[:sp_id] != sell_id && sell[:p_qty] != sell_qty}
        puts "Sorry, You entered something wrong!!! Please enter correct details, Try Again...\n"
        sell_product
      end
    else
      puts 'Sorry, No products available!! Please add firstly..'
      next_step
    end
  end

  def check_sellamount
    if $sellamount != 0
      puts "\nOlder Selling Amount: #{$sellamount}".light_yellow
    end
  end

  def sold_product_list
    if $sold_id != 0
      puts "\n|| LIST OF SOLD PRODUCTS ||"
      puts "---------------------------\n"
      table = Terminal::Table.new do |t|
        t.headings = ['Sold_id', 'Sold_P_id', 'Sold_P_Name', 'Sold_P_Price', 'Left_Qty', 'Sold_P_Qty']
        t.rows = $sold_products.map { |sold| sold.values}
        t.style = { :alignment => :center }
      end
      puts table

    else
      puts 'Sorry, No product sold yet!!! Sell something firstly...'
      next_step
    end
  end

  def sold_product_add_admin_items(p_name, p_price, p_qty)
    if $products.any? {|product| product[:p_name] != p_name && product[:p_qty] != p_qty}
      $p_id += 1
      $products.push ({
          p_id: $p_id,
          p_name: p_name,
          p_price: p_price,
          p_qty: p_qty
          })
    end
  end 

  def next_step
    case $user_role
    when 'admin'
      AdminPanel.new.salesman_panel
    when 'salesman'
      saler_options
    end
  end
end
