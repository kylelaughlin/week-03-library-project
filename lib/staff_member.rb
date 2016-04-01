
# Staff Member class for staff member objects
# + name: string with the name of the staff member
# + email: string with the email of the staff member
#
class StaffMember < ActiveRecord::Base

  validates :name, presence: true
  validates :email, presence: true, uniqueness: true

  belongs_to :library

end
