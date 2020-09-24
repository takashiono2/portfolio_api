class AddStatusToUsers < ActiveRecord::Migration[5.1]
  def change
    add_column :users, :status, :integer
    add_column :users, :registration_day, :date
  end
end
