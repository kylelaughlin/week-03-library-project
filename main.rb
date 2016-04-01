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

########################################################
#### LIBRARIES PATH ####################################
########################################################

# The libraries menu which allows users to select from:
#   Show all libraries
#   Create new library
#   Back to Main Menue
def libraries_menu
  selection = ""
  while selection != "back"
    puts "\n\n   --- Library Branch Main Menu ---\n\n"
    print "Please select one of the following options:\n\n"\
    "1. Show all libraries\n2. Add new library\n"\
    "Back. Go back to Main Menu\n\n >>"
    selection = gets.chomp.downcase
    selection = valid_selection(selection, ["1","2","back"])
    case selection
    when "1"
      libraries_index
    when "2"
      library_new
    when "back"
      #Go back to main menu
    else
      puts "Something broke = Libraries Menu Selection"
    end
  end
end

# Create a new library
# Prompts for library information - calls another method to save and validate
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
end

# Saves the new library and validates it
#
# + branch_name: a string representing the name of the new library branch
# + address: a string representing the address of the new library branch
# + phone_number: a string representing the phone number of the new library branch
#
# Returns nil
def save_new_library(branch_name, address, phone_number)
  new_library = Library.new(branch_name: branch_name,
  address: address,
  phone_number: phone_number)
  saved = new_library.save
  if saved
    puts "\nLibrary Created:"
    puts new_library.record_display
  else
    puts "\nLibrary not created!\n"
    new_library.errors.messages.each do |k,v|
      puts "#{k} #{v}\n"
    end
  end
end

# Displays all the libraries and attributes
# Can select between selecting a record to view/modify and going back to libraries menu
def libraries_index
  selection = ""
  while selection != "back"
    puts "\n\n   --- Library Branch Index ---\n\n"
    puts "All Library Locations:"
    Library.all.each do |l|
      puts l.record_display
    end

    print "\nPlease select one of the following options:\n1. Select a library\n"\
    "Back. Go back to Library Menu\n\n >>"
    selection = gets.chomp
    selection = valid_selection(selection,["1","back"])
    case selection
    when "1"
      print "\nPlease select a library from above.\n\n >>"
      selected_library_id = gets.chomp.to_i
      selected_library_id = valid_library(selected_library_id)
      selected_library_record(Library.find_by_id(selected_library_id))
    when "back"
      #back to the libraries menu
    end
  end
end

# Display The selected record and select an option to edit or go back
#
# + selected_lbrary: a library object which was selected by the user
#
# Returns nil
def selected_library_record(selected_library)
  selection = ""
  while selection != "back"
    puts "\n\n   --- #{selected_library.branch_name} ---\n\n"
    puts selected_library.record_display
    print "\nPlease select one of the following:\n\n1. Edit Record\n"\
    "Back. Go back to Show all libraries\n\n >>"
    selection = gets.chomp.downcase
    selection = valid_selection(selection, ["1","back"])
    case selection
    when "1"
      edit_library_record(selected_library)
    when "back"
      #go back to libraries index
    else
      puts "Something broke - selected library record selection"
    end
  end
end

# Select which library attribute to change
#
# + selected_lbrary: a library object which was selected by the user
#
# Returns nil
def edit_library_record(selected_library)
  selection = ""
  while selection != "back"
    puts "\n\n   --- Edit #{selected_library.branch_name} ---\n\n"
    print "What would you like to edit?\n"
    print "#{selected_library.record_edit_display}\nBack. Go back to Selected Library\n >>"
    selection = gets.chomp.downcase
    selection = valid_selection(selection, ["1","2","3","back"])
    case selection
    when "1"
      edit_library_branch_name(selected_library)
    when "2"
      edit_library_address(selected_library)
    when "3"
      edit_library_phone_number(selected_library)
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
#
def edit_library_branch_name(selected_library)
  print "New branch name: >>"
  branch_name = gets.chomp
  saved = selected_library.update_attributes(branch_name: branch_name)
  library_updated(saved, selected_library)
