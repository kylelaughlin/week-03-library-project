# Patron represents a person who utilizes a libraries services
# + name: the name of the patron (string)
# + email: the email of the patron (string)

class Patron < ActiveRecord::Base

  validates :name, presence: true
  validates :email, presence: true, uniqueness: true

  has_many :books

  # Creates a string representing a books attributes
  #
  # Returns the created string
  def record_display
    "#{pn.id}. Name: #{pn.name}\n   Email: #{pn.email}"
  end

end
