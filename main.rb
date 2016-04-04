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
    selection = valid_selection(selection,[1,2,3,4])
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
      puts "\n\n Closing Application\n\n"
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
  when "library"
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
    edit_library_record(selected_object, model)
  when "staff_member"
    edit_staff_member_record(selected_object, model)
  when "book"
    edit_book_record(selected_object, model)
  when "patron"
    edit_patron_record(selected_object, model)
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
    selection = valid_selection(selection, [1,2,3])
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

# Select which staff member attribute to change
#
# + selected_staff_member: a StaffMember object which was selected by the user
# + model: a string representing the object type being utilized
#
# Returns nil
def edit_staff_member_record(selected_staff_member, model)
  selection = ""
  while selection != "back"
    puts "\n\n   --- Edit #{selected_staff_member.name} ---\n\n"
    print "What would you like to edit?\n"
    print "#{selected_staff_member.record_edit_display}\nBack. Go back to Selected Staff Member\n >>"
    selection = gets.chomp.downcase
    selection = valid_selection(selection, [1,2,3])
    case selection
    when "1"
      edit_staff_member_name(selected_staff_member, model)
    when "2"
      edit_staff_member_email(selected_staff_member, model)
    when "3"
      edit_staff_member_library(selected_staff_member, model)
    when "back"
      #go back to selected_library_record
    else
      puts "Something broke - Library edit record selection"
    end
  end
end

# Change the staff member name
#
# + selected_staff_member: a StaffMember object which was selected by the user
# + model: a string representing the object type being utilized
#
# Calls method
def edit_staff_member_name(selected_staff_member, model)
  print "New name: >>"
  name = gets.chomp
  saved = selected_staff_member.update_attributes(name: name)
  record_save_result(saved, selected_staff_member, model)
end

# Change the staff member name
#
# + selected_staff_member: a StaffMember object which was selected by the user
# + model: a string representing the object type being utilized
# Calls method
def edit_staff_member_email(selected_staff_member, model)
  print "New name: >>"
  email = gets.chomp
  saved = selected_staff_member.update_attributes(email: email)
  record_save_result(saved, selected_staff_member, model)
end

# Menu to select if a user wants to add or remove a library from staff member
#
# + selected_staff_member: a StaffMember object in which a user selected
# + model: a string representing the object type being utilized
#
# Returns nil
def edit_staff_member_library(selected_staff_member, model)
  selection = ""
  while selection != "back"
    print "\n1. Add #{selected_staff_member.name} to another library\n"\
    "2. Remove #{selected_staff_member.name} from a library\n"\
    "Back. Go back to the Staff Member menu\n\n >>"
    selection = gets.chomp.downcase
    selection = valid_selection(selection,[1,2])
    case selection
    when "1"
      add_library_to_staff_member(selected_staff_member)
    when "2"
      select_remove_library_from_staff_member(selected_staff_member)
    when "back"
      #go back to staff member menu
    else
      puts "something broke - edit staff member library menu"
    end
  end
end

# Change the staff members library
#
# + selected_staff_member: a StaffMember object as selected by the user
#
# Calls method
def add_library_to_staff_member(selected_staff_member)
  if Library.where.not(id: selected_staff_member.libraries_id_array).empty?
    puts "#{selected_staff_member.name} is already associated with all libraries."
  else
    puts "Available libraries:"
    Library.where.not(id: selected_staff_member.libraries_id_array).each do |l|
      puts l.record_display
    end
    #Call method to select a Library
    new_library = select_new_library(selected_staff_member)
    #Create association between the selected library and the selected Staff Member
    selected_staff_member.library << new_library
    #Save record and send to confirmation method
    saved = selected_staff_member.save
    record_save_result(saved, selected_staff_member,"staff_member")
  end
end

# Select a library to add to staff member's libraries_id_array
#
# +selected_staff_member: a StaffMember object as selected by the user
#
# Returns a Library object
def select_new_library(selected_staff_member)
  print "Select new library.\n\n >>"
  new_library_id = gets.chomp.to_i
  new_library_id = valid_object_selection(new_library_id,
          Library.where.not(id: selected_staff_member.libraries_id_array),"library")
  Library.find_by_id(new_library_id)
