class AddApplyingApprovalToAttendances < ActiveRecord::Migration[5.1]
  def change
    add_column :attendances, :applying_approval, :integer ,default: 0, null: false, limit: 1
  end
end
