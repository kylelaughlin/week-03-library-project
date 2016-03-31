require_relative "config/environment.rb"
require "active_record"
require "pry"
require "yaml"
require_relative "./lib/library.rb"

# Main menu for the program. Allows selection of:
#   library Branches
#   staff members
#   books
#   patrons
def main_menu
  puts "\n\n   --- Library Manager Main Menu ---\n\n"
  print "Please select one of the following options:\n\n1. Library Branches\n\n >>"
  selection = gets.chomp.to_i
  #call valid_selection method - (users selection, array of acceptable choices)
  selection = valid_selection(selection,[1])
  case selection
  when 1
    libraries_menu
  else
    puts "Something broke - Main menu selection"
  end

end

def libraries_menu
  puts "\n\n   --- Library Branch Main Menu ---\n\n"
  print "Please select on of the following options:\n\n1.Show all libraries\n2. Back to Main Menu\n\n >>"
  selection = gets.chomp.to_i
  selection = valid_selection(selection, [1,2])
end

def valid_selection(selection, acceptable_choices)
  while !(acceptable_choices.include? selection)
    print "That is an invalid selection please select an option from above.\n\n>>"
    selection = gets.chomp.to_i
  end
  selection
end


main_menu

#binding.pry
