class Pizza < Producto
  self.table_name = 'pizzas'
  
  has_many :tamano_pizzas, dependent: :destroy
  accepts_nested_attributes_for :tamano_pizzas, allow_destroy: true
  
  # Redefinir has_one_attached para usar la clase Pizza en lugar de Producto
  def self.has_one_attached(name, dependent: :purge_later, service: nil, strict_loading: false)
    super(name, dependent: dependent, service: service, strict_loading: strict_loading)
    has_one :"#{name}_attachment", -> { where(name: name) },
            class_name: "ActiveStorage::Attachment",
            as: :record,
            inverse_of: :record,
            dependent: :destroy
    has_one :"#{name}_blob",
            through: :"#{name}_attachment",
            class_name: "ActiveStorage::Blob",
            source: :blob
  end
  
  has_one_attached :foto
  
  # La tabla usa 'nombre' directamente, no necesitamos alias

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
