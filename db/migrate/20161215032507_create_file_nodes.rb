class CreateFileNodes < ActiveRecord::Migration[5.0]
  def change
    create_table :file_nodes do |t|
      t.string :name
      t.timestamps
    end
  end
end
