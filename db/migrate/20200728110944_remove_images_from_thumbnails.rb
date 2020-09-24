class RemoveImagesFromThumbnails < ActiveRecord::Migration[5.1]
  #def change
    #remove_column :thumbnails, :images, :string
  #end
    
  def up
    remove_column :thumbnails, :images
  end

  def down
    add_column :thumbnails, :images, :string
  end
end
