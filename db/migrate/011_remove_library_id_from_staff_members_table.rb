class RemoveLibraryIdFromStaffMembersTable < ActiveRecord::Migration
  def change
    remove_column :staff_members, :library_id, :integer
  end
end
