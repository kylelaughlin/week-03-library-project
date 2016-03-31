require_relative "config/environment.rb"
require "active_record"
require "pry"
require "yaml"
require_relative "./lib/library.rb"
require_relative "./lib/staff_member.rb"


# Main menu for the program. Allows selection of:
#   library Branches
#   staff members
#   books
#   patrons
def main_menu
  puts "\n\n   --- Library Manager Main Menu ---\n\n"
  print "Please select one of the following options:\n\n1. Library Branches\n"\
        "2. Staff Members\n\n >>"
  selection = gets.chomp.to_i
  #call valid_selection method - (users selection, array of acceptable choices)
  selection = valid_selection(selection,[1,2])
  case selection
  when 1
    libraries_menu
  when 2
    staff_members_menu
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
  print "Please select one of the following options:\n\n1.Show all libraries\n2. Back to Main Menu\n\n >>"
  selection = gets.chomp.to_i
  selection = valid_selection(selection, [1,2])
  case selection
  when 1
    libraries_index
  when 2
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
    puts "#{l.id}. Name: #{l.branch_name}\n   Address: #{l.address}\n   Phone Number: #{l.phone_number}"
  end
=begin Commented out becuase it is beyon the scope of my initial feature
  print "\nPlease select one of the following options:\n1. Select a Library\n2. Back to Library Menu\n\n >>"
  selection = gets.chomp.to_i
  selection = valid_selection(selection,[1,2])
  case selection
  when 1
    print "Please select one of the Libraries listed above.\n >>"
    library_record(selection)
  when 2
    libraries_menu
  end
=end
end

#### STAFF MEMBERS PATH ##################################

# Staff Members Menu: allows user to select between these options:
#   + Show all staff members
#   + Back to Main Menu
#
def staff_members_menu
  puts "\n\n   --- Staff member Main Menu ---\n\n"
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
    puts "Something broke = Libraries Menu Selection"
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


main_menu

#binding.pry