end

# Select a library to remove the assocation with the staff member
#
# + selected_staff_member: a StaffMember object as selected by the user
#
# Returns nil
def select_remove_library_from_staff_member(selected_staff_member)
  if selected_staff_member.libraries_id_array.empty?
    puts "#{selected_staff_member.name} does not belong to any libraries"
  else
    puts "Libraries:\n"
    puts selected_staff_member.libraries_remove_display
    print "\nSelect a library from above to remove\n\n >>"
    library_id = gets.chomp.to_i
    library_id = valid_object_selection(library_id,selected_staff_member.library, "library")
    selected_library = Library.find_by_id(library_id)
    remove_library(selected_staff_member,selected_library)
  end
end

# Deletes the association between the selected staff member and the selected library_id
#
# + selected_staff_member: a StaffMember object as selected by the user
# + selected_library: a Library object as selected by the user
#
# Returns nil
def remove_library(selected_staff_member,selected_library)
  selected_staff_member.library.delete(selected_library)
  puts "\nLibrary removed\n"
end

#=========== EDIT BOOK =========================

# Edit book menu options
#
# + selected_book: a Book object as selected by the user
# + model: a string representing the object type being utilized
#
# Returns nil
def edit_book_record(selected_book, model)
  selection = ""
  while selection != "back"
    puts "\n\n   --- Edit #{selected_book.title} ---\n\n"
    print "What would you like to edit?\n"
    print "#{selected_book.record_edit_display}\nBack. Go back to selected book\n >>"
    selection = gets.chomp.downcase
    selection = valid_selection(selection, [1,2,3,4,5])
    case selection
    when "1"
      edit_book_title(selected_book, model)
    when "2"
      edit_book_author(selected_book, model)
    when "3"
      edit_book_isbn(selected_book, model)
    when "4"
      edit_book_library(selected_book, model)
    when "5"
      check_in_or_out_book(selected_book, model)
    when "back"
      #go back to selected_book_record
    else
      puts "Something broke - book edit record selection"
    end
  end
end

# Change the book title
#
# + selected_book: a Book object which was selected by the user
# + model: a string representing the object type being utilized
#
# Calls method to confirm save or show errors
def edit_book_title(selected_book, model)
  print "New title: >>"
  title = gets.chomp
  saved = selected_book.update_attributes(title: title)
  record_save_result(saved, selected_book, model)
end

# Change the book author
#
# + selected_book: a Book object which was selected by the user
# + model: a string representing the object type being utilized
#
# Calls method to confirm save or show errors
def edit_book_author(selected_book, model)
  print "New author: >>"
  author = gets.chomp
  saved = selected_book.update_attributes(author: author)
  record_save_result(saved, selected_book, model)
end

# Change the home library of the book_updated
#
# + selected_book: a Book object which was selected by the user
# + model: a string representing the object type being utilized
#
# Calls method to confirm save or show errors
def edit_book_library(selected_book, model)
  puts "\n\nAvailable libraries:"
  Library.all.each do |l|
    puts l.record_display
  end
  print "\nSelect new library.\n\n >>"
  new_library_id = gets.chomp.to_i
  new_library_id = valid_object_selection(new_library_id,Library.all,"library")
  selected_book.library = Library.find_by_id(new_library_id)
  saved = selected_book.save
  record_save_result(saved, selected_book, model)
end

def check_in_or_out_book(selected_book, model)
  if selected_book.patron_id.nil?
    check_out(selected_book, nil, model)
  else
    check_in_book(selected_book)
  end
end

#=========== Edit Patron ================================


# Edit Patron record options menu
#
# + selected_patron: a Patron object as selected by the user
# + model: a string representing the object type as selecrted by the user
#
# Returns nil
def edit_patron_record(selected_patron, model)
  selection = ""
  while selection != "back"
    puts "\n\n   --- Edit #{selected_patron.name} ---\n\n"
    print "What would you like to edit?\n"
    print "#{selected_patron.record_edit_display}\nBack. Go back to selected patron\n >>"
    selection = gets.chomp.downcase
    selection = valid_selection(selection, [1,2,3])
    case selection
    when "1"
      edit_patron_name(selected_patron, model)
    when "2"
      edit_patron_email(selected_patron, model)
    when "3"
      check_in_or_out_patron(selected_patron, model)
    when "back"
      #go back to selected_patron_record
    else
      puts "Something broke - patron edit record selection"
    end
  end
