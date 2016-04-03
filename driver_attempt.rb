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

# Sub menu to select actions on a model
#
# +model: a string representing the object type to be utilized
#
# Returns nil
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
      new_record_director(model)
    when "back"
      #Go back to main Menue
    else
      puts "somthing broke - sub menu"
    end
  end
end

# User selects a record to view
#
# + model: a string representing the objects type
#
# Returns nil
def record_index(model)
  puts "\n\n   ---- #{model.split("_").join(" ").capitalize} Index ----\n\n"
  display_index(model)
  selection = ""
  while selection != "back"
    print "\n\nPlease select a #{model.split("_").join(" ")} from above"\
          " or type 'back' to return to #{model.split("_").join(" ").pluralize} menu.\n\n >>"
    selection = gets.chomp.downcase
    selection = valid_selection(selection,all_record_ids(model))
    case selection
    when "back"
      #go back to sub menu
    else
      # selection.to_i represents the selected records id
      selected_record(model, selection.to_i)
    end
  end
end

# Formats and displays of all records for a given model type
#
# +model: a string representing the object type to be displayed
#
# Returns nil
def display_index(model)
  puts "#{model.split("_").join(" ").capitalize.pluralize}:"
  model.camelize.constantize.all.each do |e|
    puts e.record_display
  end
end

# Creates an array of all ids for a given table
#
# +model: a string representing the table to gather ids from
#
# Returns an array of all ids for a given table
def all_record_ids(model)
  ids = []
  model.camelize.constantize.all.each do |e|
    ids << e.id
  end
  ids
end

# User can select to edit or go back from the record selected to veiw
#
#
def selected_record(model, record_id)
  selected_object = model.camelize.constantize.find_by_id(record_id)
  selection = ""
  while selection != "back"
    puts "\n\n   ---- Selected #{model.split("_").join(" ")} ----\n\n"
    puts selected_object.record_display
    print "\nPlease select one of the following options:\n1. Edit\nBack. "\
         "Go back to #{model.split("_").join(" ").pluralize} index\n\n >>"
    selection = gets.chomp.downcase
    selection = valid_selection(selection,[1])
    case selection
    when "1"
      edit_record_director(model, selected_object)
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
def new_record_director(model)
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
  assign_record_to_library(new_staff_member, model) if saved
end

#========= NEW BOOK ===========

# Gathers info for a new book record
#
# + model: a string representing the type of record to be created
#
# Calls save_new_book method to save and validate new book record
def new_book_record(model)
  puts "\n\n   --- Add New Book ---\n\n"
  print "Please fill in all requested information.\n\n"\
  "What is the title of the book?\n\n >>"
  title = gets.chomp
  print "\nWho is the author of the book?\n\n >>"
  author = gets.chomp
  print "What is the ISBN of the book?\n\n >>"
  isbn = gets.chomp
  save_new_book(title, author, isbn, model)
end

# Saves new book record, if valid. if not valid shows errorrs
#
# + title: string representing the title of the new book
# + author: string representing the author of the new book
# + isbn: string representing the ISBN number of the new book
# + model: a string representing the type of record being created
#
# Returns nil
def save_new_book(title, author, isbn, model)
  new_book = Book.new(title: title, author: author, isbn: isbn)
  saved = new_book.save
  record_save_result(saved, new_book, model)
  assign_record_to_library(new_book, model) if saved
end

#========= NEW PATRON ===========

# Gather information for a new patron record
#
# + model: a string representing the type of object to be created
#
# Calls save_new_patron to save a validate record
def new_patron_record(model)
  puts "\n\n   --- Add New Patron ---\n\n"
  print "Please fill in all requested information.\n\n"\
  "What is the patron's name?\n\n >>"
  name = gets.chomp
  print "\nWhat is the patron's email?\n\n >>"
  email = gets.chomp
  save_new_patron(name, email, model)
end

# Save and validate the record, don't save and show errors if invalid record
#
# + name: string representing the name of the new patron
# + email: string representing the email of the new patron
#
# Calls method to acknowledge the save or show errors if not saved
def save_new_patron(name, email, model)
  new_patron = Patron.new(name: name, email: email, books_checked_out_count: 0)
  saved = new_patron.save
  record_save_result(saved, new_patron, model)
end


