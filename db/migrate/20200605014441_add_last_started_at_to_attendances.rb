class AddLastStartedAtToAttendances < ActiveRecord::Migration[5.1]
  def change
    add_column :attendances, :last_started_at, :datetime
    add_column :attendances, :last_finished_at, :datetime
  end
end
