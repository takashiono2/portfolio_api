class AddPlaceNumberToUsers < ActiveRecord::Migration[5.1]
  def change
    add_column :users, :place_number, :integer
  end
end
