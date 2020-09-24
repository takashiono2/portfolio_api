class AddJobIdToPlaces < ActiveRecord::Migration[5.1]
  def change
    add_column :places, :job_status, :string
  end
end
