class RenameApplyingSuperiorIdColumnToAttendances < ActiveRecord::Migration[5.1]
  def change
    rename_column :attendances, :applying_superior_id, :applying
  end
end