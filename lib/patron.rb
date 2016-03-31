# Patron represents a person who utilizes a libraries services
# + name: the name of the patron (string)
# + email: the email of the patron (string)

class Patron < ActiveRecord::Base

  validates :name, presence: true
  validates :email, presence: true, uniqueness: true

end
