class AddAffiliationToUsers < ActiveRecord::Migration[5.1]
  def change
    add_column :users, :affiliation, :integer
    add_column :users, :department, :integer
  end
end
