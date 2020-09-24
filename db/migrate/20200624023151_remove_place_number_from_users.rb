class RemovePlaceNumberFromUsers < ActiveRecord::Migration[5.1]
  def change
    remove_column :users, :place_number, :integer
    remove_column :users, :place_name, :string
  end
end