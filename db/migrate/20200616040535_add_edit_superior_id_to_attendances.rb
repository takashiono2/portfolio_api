class AddEditSuperiorIdToAttendances < ActiveRecord::Migration[5.1]
  def change
    add_column :attendances, :edit_superior_id, :integer
  end
end
