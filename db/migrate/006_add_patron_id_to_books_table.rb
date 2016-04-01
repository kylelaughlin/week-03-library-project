class AddPatronIdToBooksTable < Activerecord::Migration
  def change
    add_column :books, :patron_id:, :integer
  end
end
