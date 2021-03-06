# Library class represents a library object
#
# + branch_name: The name of a specific library location - string
# + address: The address of a specific library location - string
# + phone_number: The phone number of a specific library location - string
#

class Library < ActiveRecord::Base

  validates :branch_name, presence: true
  validates :address, presence: true
  validates :phone_number, presence: true

  has_many :books
  has_and_belongs_to_many :staff_members

  def record_display
    "#{id}. Branch Name: #{branch_name}\n"\
    "   Address: #{address}\n"\
    "   Phone Number: #{phone_number}"
  end

  def record_edit_display
    "1. Branch Name: #{branch_name}\n"\
    "2. Address: #{address}\n"\
    "3. Phone Number: #{phone_number}"
  end

end
