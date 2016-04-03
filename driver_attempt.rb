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
    "Exit. Close Application\n\n >>"
    selection = gets.chomp.downcase
    #call valid_selection method - (users selection, array of acceptable choices)
    selection = valid_selection(selection,["1","2","3","4","exit"])
    case selection
    when "1"
      model = "library"
      sub_menu(model)
    when "2"
      model = "staff_member"
      sub_menu(model)
    when "3"
      model = "book"
      sub_menu(model)
    when "4"
      model = "patron"
      sub_menu(model)
    when "exit"
      puts "\n\n Closing Application"
    else
      puts "Something broke - Main menu selection"
    end
  end

end

def sub_menu(model)
  selection = ""
  while selection != "back"
    puts "\n\n   ---- #{model.split("_").join(" ").capitalize} Menu ----\n\n"
    print "Options:\n1. Show #{model.split("_").join(" ")} index\n"\
         "2. New #{model.split("_").join(" ")}\n"\
         "Back. Go back to main menu\n\n >>"
    selection = gets.chomp.downcase
    selection = valid_selection(selection,["1","2","back"])
    case selection
    when "1"
      record_index(model)
    when "2"
      #new record
    when "back"
      #Go back to main Menue
    else
      puts "somthing broke - sub menu"
    end
  end
end

def record_index(model)
  puts "\n\n   ---- #{model.split("_").join(" ").capitalize} Index ----\n\n"
  puts "#{model.split("_").join(" ").capitalize.pluralize}:"
  model.camelize.constantize.all.each do |e|
    puts e.record_display
  end
end

# Checks to see if a users selection is within the acceptable choices
#
# + selection: an integer representing the users selection
# + acceptable_choices: an array of choices that are valid given the options provided
#
# Returns a string representing the valid user selection
def valid_selection(selection, acceptable_choices)
  while !(acceptable_choices.include? selection)
    print "That is an invalid selection please select an option from above.\n\n >>"
    selection = gets.chomp
  end
  selection
end

binding.pry
main_menu
