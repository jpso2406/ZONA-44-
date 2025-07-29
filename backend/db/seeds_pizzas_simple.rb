# Seeds simplificados para el Sistema de Pizzas
puts "🌍 Creando datos del sistema de pizzas..."

# Crear tamaños de pizza
puts "📏 Creando tamaños de pizza..."
tamanos = [
  { nombre: 'Personal', slices: 4, tamano_cm: 20 },
  { nombre: 'Small', slices: 8, tamano_cm: 30 },
  { nombre: 'Medium', slices: 12, tamano_cm: 40 },
  { nombre: 'Large', slices: 16, tamano_cm: 50 }
]

tamanos.each do |tamano_data|
  TamanoPizza.find_or_create_by!(nombre: tamano_data[:nombre]) do |t|
    t.slices = tamano_data[:slices]
    t.tamano_cm = tamano_data[:tamano_cm]
  end
end

# Crear pizzas tradicionales
puts "🍕 Creando pizzas tradicionales..."
pizzas_tradicionales = [
  {
    nombre: 'Jamón y Queso',
    descripcion: 'Deliciosa pizza con jamón y queso mozzarella',
    precios: { 'Personal' => 17_000, 'Small' => 23_000, 'Medium' => 39_000, 'Large' => 48_000 }
  },
  {
    nombre: 'Hawaiana',
    descripcion: 'Pizza con jamón y piña, un clásico tropical',
    precios: { 'Personal' => 20_000, 'Small' => 27_000, 'Medium' => 44_000, 'Large' => 54_000 }
  },
  {
    nombre: 'Pollo',
    descripcion: 'Pizza con pollo a la plancha y queso mozzarella',
    precios: { 'Personal' => 21_000, 'Small' => 29_000, 'Medium' => 48_000, 'Large' => 58_000 }
  },
  {
    nombre: 'Suiza',
    descripcion: 'Pizza con jamón y champiñones',
    precios: { 'Personal' => 21_000, 'Small' => 29_000, 'Medium' => 48_000, 'Large' => 58_000 }
  },
  {
    nombre: 'Peperoni',
    descripcion: 'Pizza con peperoni y queso mozzarella',
    precios: { 'Personal' => 21_000, 'Small' => 29_000, 'Medium' => 48_000, 'Large' => 58_000 }
  },
  {
    nombre: 'Tocinetta',
    descripcion: 'Pizza con tocineta y queso mozzarella',
    precios: { 'Personal' => 21_000, 'Small' => 29_000, 'Medium' => 48_000, 'Large' => 58_000 }
  }
]

grupo_tradicional = Grupo.find_or_create_by!(nombre: 'Pizzas Tradicionales')

pizzas_tradicionales.each do |pizza_data|
  pizza = PizzaTradicional.find_or_create_by!(nombre: pizza_data[:nombre]) do |p|
    p.descripcion = pizza_data[:descripcion]
    p.categoria = 'tradicional'
    p.grupo = grupo_tradicional
  end
  # Crear precios por tamaño
  pizza_data[:precios].each do |tamano_nombre, precio|
    tamano = TamanoPizza.find_by(nombre: tamano_nombre)
    PizzaTamano.find_or_create_by!(pizza_tradicional: pizza, tamano_pizza: tamano) do |pt|
      pt.precio = precio
    end
  end
end

# Crear pizzas especiales
puts "🌟 Creando pizzas especiales..."
pizzas_especiales = [
  {
    nombre: 'Costeña',
    descripcion: 'Pizza con chorizo, butifarra, maíz, pimentón y cebolla',
    precios: { 'Personal' => 22_000, 'Small' => 32_000, 'Medium' => 54_000, 'Large' => 67_000 }
  },
  {
    nombre: 'Cuatro Carnes',
    descripcion: 'Pizza con pollo, suiza, tocineta y peperoni',
    precios: { 'Personal' => 28_000, 'Small' => 40_000, 'Medium' => 58_000, 'Large' => 71_000 }
  },
  {
    nombre: 'Zona 44',
    descripcion: 'Pizza con pollo, suiza, tocineta, champiñón, pimentón, cebolla y maíz',
    precios: { 'Personal' => 30_000, 'Small' => 44_000, 'Medium' => 66_000, 'Large' => 77_000 }
  }
]

grupo_especial = Grupo.find_or_create_by!(nombre: 'Pizzas Especiales')

pizzas_especiales.each do |pizza_data|
  pizza = PizzaEspecial.find_or_create_by!(nombre: pizza_data[:nombre]) do |p|
    p.descripcion = pizza_data[:descripcion]
    p.categoria = 'especial'
    p.grupo = grupo_especial
  end
  # Crear precios por tamaño
  pizza_data[:precios].each do |tamano_nombre, precio|
    tamano = TamanoPizza.find_by(nombre: tamano_nombre)
    PizzaTamano.find_or_create_by!(pizza_especial: pizza, tamano_pizza: tamano) do |pt|
      pt.precio = precio
    end
  end
end

# Crear pizza combinada
puts "🔄 Creando pizza combinada..."
grupo_combinada = Grupo.find_or_create_by!(nombre: 'Pizzas Combinadas')

pizza_combinada = PizzaCombinada.find_or_create_by!(nombre: 'Combinada') do |p|
  p.descripcion = 'Elige 2 sabores de pizzas tradicionales para crear tu pizza personalizada'
  p.categoria = 'combinada'
  p.grupo = grupo_combinada
end

# Crear precios por tamaño para pizza combinada
precios_combinada = { 'Personal' => 24_000, 'Small' => 34_000, 'Medium' => 58_000, 'Large' => 70_000 }
precios_combinada.each do |tamano_nombre, precio|
  tamano = TamanoPizza.find_by(nombre: tamano_nombre)
  PizzaTamano.find_or_create_by!(pizza_combinada: pizza_combinada, tamano_pizza: tamano) do |pt|
    pt.precio = precio
  end
end

# Crear adicionales
puts "➕ Creando adicionales..."
adicionales = [ 'Piña', 'Maíz', 'Champiñón', 'Tocinetta' ]

adicionales.each do |nombre|
  Adicional.find_or_create_by!(ingredientes: nombre)
end

puts "✅ ¡Datos del sistema de pizzas creados exitosamente!"
puts "📊 Resumen:"
puts "   - #{TamanoPizza.count} tamaños de pizza"
puts "   - #{PizzaTradicional.count} pizzas tradicionales"
puts "   - #{PizzaEspecial.count} pizzas especiales"
puts "   - #{PizzaCombinada.count} pizza combinada"
puts "   - #{Adicional.count} adicionales"
puts "   - #{PizzaTamano.count} precios configurados"
