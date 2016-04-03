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
#
# Returns nil
def main_menu
  selection = ""
  while selection != "exit"
    puts "\n\n   --- Library Manager Main Menu ---\n\n"
    print "Please select one of the following options:\n\n1. Library Branches\n"\
    "2. Staff Members\n"\
    "3. Books\n"\
    "4. Patrons\n"\
    "Exit. Close Application\n >>"
    selection = gets.chomp.downcase
    #call valid_selection method - (users selection, array of acceptable choices)
    selection = valid_selection(selection,["1","2","3","4","exit"])
    case selection
    when "1"
      libraries_menu
    when "2"
      staff_members_menu
    when "3"
      books_menu
    when "4"
      patrons_menu
    when "exit"
      puts "\n\n Closing Application"
    else
      puts "Something broke - Main menu selection"
    end
  end

end
