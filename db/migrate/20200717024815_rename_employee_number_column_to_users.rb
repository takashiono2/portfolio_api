class RenameEmployeeNumberColumnToUsers < ActiveRecord::Migration[5.1]
  def change
    #add_column :users, :employee_number#, :intger#/kinataiA/db/migrate/20200320134915_add_employee_number_to_users.rbより
    #rename_column :users, :employee_number, :gender
    add_column :users, :gender, :integer#もともとなかったが追加修正
  end
end
