class SeFile < ApplicationRecord
  validates :name, uniqueness: true, presence: true
  has_attached_file :attachment
  do_not_validate_attachment_file_type :attachment
end