end

# Change the library address
#
# + selected_lbrary: a library object which was selected by the user
#
#
def edit_library_address(selected_library)
  print "New address: >>"
  address = gets.chomp
  saved = selected_library.update_attributes(address: address)
  library_updated(saved, selected_library)
end

# Change the library phone_number
#
# + selected_lbrary: a library object which was selected by the user
#
#
def edit_library_phone_number(selected_library)
  print "New phone number: >>"
  phone_number = gets.chomp
  saved = selected_library.update_attributes(phone_number: phone_number)
  library_updated(saved, selected_library)
end

# Checks if save is true or false, if false show errors with record
#
# + saved: a boolean representing whether the record saved to database or not
# + selected_lbrary: a library object which was selected by the user
#
#
def library_updated(saved, selected_library)
  if saved
    puts "\nLibrary Updated:"
    puts selected_library.record_display
  else
    puts "\nLibrary not updated!\n"
    selected_library.errors.messages.each do |k,v|
      puts "#{k} #{v}\n"
    end
  end
end

##########################################################
#### STAFF MEMBERS PATH ##################################
##########################################################

# Staff Members Menu: allows user to select between these options:
#   + Show all staff members
#   + Back to Main Menu
#
def staff_members_menu
  selection = ""
  while selection != "back"
    puts "\n\n   --- Staff Member Main Menu ---\n\n"
    print "Please select one of the following options:\n\n"\
    "1. Show all staff members\n"\
    "2. Add new staff member\n"\
    "Back. Go back to Main Menu\n\n >>"
    selection = gets.chomp.downcase
    selection = valid_selection(selection, ["1","2","back"])

    case selection
    when "1"
      staff_members_index
    when "2"
      staff_member_new
    when "back"
      #goes back to main menu
    else
      puts "Something broke - Staff Member Menu Selection"
    end
  end
end

# Gather for new staff member info
#
# Calls new_staff_member to save and validate record
def staff_member_new
  puts "\n\n   --- Add New Staff Member ---\n\n"
  print "Please fill in all requested information.\n\n"\
  "What is the new staff member's name?\n"\
  "\n >>"
  name = gets.chomp
  print "\nWhat is the new staff member's email?\n\n >>"
  email = gets.chomp
  save_new_staff_member(name, email)
end

# Saves record to table if valid, if not show errors
#
# + name: a string representing the new staff members name
# + email: a string representing the new staff memners email
#
#
def save_new_staff_member(name, email)
  new_staff_member = StaffMember.new(name: name, email: email)
  saved = new_staff_member.save
  if saved
    puts "\nStaff member created:"
    puts new_staff_member.record_display
    assign_to_library(new_staff_member)
  else
    puts "\nStaff member not created!\n"
    new_staff_member.errors.messages.each do |k,v|
      puts "#{k} #{v}\n"
    end
  end
end

# Assign a new staff member to a home library
#
# +new_staff_member: a staff member object
#
#
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

# Staff Member Index: Shows all staff members and their infomation to select
#
def staff_members_index
  selection = ""
  while selection != "back"
    puts "\n\n   --- Library Branch Index ---\n\n"
    puts "All Staff Members:"
    StaffMember.all.each do |sm|
      puts sm.record_display
    end

    print "\nPlease select one of the following options:\n 1.Select a staff member"\
    "\nBack. Go back to Staff Members Menu\n\n >>"
    selection = gets.chomp.downcase
    selection = valid_selection(selection,["1","back"])
    case selection
    when "1"
      print "\nPlease select a staff member from above.\n\n >>"
      selected_staff_member_id = gets.chomp.to_i
      selected_staff_member_id = valid_staff_member(selected_staff_member_id)
      selected_staff_member_record(StaffMember.find_by_id(selected_staff_member_id))
    when "back"
      #go back to staff members menu
    end
  end
end

