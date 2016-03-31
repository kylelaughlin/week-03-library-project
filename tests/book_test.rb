require_relative "test_helper.rb"
require_relative "../lib/book.rb"

class BookTest < Minitest::Test

  def test_create_under_normal_circumstances
    b = Book.new(title: "The Book of Ruby", author: "Ruby Rails", isbn: 1234567890123)
    refute_nil(b, "Should be an object updon initialization")
  end

  def test_title_validation
    b = Book.new(title: "The Book of Ruby", author: "Ruby Rails", isbn: 1234567890123)
    assert(b.valid?, "Should be valid book upon initialization")

    b.title = nil
    refute(b.valid?, "Should be invalid becuase title can't be nil")

    b.title = ""
    refute(b.valid?, "Should be invalid becuase title can't be blank")
  end

  def test_author_validation
    b = Book.new(title: "The Book of Ruby", author: "Ruby Rails", isbn: 1234567890123)
    assert(b.valid?, "Should be valid book upon initialization")

    b.author = nil
    refute(b.valid?, "Should be invalid becuase author can't be nil")

    b.author = ""
    refute(b.valid?, "Should be invalid becuase author can't be blank")
  end

  def test_isbn_validation
    b = Book.new(title: "The Book of Ruby", author: "Ruby Rails", isbn: 1234567890123)
    assert(b.valid?, "Should be valid book upon initialization")

    b.isbn = nil
    refute(b.valid?, "Should be invalid becuase isbn can't be nil")
  end
  
end
