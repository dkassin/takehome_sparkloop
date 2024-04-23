class CreateRoomSnapshots < ActiveRecord::Migration[5.2]
  def change
    create_table :room_snapshots do |t|
      t.references :room, foreign_key: true
      t.date :snapshot_date
      t.integer :total_cost
      t.string :status
      
      t.timestamps
    end

    add_index :room_snapshots, :snapshot_date
    add_index :room_snapshots, :status
  end
end
