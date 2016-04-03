require_relative 'test_helper.rb'
require_relative '../lib/library.rb'

class LibraryTest < Minitest::Test

  def test_create_library_under_normal_circumstances
    l = Library.new(branch_name: "East Library", address: "123 East Drive", phone_number: "555-456-7654")
    refute_nil(l, "Should be an object upon initialization")
  end

  def test_branch_name_validation
    l = Library.new(branch_name: "East Library", address: "123 East Drive", phone_number: "555-456-7654")
    assert(l.valid?, "Should be valid object upon initialization")

    l.branch_name = nil
    refute(l.valid?, "Should not be valid as branch_name can't be nil")

    l.branch_name = ""
    refute(l.valid?, "Should not be valid as branch_name can't be empty")
  end

  def test_address_validation
    l = Library.new(branch_name: "East Library", address: "123 East Drive", phone_number: "555-456-7654")
    assert(l.valid?, "Should be valid object upon initialization")

    l.address = nil
    refute(l.valid?, "Should not be valid as address can't be nil")

    l.address = ""
    refute(l.valid?, "Should not be valid as address can't be empty")
  end

  def test_phone_number_validation
    l = Library.new(branch_name: "East Library", address: "123 East Drive", phone_number: "555-456-7654")
    assert(l.valid?, "Should be valid object upon initialization")

    l.phone_number = nil
    refute(l.valid?, "Should not be valid as phone_number can't be nil")

    l.phone_number = ""
    refute(l.valid?, "Should not be valid as phone_number can't be empty")
  end

  def test_record_display
    l = Library.new(branch_name: "East Library", address: "123 East Drive", phone_number: "555-456-7654")
    l.id = 2
    result = l.record_display
    string = "2. Branch Name: East Library\n   Address: 123 East Drive\n   Phone Number: 555-456-7654"
    assert_equal(string, result)
  end

  def test_record_edit_display
    l = Library.new(branch_name: "East Library", address: "123 East Drive", phone_number: "555-456-7654")
    result = l.record_edit_display
    string = "1. Branch Name: East Library\n2. Address: 123 East Drive\n3. Phone Number: 555-456-7654"
    assert_equal(string, result)
  end

end
