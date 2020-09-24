class RemoveMonthApplyingSuperiorIdFromUsers < ActiveRecord::Migration[5.1]
  def change
    remove_column :users, :month_applying_superior_id, :integer
    remove_column :users, :month_approval_day, :datetime
  end
end