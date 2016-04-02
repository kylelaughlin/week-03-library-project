# Patron represents a person who utilizes a libraries services
# + name: the name of the patron (string)
# + email: the email of the patron (string)

class Patron < ActiveRecord::Base

  validates :name, presence: true
  validates :email, presence: true, uniqueness: true
  validates :books_checked_out_count, numericality: {less_than_or_equal_to: 3, message: "Patron can not have more than three books checked out at any given time."}

  has_many :books

  # Creates a string representing a patron attributes
  #
  # Returns the created string
  def record_display
    "#{id}. Name: #{name}\n   Email: #{email}"
  end

  # Creates a string representing the patron attibutes to edit
  def record_edit_display
    "1. Name: #{name}\n2. Email: #{email}\n"
  end

end
