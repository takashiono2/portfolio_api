class AddImageToAttendances < ActiveRecord::Migration[5.1]
  def change
    add_column :attendances, :image, :string
  end
end
