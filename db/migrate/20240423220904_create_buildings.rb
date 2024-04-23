class CreateBuildings < ActiveRecord::Migration[5.2]
  def change
    create_table :buildings do |t|
      t.references :contractor, foreign_key: true
      t.string :name
      t.string :address
      t.integer :total_budget
      t.integer :total_cost
      t.string :status 
      t.date :start_date
      t.date :end_date

      t.timestamps
    end

    add_index :buildings, :total_budget
    add_index :buildings, :total_cost
    add_index :buildings, :status
  end
end
