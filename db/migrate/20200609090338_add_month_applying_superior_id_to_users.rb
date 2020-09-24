class AddMonthApplyingSuperiorIdToUsers < ActiveRecord::Migration[5.1]
  def change
    add_column :users, :month_applying_superior_id, :integer
  end
end
