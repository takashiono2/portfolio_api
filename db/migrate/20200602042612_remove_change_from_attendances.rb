class RemoveChangeFromAttendances < ActiveRecord::Migration[5.1]
  def change
    remove_column :attendances, :change, :boolean, default: false, null: false
  end
end