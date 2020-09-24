class RenameSuperiorIdColumnToAttendances < ActiveRecord::Migration[5.1]
  def change
    rename_column :attendances, :superior_id, :attendance_class
    rename_column :attendances, :edit_applying_superior_id, :keiko_place
  end
end
