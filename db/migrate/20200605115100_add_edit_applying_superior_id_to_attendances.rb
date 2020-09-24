class AddEditApplyingSuperiorIdToAttendances < ActiveRecord::Migration[5.1]
  def change
    add_column :attendances, :edit_applying_superior_id, :integer
  end
end
