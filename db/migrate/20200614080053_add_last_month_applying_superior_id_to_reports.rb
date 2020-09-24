class AddLastMonthApplyingSuperiorIdToReports < ActiveRecord::Migration[5.1]
  def change
    add_column :reports, :last_month_applying_superior_id, :integer
  end
end
