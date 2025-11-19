class Anuncio < ApplicationRecord
  # Active Storage para la imagen del folleto
  has_one_attached :imagen

  # Validaciones
  validates :activo, inclusion: { in: [true, false] }
  validates :posicion, numericality: { only_integer: true, greater_than_or_equal_to: 0 }, allow_nil: true
  validates :imagen, presence: { message: "debe estar adjunta" }
  validate :fecha_fin_debe_ser_despues_de_inicio

  # Scopes
  scope :activos, -> { where(activo: true) }
  scope :vigentes, -> { 
    where("(fecha_inicio IS NULL OR fecha_inicio <= ?) AND (fecha_fin IS NULL OR fecha_fin >= ?)", 
          Date.today, Date.today) 
  }
  scope :ordenados, -> { order(posicion: :asc, created_at: :desc) }

  # Scope para anuncios visibles (activos y vigentes)
  scope :visibles, -> { activos.vigentes.ordenados }

  private

  def fecha_fin_debe_ser_despues_de_inicio
    if fecha_inicio.present? && fecha_fin.present? && fecha_fin < fecha_inicio
      errors.add(:fecha_fin, "debe ser posterior a la fecha de inicio")
    end
  end
end