end

# Change the patron's name
#
# + selected_patron: a Patron object which was selected by the user
# + model: a string representing the object type as selected by the user
#
# Calls method
def edit_patron_name(selected_patron, model)
  print "New name: >>"
  name = gets.chomp
  saved = selected_patron.update_attributes(name: name)
  record_save_result(saved, selected_patron, model)
end

# Change the patron's email
#
# + selected_patron: a Patron object which was selected by the user
# + model: a string representing the object type as selected by the user
#
# Calls method
def edit_patron_email(selected_patron, model)
  print "New email: >>"
  email = gets.chomp
  saved = selected_patron.update_attributes(email: email)
  record_save_result(saved, selected_patron, model)
end

# Checks if save is true or false, if false show errors with record
#
# + saved: a boolean representing whether the record saved to database or not
# + selected_patron: a Patron object which was selected by the user
#
# Returns nil
def patron_updated(saved, selected_patron)
  if saved
    puts "\nPatron Updated:"
    puts selected_patron.record_display
  else
    puts "\nPatron not updated!\n"
    selected_patron.errors.messages.each do |k,v|
      puts "#{k} #{v}\n"
    end
  end
end

def check_in_or_out_patron(selected_patron, model)

end

# Select if patron wants to check out a book or return a book
#
# +selected_patron: a Patron object as selected by the user
#
# Returns nil
def check_in_or_out_patron(selected_patron, model)
  print "\nWould #{selected_patron.name} like to:\n1. Check out a book\n"\
       "2. Return a book\nBack. Go back to #{selected_patron.name} options\n\n >>"
  selection = gets.chomp.downcase
  selection = valid_selection(selection,[1,2])
  case selection
  when "1"
    check_out(nil, selected_patron, model)
  when "2"
    check_in_patron(selected_patron)
  when "back"
    #Go back to selected patron record menu
  else
    puts "Something broke - check-in-out-book-from-patron selection"
  end
end

#=========== Check in and out ===========================

# Check for books to be returned form the patron
#
# + selected_patron: a Patron object as selected by the user
#
# Returns nil
def check_in_patron(selected_patron)
  if selected_patron.checked_out_books_select.empty?
    puts "#{selected_patron.name} does not have any books to return"
  else
    check_in_patron_associations(selected_patron)
  end
end

# Remove association between book and patron for a check in
#
# + selected_patron: a Patron object as selected by the user
#
# Returns nil
def check_in_patron_associations(selected_patron)
  selected_book = select_book_for_patron_to_checkin(selected_patron)
  selected_book.patron_id = nil
  saved = selected_book.save
  if saved
    selected_patron.books_checked_out_count -= 1
    selected_patron.save
    puts "#{selected_book.title} is checked in.\n"
  else
    puts "\n#{selected_book.title} not checked in!\n"
    selected_book.errors.messages.each do |k,v|
      puts "#{k} #{v}\n"
    end
  end
end

# Select a Book object belonging to the selected_patron to return
#
# + selected_patron: a Patron object as selected by the user
#
# Returns a Book object to be checked in
def select_book_for_patron_to_checkin(selected_patron)
  puts "#{selected_patron.name}: Books Checked Out-"
  puts selected_patron.checked_out_books_select
  print "\n Please select a book from above to return\n\n >>"
  selected_book_id = gets.chomp.to_i
  selected_book_id = valid_object_selection(selected_book_id, Book.where(patron_id: selected_patron.id), "book")
  Book.find_by_id(selected_book_id)
end

