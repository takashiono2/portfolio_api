class RemoveMonthApplyingApprovalFromAttendances < ActiveRecord::Migration[5.1]
  def change
    remove_column :attendances, :month_applying_approval, :integer ,default: 0, null: false, limit: 1
  end
end
