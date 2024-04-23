class CreateRooms < ActiveRecord::Migration[5.2]
  def change
    create_table :rooms do |t|
      t.references :building, foreign_key: true
      t.string :room_type
      t.integer :total_budget
      t.integer :total_cost
      t.string :status 
      t.date :start_date
      t.date :end_date
      
      t.timestamps
    end

    add_index :rooms, :total_budget
    add_index :rooms, :total_cost
    add_index :rooms, :status
  end
end
