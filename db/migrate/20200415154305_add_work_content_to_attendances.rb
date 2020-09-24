class AddWorkContentToAttendances < ActiveRecord::Migration[5.1]
  def change
    add_column :attendances, :work_content, :string
  end
end
