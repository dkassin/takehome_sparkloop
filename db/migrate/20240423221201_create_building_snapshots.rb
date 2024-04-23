class CreateBuildingSnapshots < ActiveRecord::Migration[5.2]
  def change
    create_table :building_snapshots do |t|
      t.references :building, foreign_key: true
      t.date :snapshot_date
      t.integer :total_cost
      t.string :status
      
      t.timestamps
    end

    add_index :building_snapshots, :snapshot_date
    add_index :building_snapshots, :status
  end
end
