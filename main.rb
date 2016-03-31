require_relative "config/environment.rb"
require "active_record"
require "pry"
require "yaml"
require_relative "./lib/library.rb"

def main_menu
  puts "\n\n--- Library Manager Main Menu ---\n\n"
  print "Please select one of the following options:\n\n1. Library Branches\n\n >>"
  selection = gets.chomp.to_i
  while !([1].include? selection)
    print "That is an invalid selection please select an option from above.\n\n>>"
    selection = gets.chomp.to_i
  end
  case selection
  when 1
    libraries_menu
  else
    puts "Something broke - Main menu selection"
  end

end

main_menu


#binding.pry
