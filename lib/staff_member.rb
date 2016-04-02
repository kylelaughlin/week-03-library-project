
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

  def libraries_display
    string = ""
    self.library.each do |l|
      string += "#{l.branch_name}\n         "
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

  def libraries_edit_display
    string = ""
    self.library.each do |l|
      string += "#{l.branch_name}\n            "
    end
    string
  end

end
