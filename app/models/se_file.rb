class SeFile < ApplicationRecord
  validates :name, uniqueness: true
end
