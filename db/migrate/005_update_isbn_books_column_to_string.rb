class UpdateIsbnBooksColumnToString < ActiveRecord::Migration
  def change
    change_column :books, :isbn, :string
  end
end
