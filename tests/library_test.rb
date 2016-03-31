require_relative 'test_helper.rb'
require_relative '../lib/library.rb'

class LibraryTest < Minitest::Test

  def test_create_library_under_normal_circumstances
    l = Library.new(branch_name: "East Library", address: "123 East Drive", phone_number: "555-456-7654")
    refute_nil(l, "Should be a valid object upon initialization")
  end
  
end
