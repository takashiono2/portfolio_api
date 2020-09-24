class ChangeDatatypeEmployeeNumberOfUsers < ActiveRecord::Migration[5.1]
  #def change
    #change_column :users, :employee_number, :integer
  #end
  
  # def up#テストの時
  #     change_column :users, :employee_number, :integer
  # end

  # def down#テストの時
  #     change_column :users, :employee_number, :string
  # end
  
  def change#本番の時
    #change_column :users, :employee_number, 'integer USING CAST(employee_number AS integer)'
  end
end