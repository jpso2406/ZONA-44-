class TamanoPizza < ApplicationRecord
  belongs_to :pizza
  
  validates :tamano, presence: true, 
                    inclusion: { in: ['personal', 'small', 'medium', 'large'] }
  validates :precio, presence: true, numericality: { greater_than: 0 }
  validates :tamano_cm, presence: true
  validates :tamano, uniqueness: { scope: :pizza_id }
  
  scope :por_tamano, ->(tamano) { where(tamano: tamano) }
end
