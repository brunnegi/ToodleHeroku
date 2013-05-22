class CreatePois < ActiveRecord::Migration
  def change
    create_table :pois do |t|
      t.integer :trip_id
      t.string :name
      t.string :location
      t.text :description
      t.string :image
      t.string :voters

      t.timestamps
    end
  end
end
