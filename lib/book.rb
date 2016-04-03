
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
    string = "#{id}. Title: #{title}\n   Author: #{author}\n   ISBN: #{isbn}\n"
    if library.nil?
      string += "   Library: None"
    else
      string += "   Library: #{library.branch_name}"
    end
  end

  # Create a string representing a books attributes formatted for edit selection
  #
  # Returns the created string
  def record_edit_display
    string = "1. Title: #{title}\n"\
             "2. Author: #{author}\n"\
             "3. ISBN: #{isbn}\n"
    if library.nil?
      string += "4. Library: None"
    else
      string += "4. Library: #{library.branch_name}"
    end
  end


end
