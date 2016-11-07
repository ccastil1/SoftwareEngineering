class AddAttachmentAttachmentToSeFiles < ActiveRecord::Migration
  def self.up
    change_table :se_files do |t|
      t.attachment :attachment
    end
  end

  def self.down
    remove_attachment :se_files, :attachment
  end
end
