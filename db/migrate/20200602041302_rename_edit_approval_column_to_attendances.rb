class RenameEditApprovalColumnToAttendances < ActiveRecord::Migration[5.1]
  def change
    rename_column :attendances, :edit_approval, :edit_applying_approval
    rename_column :attendances, :applying_approval, :month_applying_approval
  end
end