# Confirm that the user wants to check in a book
#
# + selected_book: a Book object as selected by the user
#
# Returns nil
def check_in_book(selected_book)
  print "\n#{selected_book.title} is checked out by #{selected_book.patron.name}.\n"\
       "Would you like to check it in? (Y\\N)\n\n >>"
  selection = gets.chomp.downcase
  selection = valid_string_selection(selection,["y","yes","n","no"])
  case selection
  when "y","yes"
    check_in_book_association(selected_book)
    puts "\n#{selected_book.title} is not checked in.\n\n"
  when "n","no","back","exit"
    #Go back to edit book
  else
    puts "something strange happened - check_in_book"
  end
end

# Modify relationships between books and patron_id
#
# + selected_book: a Book object as selected by the user
#
# Returns true or false depending on if the record saved
def check_in_book_association(selected_book)
  selected_patron = Patron.find_by_id(selected_book.patron_id)
  selected_patron.books_checked_out_count -= 1
  selected_patron.save
  selected_book.patron_id = nil
  selected_book.save
end

# Check out a book with a valid book and patron_id
#
# + selected_book: a Book object
# + selected_patron: a Patron object
# + model: a string representing the model path taken by user
#
# Returns nil
def check_out(selected_book, selected_patron, model)
  if selected_book.nil?
    selected_book = select_book_to_check_out(model)
  end
  if selected_patron.nil?
    selected_patron = select_patron_to_check_out(model)
  end
  check_out_associations(selected_book, selected_patron)
end

# Creates the asscoations between the book and patorn objects
#
# + selected_book: a Book object
# + selected_patron: a Patron object
#
# Returns nil
def check_out_associations(selected_book, selected_patron)
  selected_book.patron = selected_patron
  saved = selected_book.save
  if saved
    selected_patron.books_checked_out_count += 1
    selected_patron.save
    binding.pry
    puts "#{selected_book.title} is now checked out by #{selected_patron.name}.\n"
  else
    puts "\n#{selected_book.title} not checked out!\n"
    selected_book.errors.messages.each do |k,v|
      puts "#{k} #{v}\n"
    end
  end
end

# Select a book to be checked out
#
# + model: a string representing the data type of the path taken from user
#
# Returns a Book object to be checked out
def select_book_to_check_out(model)
  #display available books
  puts "\n\nAvailable books:"
  Book.where(patron_id: nil).each do |b|
    puts b.record_display
  end
  print "\nPlease select a book from above to check out\n\n >>"
  selected_book_id = gets.chomp.to_i
  selected_book_id = valid_object_selection(selected_book_id,Book.where(patron_id: nil), "book")
  Book.find_by_id(selected_book_id)
end

# Select a valid patron to check out a book
#
# + model: a string representing the data type of the path taken from user
#
# Returns a valid Patron object
def select_patron_to_check_out(model)
  acceptable = false
  while !acceptable
    puts "Select a patron:\n\n"
    Patron.all.each do |patron|
      puts patron.record_display
    end
    print "\nPlease select a patron above to check out this book\n\n >>"
    selected_patron_id = gets.chomp.to_i
    selected_patron_id = valid_object_selection(selected_patron_id,Patron.all, "patron")
    patron = Patron.find_by_id(selected_patron_id)
    if patron.books_checked_out_count < 3
      acceptable = true
    else
      puts "\n#{patron.name} has three books already checked out.\n"\
           "Must return a book before checking out another.\n\n"
    end
  end
  patron
end

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

# Checks to see if a users selection is within the acceptable choices
#
# + selection: an integer representing the users selection
# + acceptable_choices: an array of choices that are valid given the options provided
#
# Returns a string representing the valid user selection
def valid_string_selection(selection, acceptable_choices)
  while !(acceptable_choices.include? selection) && selection != "back" && selection != "exit"
    print "That is an invalid selection please select an option from above.\n\n >>"
    selection = gets.chomp
  end
  selection
end

# Re-prompt user for a new object id selection if object is not in the acceptable choices
#
# +object_id: an integer representing the id for a user selected object
# +acceptable_choices: an array of objects that the user can select from
#
# Returns an integer representing the id for the object the user selecrted
def valid_object_selection(object_id,acceptable_choices, model)
  while !acceptable_choices.include? model.camelize.constantize.find_by_id(object_id)
    print "That was an invalid selection. Please select form the list above.\n\n >>"
    object_id = gets.chomp.to_i
  end
  object_id
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

main_menu
