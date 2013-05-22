class CreateTrips < ActiveRecord::Migration
  def change
    create_table :trips do |t|
      t.string :name
      t.integer :owner
      t.timestamp :start_date
      t.timestamp :end_date
      t.text :details
      t.string :participants
      t.string :poi
      t.integer :dpoi

      t.timestamps
    end
  end
end
