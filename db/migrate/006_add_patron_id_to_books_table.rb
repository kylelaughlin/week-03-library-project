class AddPatronIdToBooksTable < ActiveRecord::Migration
  def change
    add_column :books, :patron_id, :integer
  end
end
