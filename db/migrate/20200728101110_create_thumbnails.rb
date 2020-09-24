class CreateThumbnails < ActiveRecord::Migration[5.1]
  def change
    create_table :thumbnails do |t|
      t.string :image

      t.timestamps
      t.references :post, foreign_key: true
    end
  end
end
