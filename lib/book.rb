
class Book < ActiveRecord::Base

  validates :title, presence: true
  validates :author, presence: true
  validates :isbn, exclusion: {in: [nil]}, uniqueness: true

  belongs_to :library
  belongs_to :patron

  # Creates a string representing a books attributes
  #
  # Returns the created string
  def record_display
    "#{id}. Title: #{title}\n   Author: #{author}\n   ISBN: #{isbn}"
  end

end
