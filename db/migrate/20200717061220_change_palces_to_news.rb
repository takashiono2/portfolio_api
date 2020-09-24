class ChangePalcesToNews < ActiveRecord::Migration[5.1]
  def change
    rename_table :places, :posts
  end
end
