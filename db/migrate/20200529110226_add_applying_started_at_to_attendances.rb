class AddApplyingStartedAtToAttendances < ActiveRecord::Migration[5.1]
  def change
    add_column :attendances, :applying_started_at, :datetime
    add_column :attendances, :applying_finished_at, :datetime
    add_column :attendances, :edit_approval, :integer ,default: 0, null: false, limit: 1
  end
end