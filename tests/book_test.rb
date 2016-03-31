require_relative "test_helper.rb"
require_relative "../lib/book.rb"

class BookTest < Minitest::Test

  def test_create_under_normal_circumstances
    b = Book.new(title: "The Book of Ruby", author: "Ruby Rails", isbn: 1234567890123)
    refute_nil(b, "Should be an object updon initialization")
  end

end
