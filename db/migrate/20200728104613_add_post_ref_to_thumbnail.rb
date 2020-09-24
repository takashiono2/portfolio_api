class AddPostRefToThumbnail < ActiveRecord::Migration[5.1]
  def change
    add_column :thumbnails, :images, :string
  end
end
