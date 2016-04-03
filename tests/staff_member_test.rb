require_relative 'test_helper.rb'
require_relative '../lib/staff_member.rb'

class StaffMemberTest < Minitest::Test

  def test_create_object_under_normal_circumstances
    sm = StaffMember.new(name: "test", email: "email@test.com")
    refute_nil(sm, "Should be an object at initialization")
  end

  def test_name_valid
    sm = StaffMember.new(name: "test", email: "email@test.com")
    assert(sm.valid?, "Should be a valid object at initialization")

    sm.name = nil
    refute(sm.valid?, "Should be an invalid object as name can't be nil")

    sm.name = ""
    refute(sm.valid?, "Should be an invalid object as name can't be blank")
  end

  def test_email_valid
    sm = StaffMember.new(name: "test", email: "email@test.com")
    assert(sm.valid?, "Should be a valid object at initialization")

    sm.email = nil
    refute(sm.valid?, "Should be an invalid object as email can't be nil")

    sm.name = ""
    refute(sm.valid?, "Should be an invalid object as email can't be blank")
  end

  def test_record_display
    sm = StaffMember.new(name: "test", email: "email@test.com")
    sm.id = 2
    result = sm.record_display
    string = "2. Name: test\n   Email: email@test.com\n   Library: None"
    assert_equal(string, result)
  end

  def test_libraries_display
    sm = StaffMember.new(name: "test", email: "email@test.com")
    result = sm.libraries_display
    string = "None"
    assert_equal(string, result)
  end
end
