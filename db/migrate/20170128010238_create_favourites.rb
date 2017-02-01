class CreateFavourites < ActiveRecord::Migration[5.0]
  def change
    create_table :favourites do |t|
      t.integer :entry_id
      t.integer :faved_by

      t.timestamps
    end
  end
end
