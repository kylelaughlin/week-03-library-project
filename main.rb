require_relative "config/environment.rb"
require "active_record"
require "pry"
require "yaml"
require_relative "./lib/library.rb"
require_relative "./lib/staff_member.rb"
require_relative "./lib/book.rb"
require_relative "./lib/patron.rb"


# Main menu for the program. Allows selection of:
#   library Branches
#   staff members
#   books
#   patrons
def main_menu
  puts "\n\n   --- Library Manager Main Menu ---\n\n"
  print "Please select one of the following options:\n\n1. Library Branches\n"\
        "2. Staff Members\n"\
        "3. Books\n"\
        "4. Patrons\n\n >>"
  selection = gets.chomp.to_i
  #call valid_selection method - (users selection, array of acceptable choices)
  selection = valid_selection(selection,[1,2,3,4])
  case selection
  when 1
    libraries_menu
  when 2
    staff_members_menu
  when 3
    books_menu
  when 4
    patrons_menu
  else
    puts "Something broke - Main menu selection"
  end

end

#### LIBRARIES PATH ####################################

# The libraries menu which allows users to select from:
#   Show all libraries
#   Create new library
#   Back to Main Menue
def libraries_menu
  puts "\n\n   --- Library Branch Main Menu ---\n\n"
  print "Please select one of the following options:\n\n"\
        "1. Show all libraries\n2. Add new library\n"\
        "3. Back to Main Menu\n\n >>"
  selection = gets.chomp.to_i
  selection = valid_selection(selection, [1,2,3])
  case selection
  when 1
    libraries_index
  when 2
    library_new
  when 3
    main_menu
  else
    puts "Something broke = Libraries Menu Selection"
  end
end

# Displays all the libraries and attributes
# Can select between selecting a record to view/modify and going back to libraries menu
def libraries_index
  puts "\n\n   --- Library Branch Index ---\n\n"
  puts "All Library Locations:"
  Library.all.each do |l|
    puts l.record_display
  end

  print "\nPlease select one of the following options:\n1. Back to Library Menu\n\n >>"
  selection = gets.chomp.to_i
  selection = valid_selection(selection,[1])
  case selection
  when 1
    libraries_menu
  end
end

def library_new
  puts "\n\n   --- Add New Library ---\n\n"
  print "Please fill in all requested information.\n\nWhat is the name of the new library?\n"\
       "\n >>"
  branch_name = gets.chomp
  print "\nWhat is the address of the new library?\n\n >>"
  address = gets.chomp
  print "\nWhat is the phone number of the new library?\n\n >>"
  phone_number = gets.chomp
  save_new_library(branch_name, address, phone_number)
  libraries_menu
end

def save_new_library(branch_name, address, phone_number)
  new_library = Library.new(branch_name: branch_name,
                            address: address,
                            phone_number: phone_number)
  saved = new_library.save
  if saved
    puts "\nLibrary Created:"
    puts new_library.record_display
  else
    puts "\nLibrary not created\n"
    new_library.errors.messages.each do |k,v|
      puts "#{k} #{v}\n"
    end
  end
end

#### STAFF MEMBERS PATH ##################################

# Staff Members Menu: allows user to select between these options:
#   + Show all staff members
#   + Back to Main Menu
#
def staff_members_menu
  puts "\n\n   --- Staff Member Main Menu ---\n\n"
  print "Please select one of the following options:\n\n"\
        "1.Show all staff members\n"\
        "2. Back to Main Menu\n\n >>"
  selection = gets.chomp.to_i
  selection = valid_selection(selection, [1,2])

  case selection
  when 1
    staff_members_index
  when 2
    main_menu
  else
    puts "Something broke - Staff Member Menu Selection"
  end

end

# Staff Member Index: Shows all staff members and their infomation
#
def staff_members_index
  puts "\n\n   --- Library Branch Index ---\n\n"
  puts "All Staff Members:"
  StaffMember.all.each do |sm|
    puts "#{sm.id}. Name: #{sm.name}\n   Email: #{sm.email}"
  end

  print "\nPlease select one of the following options:\n1. Back to Staff Members Menu\n\n >>"
  selection = gets.chomp.to_i
  selection = valid_selection(selection,[1])
  case selection
  when 1
    staff_members_menu
  end
end

#### BOOKS PATH ####################################

# Books Menu: allows user to select between these options:
#   + Show all books
#   + Back to Main Menu
#
def books_menu
  puts "\n\n   --- Books Main Menu ---\n\n"
  print "Please select one of the following options:\n\n"\
        "1.Show all books\n"\
        "2. Back to Main Menu\n\n >>"
  selection = gets.chomp.to_i
  selection = valid_selection(selection, [1,2])

  case selection
  when 1
    books_index
  when 2
    main_menu
  else
    puts "Something broke - Books Menu Selection"
  end
end

# Books Index: Shows all books and their infomation
#
def books_index
  puts "\n\n   --- Books Index ---\n\n"
  puts "All Books:"
  Book.all.each do |b|
    puts "#{b.id}. Title: #{b.title}\n   Author: #{b.author}\n   ISBN: #{b.isbn}"
  end

  print "\nPlease select one of the following options:\n1. Back to Books Menu\n\n >>"
  selection = gets.chomp.to_i
  selection = valid_selection(selection,[1])
  case selection
  when 1
    books_menu
  end
end


#### PATRONS PATH ####################################

# Patrons Menu: allows user to select between these options:
#   + Show all patrons
#   + Back to Main Menu
#

def patrons_menu
  puts "\n\n   --- Patrons Main Menu ---\n\n"
  print "Please select one of the following options:\n\n"\
        "1.Show all patrons\n"\
        "2. Back to Main Menu\n\n >>"
  selection = gets.chomp.to_i
  selection = valid_selection(selection, [1,2])

  case selection
  when 1
    patrons_index
  when 2
    main_menu
  else
    puts "Something broke - Patrons Menu Selection"
  end
end

# Patrons Index: Shows all patrons and their infomation
#
def patrons_index
  puts "\n\n   --- Patrons Index ---\n\n"
  puts "All Patrons:"
  Book.all.each do |pn|
    puts "#{pn.id}. Name: #{pn.name}\n   Email: #{pn.email}"
  end

  print "\nPlease select one of the following options:\n1. Back to Books Menu\n\n >>"
  selection = gets.chomp.to_i
  selection = valid_selection(selection,[1])
  case selection
  when 1
    patrons_menu
  end
end



# Checks to see if a users selection is within the acceptable choices
#
# + selection: an integer representing the users selection
# + acceptable_choices: an array of choices that are valid given the options provided
def valid_selection(selection, acceptable_choices)
  while !(acceptable_choices.include? selection)
    print "That is an invalid selection please select an option from above.\n\n >>"
    selection = gets.chomp.to_i
  end
  selection
end

binding.pry
main_menu
