class AddImageOrigToPois < ActiveRecord::Migration
  def change
    add_column :pois, :image_orig, :string
  end
end
