class CreateLibrariesStaffMembersTable < ActiveRecord::Migration
  def change
    create_table :libraries_staff_members, :id => false do |t|
      t.integer :library_id
      t.integer :staff_member_id
    end
  end
end