def selected_staff_member_record(selected_staff_member)
  selection = ""
  while selection != "back"
    puts "\n\n   --- #{selected_staff_member.name} ---\n\n"
    puts selected_staff_member.record_display
    print "\nPlease select one of the following:\n\n1. Edit Record\n"\
    "Back. Go back to Show all libraries\n\n >>"
    selection = gets.chomp.downcase
    selection = valid_selection(selection, ["1","back"])
    case selection
    when "1"
      edit_staff_member_record(selected_staff_member)
    when "back"
      #go back to staff members index
    else
      puts "Something broke - selected staff member record selection"
    end
  end
end

# Select which staff member attribute to change
#
# + selected_staff_member: a StaffMember object which was selected by the user
#
# Returns nil
def edit_staff_member_record(selected_staff_member)
  selection = ""
  while selection != "back"
    puts "\n\n   --- Edit #{selected_staff_member.name} ---\n\n"
    print "What would you like to edit?\n"
    print "#{selected_staff_member.record_edit_display}\nBack. Go back to Selected Staff Member\n >>"
    selection = gets.chomp.downcase
    selection = valid_selection(selection, ["1","2","back"])
    case selection
    when "1"
      edit_staff_member_name(selected_staff_member)
    when "2"
      edit_staff_member_email(selected_staff_member)
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
#
#
def edit_staff_member_name(selected_staff_member)
  print "New name: >>"
  name = gets.chomp
  saved = selected_staff_member.update_attributes(name: name)
  staff_member_updated(saved, selected_staff_member)
end

# Change the staff member name
#
# + selected_staff_member: a StaffMember object which was selected by the user
#
#
def edit_staff_member_email(selected_staff_member)
  print "New name: >>"
  email = gets.chomp
  saved = selected_staff_member.update_attributes(email: email)
  staff_member_updated(saved, selected_staff_member)
end

# Checks if save is true or false, if false show errors with record
#
# + saved: a boolean representing whether the record saved to database or not
# + selected_staff_member: a StaffMember object which was selected by the user
#
#
def staff_member_updated(saved, selected_staff_member)
  if saved
    puts "\nStaff Member Updated:"
    puts selected_staff_member.record_display
  else
    puts "\nStaff member not updated!\n"
    selected_staff_member.errors.messages.each do |k,v|
      puts "#{k} #{v}\n"
    end
  end
end
####################################################
#### BOOKS PATH ####################################
####################################################

# Books Menu: allows user to select between these options:
#   + Show all books
#   + Back to Main Menu
#
def books_menu
  selection = ""
  while selection != "back"
    puts "\n\n   --- Books Main Menu ---\n\n"
    print "Please select one of the following options:\n\n"\
    "1.Show all books\n"\
    "2. Add new book\n"\
    "Back. Go back to Main Menu\n\n >>"
    selection = gets.chomp.to_i
    selection = valid_selection(selection, ["1","2","back"])

    case selection
    when "1"
      books_index
    when "2"
      book_new
    when "back"
      #Go back to main menu
    else
      puts "Something broke - Books Menu Selection"
    end
  end
end

# Gathers info for a new book record
#
# Calls save_new_book method to save and validate new book record
def book_new
  puts "\n\n   --- Add New Book ---\n\n"
  print "Please fill in all requested information.\n\n"\
  "What is the title of the book?\n\n >>"
  title = gets.chomp
  print "\nWho is the author of the book?\n\n >>"
  author = gets.chomp
  print "What is the ISBN of the book?\n\n >>"
  isbn = gets.chomp
  save_new_book(title, author, isbn)
end

# Saves new book record, if valid. if not valid shows errorrs
#
# + title: string representing the title of the new book
# + author: string representing the author of the new book
# + isbn: string representing the ISBN number of the new book
#
# Returns nil
def save_new_book(title, author, isbn)
  new_book = Book.new(title: title, author: author, isbn: isbn)
  saved = new_book.save
  if saved
    puts "\nBook created:"
    puts new_book.record_display
    assign_book_to_library(book)
  else
    puts "\nBook not created!\n"
    new_book.errors.messages.each do |k,v|
      puts "#{k} #{v}\n"
    end
  end
