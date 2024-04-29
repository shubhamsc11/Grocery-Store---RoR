require "byebug"
require_relative "cm.rb"

class CustomerPanel
	def buyer_panel
		puts "\n\t\t\t\t ************************************** "
  	puts "\t\t\t\t\t|| CUSTOMER/BUYER PANEL || ".light_green.bold
    puts "\t\t\t\t ************************************** "
    puts "\nCustomer Options:-"
    puts " 1. SignUp \n 2. Login \n 3. Back \n 4. Exit "
    print 'Select option: '
    buyer_choice = gets.chomp.to_i
    case buyer_choice
    when 1
      SignLogin.new.signup
    when 2
      SignLogin.new.login
      customer_options
    when 3
      load 'login.rb'
    when 4
      PanelExit.new.panel_exits
    else
      puts 'Invalid Input. Try again!'
      buyer_panel
    end
  end

  def customer_options
    puts "\n-------------------------------------"
    puts "\t Customer Options ".light_yellow.bold
    puts "-------------------------------------\n"
    puts "\n 1. Available Products \n 2. Select Product to Purchase \n 3. List of Purchased Products \n 4. Return Product \n 5. Logout \n 6. Back \n 7. Exit " 
    print 'Select option: '
    cust_opt = gets.chomp.to_i
    case cust_opt
    when 1
      p_list
      customer_options
    when 2
      select_items
    when 3
      buy_list
      customer_options
    when 4
      return_product
    when 5
      LogoutExit.new.logout
    when 6
      buyer_panel
    when 7
      LogoutExit.new.exits
    else
      puts 'Invalid Input. Please Try again!'
      customer_options
    end
  end

  def p_list
    if $p_id != 0 
      table = Terminal::Table.new title: 'LIST OF PRODUCTS'.bold do |t|
        t.headings = ['P_id', 'P_Name', 'P_Price', 'P_Qty']
        t.rows = $products.map { |product| product.values}
        t.style = { :alignment => :center }
      end
      puts table
    else
      puts 'Sorry, No products available!!!'
      customer_options
    end
  end
  
  $total = 0
  $purchase = []
  $b_id = 0
  def select_items
    if $p_id != 0
      p_list
      puts "\nSelect products from the <List of Product>:- "
      print 'Enter Product id, which you want to purchase: '
      buy_id = gets.chomp.to_i
      print 'Enter quantity: '
      need_qty = gets.chomp.to_i

      buy_product = ''
      buy_p_p = 0
      $products.each do |product|
        if buy_id == product[:p_id]
          if product[:p_qty]-need_qty >= 0
            product[:p_qty] -= need_qty

            $b_id += 1
            $purchase.push({
              b_id: $b_id,
              buy_p_id: product[:p_id],
              buy_p_name: product[:p_name],
              buy_p_price: product[:p_price],
              buy_qty: need_qty
            })
          else
            puts "Sorry, Need_Qty #{need_qty} not available. Product quantity is only #{product[:p_qty]}. Please Try Again!"
            select_items
          end

          puts '**Ok, Product Selected.**'.light_blue
          puts "\n=> Your Purchasing Bill:-\n".light_green.bold
          bill = product[:p_price] * need_qty
          byebug
          $total += bill

          if $total != 0
            print "\n=> Your Older Bill Amount: #{$total}\n".light_green.bold
            buy_list
          end
          
          print "\n=> Current Bill: #{bill}\n\n".light_green.bold
          print "=> Your Total Bill: #{$total}\n\n".light_green.bold   
          print 'Do you want to select more items(y/n): '
          item_choice = gets.chomp.to_s
          if item_choice.downcase == 'y'
            puts "Okay!!! Continue...\n"
            select_items

          elsif item_choice.downcase == 'n'
            puts '**Thank You!!! Come again to Purchase.**'.yellow.bold
            next_step

          else
            puts 'You entered something wrong. Please enter (y/n)!!!'
            select_items
          end
        end
      end
      
      if $products.any? {|prod| buy_id != prod[:p_id]}
        puts 'Sorry, This Product not available!!! Please Select Something Else...'
        select_items
      end

    else
      puts 'Sorry, No products available in the product list!!!'
      next_step
    end
  end

  def buy_list
    if $b_id != 0
      table = Terminal::Table.new title: 'PURCHASED ITEMS LIST'.bold do |t|
        t.headings = ['Buy_id', 'P_id', 'P_Name', 'P_Price', 'Buy_Qty']
        t.rows = $purchase.map { |buy| buy.values}
        t.style = { :alignment => :center }
      end
      puts table

    else
      puts 'Sorry, No product purchased yet!!! Please purchase firstly...'
      next_step
    end
  end

  def return_product
    if $b_id != 0
      buy_list
      print 'Enter Product id, which you want to return: '
      return_id = gets.chomp.to_i
      print 'Enter quantity: '
      return_qty = gets.chomp.to_i
      
      $purchase.each do |b|
        if b[:buy_p_id] == return_id && (1..b[:buy_qty]).to_a.include?(return_qty) 
          print "\n=> Your Older Bill Amount: #{$total}\n\n".light_green.bold
          puts '**Ok, Product Returned.**'.light_blue
          puts "\n=> Your Latest Bill:-".light_green.bold
          new_bill = b[:buy_p_price] * return_qty
          $total -= new_bill
          b[:buy_qty] -= return_qty
          find_product(return_id, return_qty)
          print "\nAfter returning the #{return_qty} qty. of #{b[:buy_p_name]}, Your Total Bill: #{$total}\n".light_green.bold
          next_step
        end
      end
        
      if $purchase.any? {|buy| return_id != buy[:buy_p_id] && return_qty != buy[:buy_qty]}
        puts "Sorry, You entered something wrong!!! Please enter correct details, Try Again...\n"
        return_product
      end
    else
      puts 'Sorry, No product purchased yet!!! Please purchase firstly...'
      next_step
    end
  end

  def find_product(return_id, return_qty)
    $products.each do |product|
      if product[:p_id] == return_id
        product[:p_qty] += return_qty
      end
    end
  end

  def next_step
    case $user_role
    when 'admin'
      AdminPanel.new.customer_panel
    when 'customer'
      customer_options
    end
  end

end
