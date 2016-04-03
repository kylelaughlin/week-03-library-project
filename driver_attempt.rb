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
    selection = valid_selection(selection,[1,2,3,4,"exit"])
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
    selection = valid_selection(selection,[1,2,"back"])
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
  display_index(model)
  selection = ""
  while selection != "back"
    print "\n\nPlease select a #{model.split("_").join(" ")} from above"\
          " or type 'back' to return to #{model.split("_").join(" ").pluralize} menu.\n\n >>"
    selection = gets.chomp.downcase
    selection = valid_selection(selection,all_record_ids(model))
    case
    when "back"
      #go back to sub menu
    else
      # selection.to_i represents the selected records id
      selected_record(model, selection.to_i)
    end
  end
end

def display_index(model)
  puts "#{model.split("_").join(" ").capitalize.pluralize}:"
  model.camelize.constantize.all.each do |e|
    puts e.record_display
  end
end

def all_record_ids(model)
  ids = []
  model.camelize.constantize.all.each do |e|
    ids << e.id
  end
  ids
end

def selected_record(model, record_id)
  selection = ""
  while selection != "back"
    puts "\n\n   ---- Selected #{model.split("_").join(" ")} ----\n\n"
    puts model.camelize.constantize.record_display
    print "\nPlease select one of the following options:\n1. Edit\nBack. "\
         "Go back to #{model.split("_").join(" ").pluralize} index\n\n >>"
    selection = gets.chomp.downcase
    selection = valid_selection(selection,[1])
    case selection
    when "1"
      edit_record
    when "back"
      #Go back to index
    else
      puts "something broke - selected record options"
    end
  end
end


##########################################################
#### CREATE NEW RECORDS ##################################
##########################################################

# Directs the user to the appropriate new record interface for a given model
#
# + model: a string representing the type of records being worked with
#
# Returns nil
def new_recrod_director(model)
  case model
  when "lirary"
    new_library_record(model)
  when "staff_member"
    new_staff_member_record(model)
  when "book"
    new_book_record(model)
  when "patron"
    new_patron_record(model)
  else
    puts "somthing broke - new_record_director"
  end
end

#========= NEW LIBRARY ===========

# Prompts for new library information
#
# + model: a string representing the type of record being created
#
# Calls method
def new_library_record(model)
  puts "\n\n   --- Add New Library ---\n\n"
  print "Please fill in all requested information.\n\nWhat is the name of the new library?\n"\
  "\n >>"
  branch_name = gets.chomp
  print "\nWhat is the address of the new library?\n\n >>"
  address = gets.chomp
  print "\nWhat is the phone number of the new library?\n\n >>"
  phone_number = gets.chomp
  save_new_library(branch_name, address, phone_number, model)
end

# Saves the new library record
#
# + branch_name: a string representing the name of the new library branch
# + address: a string representing the address of the new library branch
# + phone_number: a string representing the phone number of the new library branch
# + model: a string representing the type of record being created
#
# Returns nil
def save_new_library(branch_name, address, phone_number, model)
  new_library = Library.new(branch_name: branch_name,
                            address: address,
                            phone_number: phone_number)
  saved = new_library.save
  record_save_result(saved, new_library, model)
end

#========= NEW STAFF MEMBER ===========

# Gather for new staff member info
#
# + model: a string representing the type of record being created
#
# Calls new_staff_member to save and validate record
def new_staff_member_record(model)
  puts "\n\n   --- Add New Staff Member ---\n\n"
  print "Please fill in all requested information.\n\n"\
  "What is the new staff member's name?\n"\
  "\n >>"
  name = gets.chomp
  print "\nWhat is the new staff member's email?\n\n >>"
  email = gets.chomp
  save_new_staff_member(name, email, model)
end

# Saves new staff member to table
#
# + name: a string representing the new staff members name
# + email: a string representing the new staff memners email
# + model: a string representing the type of record being created
#
# Calls method to confirm or reject save
def save_new_staff_member(name, email, model)
  new_staff_member = StaffMember.new(name: name, email: email)
  saved = new_staff_member.save
  record_save_result(saved, new_staff_member, model)
  assign_to_library(new_staff_member) if saved
end

# Assign a new staff member to a home library
#
# +new_staff_member: a staff member object
#
# Returns nil
def assign_to_library(new_staff_member)
  puts "\nPlease select one of the following libraries for the new staff member:"
  Library.all.each do |l|
    puts l.record_display
  end
  puts "\n >>"
  selection = gets.chomp.to_i
  while Library.find_by_id(selection).nil?
    print "That is not a valid selection. Please select from the libraries above.\n\n >>"
    selection = gets.chomp.to_i
  end
  new_staff_member.library = Library.find_by_id(selection)
  puts "\n#{new_staff_member.name} is now assigned to #{new_staff_member.library.branch_name}"
end

#========= NEW BOOK ===========




# Confirms if the new record is saved, shows errors if not saved
#
# + saved: a boolean value representing if the record saved or not
# + new_object: an object representing the new record being created
# + model: a string representing the class being utilized
#
# Returns nil
def record_save_result(saved, new_object, model)
  if saved
    puts "\n#{model.split("_").join(" ").capitalize} created:"
    puts new_object.record_display
  else
    puts "\n#{model.split("_").join(" ").capitalize} not created!\n"
    new_object.errors.messages.each do |k,v|
      puts "#{k} #{v}\n"
    end
  end
end

# Checks to see if a users selection is within the acceptable choices
#
# + selection: an integer representing the users selection
# + acceptable_choices: an array of choices that are valid given the options provided
#
# Returns a string representing the valid user selection
def valid_selection(selection, acceptable_choices)
  while !(acceptable_choices.include? selection.to_i) && selection != "back" && selection != "exit"
    print "That is an invalid selection please select an option from above.\n\n >>"
    selection = gets.chomp
  end
  selection
end

binding.pry
main_menu
