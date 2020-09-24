class AddMonthApplyingSuperiorIdToAttendances < ActiveRecord::Migration[5.1]
  def change
    add_column :attendances, :month_applying_superior_id, :integer
  end
end
