class CreatePlaces < ActiveRecord::Migration[5.1]
  def change
    create_table :places do |t|
      t.integer :place_number
      t.string :place_name

      t.timestamps
    end
  end
end
