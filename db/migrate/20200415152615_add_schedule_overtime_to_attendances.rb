class AddScheduleOvertimeToAttendances < ActiveRecord::Migration[5.1]
  def change
    add_column :attendances, :schedule_overtime, :datetime
  end
end
