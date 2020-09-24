class RemoveMonthApplyingSuperiorIdFromAttendances < ActiveRecord::Migration[5.1]
  def change
    remove_column :attendances, :month_applying_superior_id, :integer
  end
end