#========= NEW RECORD HELPER METHODS ===========


# Assign a new staff member to a home library
#
# +new_staff_member: a staff member object
#
# Calls class to create relatinship between object and library
def assign_record_to_library(new_object, model)
  puts "\nPlease select one of the following libraries for the new staff member:"
  Library.all.each do |l|
    puts l.record_display
  end
  print "\n >>"
  selection = gets.chomp.to_i
  while Library.find_by_id(selection).nil?
    print "That is not a valid selection. Please select from the libraries above.\n\n >>"
    selection = gets.chomp.to_i
  end
  selected_library = Library.find_by_id(selection)
  create_relationship_with_library(new_object, selected_library, model)
end

# Creates relationship between the new_object and a library
#
# + new_object: an object representing the the object to be assigned to a library
# + selected_library: a Library object to which the new object will be assigned
# + model: a string representing the type of new_object
#
# Returns nil
def create_relationship_with_library(new_object, selected_library, model)
  if model == "book"
    new_object.library = selected_library
    puts "\n#{new_object.title} is now assigned to #{new_object.library.branch_name}"
  elsif model == "staff_member"
    new_object.library << selected_library
    puts "\n#{new_object.name} is now assigned to a library."
  else
    puts "something broke - new record library relationship creation"
  end
end

###################################################
#### EDIT RECORD METHODS ##########################
###################################################

def edit_record_director(model, selected_object)
  case model
  when "library"
    edit_library_record(selected_object)
  when "book"
    #edit_book_record
  when "staff_member"
    #edit_staff_member_record
  when "patron"
    #edit_patron_record
  else
    puts "Something broke - edit record director"
  end
end

#========== EDIT LIBRARY RECORD =============

# Select which library attribute to change
#
# + selected_lbrary: a library object which was selected by the user
#
# Returns nil
def edit_library_record(selected_library, model)
  selection = ""
  while selection != "back"
    puts "\n\n   --- Edit #{selected_library.branch_name} ---\n\n"
    print "What would you like to edit?\n"
    print "#{selected_library.record_edit_display}\nBack. Go back to Selected Library\n >>"
    selection = gets.chomp.downcase
    selection = valid_selection(selection, ["1","2","3","back"])
    case selection
    when "1"
      edit_library_branch_name(selected_library, model)
    when "2"
      edit_library_address(selected_library, model)
    when "3"
      edit_library_phone_number(selected_library, model)
    when "back"
      #back to selected library record
    else
      puts "Something broke - Library edit record selection"
    end
  end
end

# Change the library branch_name
#
# + selected_lbrary: a library object which was selected by the user
#
# Calls method to confirm save or show errors
def edit_library_branch_name(selected_library, model)
  print "New branch name: >>"
  branch_name = gets.chomp
  saved = selected_library.update_attributes(branch_name: branch_name)
  record_save_result(saved, selected_library, model)
end

# Change the library address
#
# + selected_lbrary: a library object which was selected by the user
#
# Calls method to confirm save or show errors
def edit_library_address(selected_library, model)
  print "New address: >>"
  address = gets.chomp
  saved = selected_library.update_attributes(address: address)
  record_save_result(saved, selected_library, model)
end

# Change the library phone_number
#
# + selected_lbrary: a library object which was selected by the user
#
# Calls method to confirm save or show errors
def edit_library_phone_number(selected_library, model)
  print "New phone number: >>"
  phone_number = gets.chomp
  saved = selected_library.update_attributes(phone_number: phone_number)
  record_save_result(saved, selected_library, model)
end

#======== EDIT STAFF MEMBER ==============================





#=========== SELECTION VALIDATION HELPER METHODS =========

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

# Confirms if the new record is saved, shows errors if not saved
#
# + saved: a boolean value representing if the record saved or not
# + new_object: an object representing the new record being created
# + model: a string representing the class being utilized
#
# Returns nil
def record_save_result(saved, new_object, model)
  if saved
    puts "\n#{model.split("_").join(" ").capitalize} created/updated:"
    puts new_object.record_display
  else
    puts "\n#{model.split("_").join(" ").capitalize} not created/updated!\n"
    new_object.errors.messages.each do |k,v|
      puts "#{k} #{v}\n"
    end
  end
end

binding.pry
main_menu
