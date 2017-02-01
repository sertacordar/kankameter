class CreateEntries < ActiveRecord::Migration[5.0]
  def change
    create_table :entries do |t|
      t.integer :user_id
      t.datetime :entry_last_modified

      t.timestamps
    end
  end
end
