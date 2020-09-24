class AddApplyingSuperiorId < ActiveRecord::Migration[5.1]
  def change
    add_column :attendances, :applying_superior_id, :integer
  end
end
