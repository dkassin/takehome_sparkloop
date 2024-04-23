class CreateElements < ActiveRecord::Migration[5.2]
  def change
    create_table :elements do |t|
      t.references :room, foreign_key: true
      t.string :element_type
      t.integer :cost
      
      t.timestamps
    end

    add_index :elements, :element_type
  end
end
