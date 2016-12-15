class FileNode < ApplicationRecord
  has_and_belongs_to_many :se_files
end
