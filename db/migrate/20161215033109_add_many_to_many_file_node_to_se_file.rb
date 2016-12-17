class AddManyToManyFileNodeToSeFile < ActiveRecord::Migration[5.0]
  def change
    create_table :file_nodes_se_files, id: false do |t|
      t.belongs_to :file_node, index: true
      t.belongs_to :se_file, index: true
    end
  end
end
