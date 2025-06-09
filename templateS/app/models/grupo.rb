class Grupo < ApplicationRecord
  has_many :productos, dependent: :destroy
  has_one_attached :foto
end