end

# Assigns a book to a library
#
# + book: a book object
#
# Calls back to books_menu
def assign_book_to_library(book)
  puts "\nPlease select one of the following libraries for the new book:"
  Library.all.each do |l|
    puts l.record_display
  end
  puts "\n >>"
  selection = gets.chomp.to_i
  while Library.find_by_id(selection).nil?
    print "That is not a valid selection. Please select from the libraries above.\n\n >>"
    selection = gets.chomp.to_i
  end
  book.library = Library.find_by_id(selection)
  puts "\n#{book.title} is now assigned to #{book.library.branch_name}"
end

# Books Index: Shows all books and their infomation select an option
#
def books_index
  selection = ""
  while selectino != "back"
    puts "\n\n   --- Books Index ---\n\n"
    puts "All Books:"
    Book.all.each do |b|
      puts b.record_display
    end

    print "\nPlease select one of the following options:\nBack. Go back to Books Menu\n\n >>"
    selection = gets.chomp.downcase
    selection = valid_selection(selection,["back"])
    case selection
    when "back"
      #go back to books menu
    end
  end
end

######################################################
#### PATRONS PATH ####################################
######################################################

# Patrons Menu: allows user to select between these options:
#   + Show all patrons
#   + Back to Main Menu
#
def patrons_menu
  selection = ""
  while selection != "back"
    puts "\n\n   --- Patrons Main Menu ---\n\n"
    print "Please select one of the following options:\n\n"\
    "1.Show all patrons\n"\
    "2. Add new patron\n"\
    "Back. Go back to Main Menu\n\n >>"
    selection = gets.chomp.to_i
    selection = valid_selection(selection, ["1","2","back"])

    case selection
    when "1"
      patrons_index
    when "2"
      patron_new
    when "back"
      #go back to main menu
    else
      puts "Something broke - Patrons Menu Selection"
    end
  end
end

# Gather information for a new patron record
#
# Calls save_new_patron to save a validate record
def patron_new
  puts "\n\n   --- Add New Patron ---\n\n"
  print "Please fill in all requested information.\n\n"\
  "What is the patron's name?\n\n >>"
  name = gets.chomp
  print "\nWhat is the patron's email?\n\n >>"
  email = gets.chomp
  save_new_patron(name, email)
end

# Save and validate the record, don't save and show errors if invalid record
#
# + name: string representing the name of the new patron
# + email: string representing the email of the new patron
#
def save_new_patron(name, email)
  new_patron = Patron.new(name: name, email: email)
  saved = new_patron.save
  if saved
    puts "\nPatron created:"
    puts new_patron.record_display
  else
    puts "\nPatron not created!\n"
    new_patron.errors.messages.each do |k,v|
      puts "#{k} #{v}\n"
    end
  end
end

# Patrons Index: Shows all patrons and their infomation Select option
#
def patrons_index
  selection = ""
  while selection != "book"
    puts "\n\n   --- Patrons Index ---\n\n"
    puts "All Patrons:"
    Patron.all.each do |pn|
      puts pn.record_display
    end

    print "\nPlease select one of the following options:\nBack. Go back to Books Menu\n\n >>"
    selection = gets.chomp.to_i
    selection = valid_selection(selection,["back"])
    case selection
    when "back"
      # go back to patrons menu
    end
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

def valid_library(selected_library_id)
  while Library.find_by_id(selected_library_id).nil?
    print "That is not a valid selection. Please select from the libraries above.\n\n >>"
    selected_library_id = gets.chomp.to_i
  end
  selected_library_id
end

def valid_staff_member(selected_staff_member_id)
  while StaffMember.find_by_id(selected_staff_member.id).nil?
    print "That is not a valid selection. Please select from the staff members above.\n\n >>"
    selected_staff_member_id = gets.chomp.to_i
  end
  selected_staff_member_id
end

binding.pry
main_menu
