class AddMonthApplyingSuperiorIdToReports < ActiveRecord::Migration[5.1]
  def change
    add_column :reports, :month_applying_superior_id, :integer
  end
end
