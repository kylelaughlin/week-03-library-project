require_relative "test_helper.rb"
require_relative "../lib/patron.rb"

class PatronTest < Minitest::Test

  def test_creation_under_normal_circumstances
    patron = Patron.new(name: "Frank", email: "email@Frank.com")
    refute_nil(patron, "Should be an object at initialization")
  end

  def test_name_validation
    patron = Patron.new(name: "Frank", email: "email@Frank.com")
    assert(patron.valid?, "Should be valid at initialization")

    patron.name = nil
    refute(patron.valid?, "Should be invalid as name can't be nil")

    patron.name = ""
    refute(patron.valid?, "Should be invalid as name can't be blank")
  end

  def test_email_validation
    patron = Patron.new(name: "Frank", email: "email@Frank.com")
    assert(patron.valid?, "Should be valid at initialization")

    patron.email = nil
    refute(patron.valid?, "Should be invalid as email can't be nil")

    patron.email = ""
    refute(patron.valid?, "Should be invalid as email can't be blank")
  end

end
