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

end
