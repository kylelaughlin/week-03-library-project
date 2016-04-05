require_relative "test_helper.rb"
require_relative "../lib/patron.rb"

class PatronTest < Minitest::Test

  def test_creation_under_normal_circumstances
    patron = Patron.new(name: "Frank", email: "email@Frank.com", books_checked_out_count: 0)
    refute_nil(patron, "Should be an object at initialization")
  end

  def test_name_validation
    patron = Patron.new(name: "Frank", email: "email@Frank.com", books_checked_out_count: 0)
    assert(patron.valid?, "Should be valid at initialization")

    patron.name = nil
    refute(patron.valid?, "Should be invalid as name can't be nil")

    patron.name = ""
    refute(patron.valid?, "Should be invalid as name can't be blank")
  end

  def test_email_validation
    patron = Patron.new(name: "Frank", email: "email@Frank.com", books_checked_out_count: 0)
    assert(patron.valid?, "Should be valid at initialization")

    patron.email = nil
    refute(patron.valid?, "Should be invalid as email can't be nil")

    patron.email = ""
    refute(patron.valid?, "Should be invalid as email can't be blank")
  end

  def test_record_display
    patron = Patron.new(name: "Frank", email: "email@Frank.com", books_checked_out_count: 0)
    patron.id = 2
    result = patron.record_display
    string = "2. Name: Frank\n   Email: email@Frank.com\n   Books: None\n"
    assert_equal(string, result)
  end

  def test_record_edit_display
    patron = Patron.new(name: "Frank", email: "email@Frank.com", books_checked_out_count: 0)
    result = patron.record_edit_display
    string = "1. Name: Frank\n2. Email: email@Frank.com\n3. Check in/out"
    assert_equal(string, result)
  end
end
