class AddNameToSeFiles < ActiveRecord::Migration[5.0]
  def change
    add_column :se_files, :name, :string
  end
end
