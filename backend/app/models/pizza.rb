class Pizza < Producto
  self.table_name = 'pizzas'
  
  has_many :tamano_pizzas, dependent: :destroy
  accepts_nested_attributes_for :tamano_pizzas, allow_destroy: true

  # Alias para mantener consistencia con nombres en español
  def nombre
    self.name
  end

  def nombre=(value)
    self.name = value
  end

  # Atributos específicos de pizza
  attribute :categoria, :string
  attribute :borde_queso, :boolean, default: false
  attribute :combinada, :boolean, default: false
  
  validates :categoria, presence: true, inclusion: { in: ['tradicional', 'especial'] }
  validates :nombre, presence: true
  
  scope :tradicionales, -> { where(categoria: 'tradicional') }
  scope :especiales, -> { where(categoria: 'especial') }
  
  # Heredamos las relaciones de Producto para adicionales e ingredientes
  
  def precio_por_tamano(tamano)
    tamano_pizzas.find_by(tamano: tamano)&.precio
  end
  
  def disponible_en_tamano?(tamano)
    tamano_pizzas.exists?(tamano: tamano)
  end
  
  # Sobrescribimos el método de precio para usar el precio según el tamaño
  def precio
    precio_por_tamano('personal') || 0
  end
  
  def precio_small
    precio_por_tamano('small') || 0
  end
  
  def precio_medium
    precio_por_tamano('medium') || 0
  end
  
  def precio_large
    precio_por_tamano('large') || 0
  end
end
