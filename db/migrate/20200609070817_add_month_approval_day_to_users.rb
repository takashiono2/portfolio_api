class AddMonthApprovalDayToUsers < ActiveRecord::Migration[5.1]
  def change
    add_column :users, :month_approval_day, :datetime
  end
end
