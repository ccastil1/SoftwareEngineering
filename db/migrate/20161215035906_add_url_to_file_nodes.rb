class AddUrlToFileNodes < ActiveRecord::Migration[5.0]
  def change
    add_column :file_nodes, :url, :string
  end
end
