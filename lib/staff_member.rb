
# Staff Member class for staff member objects
# + name: string with the name of the staff member
# + email: string with the email of the staff member
#
class StaffMember < ActiveRecord::Base

  validates :name, presence: true
  validates :email, presence: true, uniqueness: true

  has_and_belongs_to_many :library

  # Creates a string representing a Staff Members attributes
  #
  # Returns the created string
  def record_display
    "#{id}. Name: #{name}\n   Email: #{email}\n   Library: #{libraries_display}"
  end

  # Creates a string representing all libraries a staff member is a part of
  #
  # Returns the created string
  def libraries_display
    string = ""
    if self.library.empty?
      string += "None"
    else
      self.library.each do |l|
        string += "#{l.branch_name}\n         "
      end
    end
    string
  end

  # Creates a string representing a staff members libraries to select
  #
  # Returns a string of all libraries a staff member has
  def libraries_remove_display
    string = ""
    self.library.each do |l|
      string += "#{l.id}. #{l.branch_name}\n"
    end
    string
  end

  # Creates a string representing a Staff Member's attributes to be selected from
  #
  # Returns the created string
  def record_edit_display
    "1. Name: #{name}\n"\
    "2. Email: #{email}\n"\
    "3. Library: #{libraries_edit_display}"
  end

  #Creates a string of all libraries in a format for the library selection Menue
  #
  # returns the created string
  def libraries_edit_display
    string = ""
    self.library.each do |l|
      string += "#{l.branch_name}\n            "
    end
    string
  end

  # Creates an array of a staff member's library ids
  #
  # Returns the created array of library ids
  def libraries_id_array
    staff_member_library_ids = []
    self.library.each do |l|
      staff_member_library_ids << l.id
    end
    staff_member_library_ids
  end

end
