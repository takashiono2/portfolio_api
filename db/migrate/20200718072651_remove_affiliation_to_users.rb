class RemoveAffiliationToUsers < ActiveRecord::Migration[5.1]
  def change
    remove_column :users, :affiliation, :string
  end
end
