class AddBooksCheckedOutCountToPatronsTable < ActiveRecord::Migration
  def change
    add_column :patrons, :books_checked_out_count, :integer
  end
end
