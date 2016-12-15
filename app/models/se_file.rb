class SeFile < ApplicationRecord
  validates :name, uniqueness: true, presence: true
  has_and_belongs_to_many :file_nodes
  has_attached_file :attachment
  do_not_validate_attachment_file_type :attachment
end
