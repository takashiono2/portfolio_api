class RenamePlaceNumberColumnToPosts < ActiveRecord::Migration[5.1]
  def change
    rename_column :posts, :place_number, :post_num
    rename_column :posts, :place_name, :post_title
    rename_column :posts, :job_status, :post_note
  end
end
