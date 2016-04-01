
class Book < ActiveRecord::Base

  validates :title, presence: true
  validates :author, presence: true
  validates :isbn, exclusion: {in: [nil]}, uniqueness: true

  belongs_to :library
  belongs_to :patron

end
