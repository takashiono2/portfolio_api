class AddSuperiorToUsers < ActiveRecord::Migration[5.1]
  def change
    add_column :users, :superior, :boolean, default: false, null: false
  end
end
