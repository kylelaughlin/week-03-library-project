
class Book < ActiveRecord::Base

  validates :title, presence: true
  validates :author, presence: true
  validates :isbn,   presence: true, uniqueness: true

  belongs_to :library
  belongs_to :patron

  # Creates a string representing a books attributes
  #
  # Returns the created string
  def record_display
    "#{id}. Title: #{title}\n   Author: #{author}\n   ISBN: #{isbn}"
  end

  def record_edit_display
    "1. Title: #{title}\n"\
    "2. Author: #{author}\n"\
    "3. ISBN: #{isbn}"
  end
end
