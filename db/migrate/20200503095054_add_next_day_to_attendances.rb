class AddNextDayToAttendances < ActiveRecord::Migration[5.1]
  def change
    add_column :attendances, :next_day, :boolean, default: false, null: false
  end
end
