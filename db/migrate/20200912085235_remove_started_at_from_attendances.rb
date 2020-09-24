class RemoveStartedAtFromAttendances < ActiveRecord::Migration[5.1]
  def change
    remove_column :attendances, :started_at, :datetime
    remove_column :attendances, :finished_at, :datetime
    remove_column :attendances, :schedule_overtime, :datetime
    remove_column :attendances, :work_content, :string
    remove_column :attendances, :applying_started_at, :datetime
    remove_column :attendances, :applying_finished_at, :datetime
    remove_column :attendances, :last_started_at, :datetime
    remove_column :attendances, :last_finished_at, :datetime
    remove_column :attendances, :edit_superior_id, :integer
    remove_column :users, :basic_work_time, :datatime
    remove_column :users, :work_time, :datatime
    remove_column :users, :designated_work_start_time, :datatime
    remove_column :users, :designated_work_end_time, :datatime
    remove_column :attendances, :approval, :integer
    remove_column :attendances, :next_day, :boolean
    remove_column :attendances, :edit_next_day, :boolean
    remove_column :attendances, :edit_applying_approval, :integer
    remove_column :users, :superior, :boolean
  end
end
