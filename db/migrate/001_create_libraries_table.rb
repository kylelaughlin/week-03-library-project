class CreateLibrariesTable < ActiveRecord::Migration
  def change
    create_table :libraries do |t|
      t.string :branch_name
      t.string :address
      t.string :phone_number
    end
  end
end
