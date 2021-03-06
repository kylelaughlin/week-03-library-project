require_relative "test_helper.rb"
require_relative "../lib/book.rb"

class BookTest < Minitest::Test

  def test_create_under_normal_circumstances
    b = Book.new(title: "The Book of Ruby", author: "Ruby Rails", isbn: "9234567890123")
    refute_nil(b, "Should be an object updon initialization")
  end

  def test_title_validation
    b = Book.new(title: "The Book of Ruby", author: "Ruby Rails", isbn: "9234567890123")
    assert(b.valid?, "Should be valid book upon initialization")

    b.title = nil
    refute(b.valid?, "Should be invalid becuase title can't be nil")

    b.title = ""
    refute(b.valid?, "Should be invalid becuase title can't be blank")
  end

  def test_author_validation
    b = Book.new(title: "The Book of Ruby", author: "Ruby Rails", isbn: "9234567890123")
    assert(b.valid?, "Should be valid book upon initialization")

    b.author = nil
    refute(b.valid?, "Should be invalid becuase author can't be nil")

    b.author = ""
    refute(b.valid?, "Should be invalid becuase author can't be blank")
  end

  def test_isbn_validation
    b = Book.new(title: "The Book of Ruby", author: "Ruby Rails", isbn: "9234567890123")
    assert(b.valid?, "Should be valid book upon initialization")

    b.isbn = nil
    refute(b.valid?, "Should be invalid becuase isbn can't be nil")
  end

  def test_record_display
    b = Book.new(title: "The Book of Ruby", author: "Ruby Rails", isbn: "9234567890123")
    b.id = 2
    result = b.record_display
    string = "2. Title: The Book of Ruby\n   Author: Ruby Rails\n   ISBN: 9234567890123\n"\
             "   Library: None\n   Checked Out: Available"
    assert_equal(string, result)
  end

  def test_record_edit_display
    b = Book.new(title: "The Book of Ruby", author: "Ruby Rails", isbn: "9234567890123")
    result = b.record_edit_display
    string = "1. Title: #{b.title}\n2. Author: #{b.author}\n3. ISBN: #{b.isbn}\n4. Library: None\n5. Check in/out"
    assert_equal(string, result)
  end

end
