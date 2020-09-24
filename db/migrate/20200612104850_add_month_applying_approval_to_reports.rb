class AddMonthApplyingApprovalToReports < ActiveRecord::Migration[5.1]
  def change
    add_column :reports, :month_applying_approval, :integer ,default: 0, null: false, limit: 1
  end
end
