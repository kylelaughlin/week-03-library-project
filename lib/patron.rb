# Patron represents a person who utilizes a libraries services
# + name: the name of the patron (string)
# + email: the email of the patron (string)

class Patron < ActiveRecord::Base

  validates :name, presence: true
  validates :email, presence: true, uniqueness: true
  validates :books_checked_out_count, numericality: {less_than_or_equal_to: 3}

  has_many :books

  # Creates a string representing a books attributes
  #
  # Returns the created string
  def record_display
    "#{id}. Name: #{name}\n   Email: #{email}"
  end

end
