# This file should ensure the existence of records required to run the application in every environment (production,
# development, test). The code here should be idempotent so that it can be executed at any point in every environment.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Example:
#
#   ["Action", "Comedy", "Drama", "Horror"].each do |genre_name|
#     MovieGenre.find_or_create_by!(name: genre_name)
#   end


# =======================
# Admin
# =======================
if Rails.env.development?
  # Admin
  admin_email = 'admin@example.com'
  admin_password = '123456'

  admin = User.find_or_initialize_by(email: admin_email)
  unless admin.persisted?
    admin.password = admin_password
    admin.password_confirmation = admin_password
    admin.role = :admin
    admin.save!
    puts "✅ Admin creado: #{admin_email}"
  else
    puts "ℹ️ El admin ya existe: #{admin_email}"
  end
end

# =======================
# Adicionales
# =======================
adicionales_data = [
  { ingredientes: "Suiza", precio: 8000 },
  { ingredientes: "Chorizo de cerdo", precio: 6000 },
  { ingredientes: "Tocineta (2UN)", precio: 4000 },
  { ingredientes: "Papas a la francesa", precio: 5000 },
  { ingredientes: "Q. Mozzarella gratinado sencillo", precio: 5000 },
  { ingredientes: "Ensalada", precio: 5000 }
]

adicionales_data.each do |adicional_info|
  adicional = Adicional.find_or_initialize_by(ingredientes: adicional_info[:ingredientes])
  adicional.precio = adicional_info[:precio] if adicional.respond_to?(:precio)
  adicional.save!
  puts "✅ Adicional creado o actualizado: #{adicional.ingredientes} - $#{adicional_info[:precio]}"
end

# =======================
# Grupos
# =======================

puts "==== Cargando grupos ===="

imagenes_path = Rails.root.join("db", "seeds", "imagenes")

grupos_data = [
  { nombre: "Bebidas", slug: "bebidas", imagen: "bebida.jpg" },
  { nombre: "Salchipapas", slug: "salchipapas", imagen: "salchipapa.jpg" },
  { nombre: "Perro Caliente", slug: "perro-caliente", imagen: "perroh.jpg" },
  { nombre: "Hamburguesa", slug: "hamburguesa", imagen: "hamburguesa.jpeg" },
  { nombre: "Picadas Mini", slug: "picadas-mini", imagen: "picadapolloycarne.jpeg" },
  { nombre: "Sandwich", slug: "sandwich", imagen: "sandwichdepollo.jpeg" },
  { nombre: "Asados", slug: "asados", imagen: "lonchadecerdo.jpeg" },
  { nombre: "Chuzo Desgranado", slug: "chuzo-desgranado", imagen: "logo.jpg" },
  { nombre: "Desgranados", slug: "desgranados", imagen: "logo.jpg" },
  { nombre: "Salvajadas Desgranada", slug: "salvajadas-desgranada", imagen: "logo.jpg" },
  { nombre: "Salvajadas", slug: "salvajadas", imagen: "logo.jpg" },
  { nombre: "Menú Infantil", slug: "menu-infantil", imagen: "logo.jpg" },
  { nombre: "Gourmet", slug: "gourmet", imagen: "logo.jpg" }
]

grupos_data.each do |grupo_info|
  grupo = Grupo.find_by(slug: grupo_info[:slug]) || Grupo.find_by(nombre: grupo_info[:nombre])

  if grupo.nil?
    grupo = Grupo.create!(nombre: grupo_info[:nombre], slug: grupo_info[:slug])
    puts "✅ Grupo creado: #{grupo.nombre}"
  else
    puts "ℹ️ Grupo ya existente: #{grupo.nombre}"
  end

  if grupo.respond_to?(:foto) && !grupo.foto.attached? && grupo_info[:imagen].present?
    ruta_imagen = imagenes_path.join(grupo_info[:imagen])
    if File.exist?(ruta_imagen)
      grupo.foto.attach(io: File.open(ruta_imagen), filename: grupo_info[:imagen])
      puts "📷 Foto adjuntada al grupo: #{grupo.nombre}"
    else
      default_img = imagenes_path.join("logo.jpg")
      grupo.foto.attach(io: File.open(default_img), filename: "logo.jpg")
      puts "⚠️ Imagen no encontrada, se asignó logo por defecto al grupo: #{grupo.nombre}"
    end
  end
end

# =======================
# Productos - Perro Caliente, Salchipapas, Sandwich, Salvajadas, Asados, Hamburguesa
# =======================

puts "==== Cargando productos: Perro Caliente, Salchipapas, Sandwich, Salvajadas, Asados, Hamburguesa ===="

productos_data = [
  # -----------------------
  # PERRO CALIENTE
  # -----------------------
  { name: "El Sencillito Mozzarella", precio: 7000, descripcion: "Perro con queso mozzarella.", grupo_slug: "perro-caliente", imagen: "perrosencillo.jpg", ingredientes: ["Q. Mozzarella gratinado sencillo"] },
  { name: "El Sencillito a la Plancha", precio: 8000, descripcion: "Perro a la plancha con papas.", grupo_slug: "perro-caliente", imagen: "elsencilloalaplancha.jpeg", ingredientes: ["Papas a la francesa"] },
  { name: "Gemelo Mozzarella", precio: 12000, descripcion: "Perro doble con queso mozzarella.", grupo_slug: "perro-caliente", imagen: "gemelomozzarella.jpeg", ingredientes: ["Q. Mozzarella gratinado sencillo"] },
  { name: "La Costeñita", precio: 13000, descripcion: "Salchicha, chorizo y butifarra.", grupo_slug: "perro-caliente", imagen: "logo.jpg", ingredientes: ["Chorizo de cerdo"] },
  { name: "Hawaiano", precio: 13000, descripcion: "Perro hawaiano con piña.", grupo_slug: "perro-caliente", imagen: "logo.jpg", ingredientes: ["Piña"] },
  { name: "El Choriperro", precio: 14000, descripcion: "Perro con chorizo de cerdo.", grupo_slug: "perro-caliente", imagen: "chorriperro.jpeg", ingredientes: ["Chorizo de cerdo"] },
  { name: "El Mixto", precio: 14000, descripcion: "Salchicha, carne y pollo.", grupo_slug: "perro-caliente", imagen: "logo.jpg", ingredientes: [] },
  { name: "El Suizo", precio: 18000, descripcion: "Perro con salchicha suiza.", grupo_slug: "perro-caliente", imagen: "logo.jpg", ingredientes: ["Suiza"] },
  { name: "Zona 44", precio: 23000, descripcion: "Salchicha suiza, pollo, tocineta, maíz, bañada en salsa Alfredo y queso parmesano.", grupo_slug: "perro-caliente", imagen: "perrozona44.jpeg", ingredientes: ["Suiza", "Pollo", "Tocineta (2UN)", "Maíz", "Salsa Alfredo", "Queso Parmesano"] },

  # -----------------------
  # SALCHIPAPAS
  # -----------------------
  { name: "La Sencilla", precio: 14000, descripcion: "Salchipapa sencilla.", grupo_slug: "salchipapas", imagen: "logo.jpg", ingredientes: [] },
  { name: "Choripapa", precio: 17000, descripcion: "Salchipapa con chorizo.", grupo_slug: "salchipapas", imagen: "logo.jpg", ingredientes: ["Chorizo de cerdo"] },
  { name: "La Costeña", precio: 17000, descripcion: "Salchipapa con sabores costeños.", grupo_slug: "salchipapas", imagen: "logo.jpg", ingredientes: [] },
  { name: "Suiza", precio: 20000, descripcion: "Salchipapa con salchicha suiza.", grupo_slug: "salchipapas", imagen: "logo.jpg", ingredientes: ["Suiza"] },
  { name: "Pollipapa", precio: 21000, descripcion: "Salchipapa con pollo.", grupo_slug: "salchipapas", imagen: "logo.jpg", ingredientes: ["Pollo"] },
  { name: "La Carnívora", precio: 21000, descripcion: "Salchipapa con carnes variadas.", grupo_slug: "salchipapas", imagen: "logo.jpg", ingredientes: [] },
  { name: "Mixta", precio: 23000, descripcion: "Salchipapa mixta con varias carnes.", grupo_slug: "salchipapas", imagen: "logo.jpg", ingredientes: [] },
  { name: "Pollo Suiza", precio: 23000, descripcion: "Salchipapa con pollo y salchicha suiza.", grupo_slug: "salchipapas", imagen: "logo.jpg", ingredientes: ["Pollo", "Suiza"] },

  # -----------------------
  # SANDWICH
  # -----------------------
  { name: "Sandwich de Jamón y Queso", precio: 12000, descripcion: "Sandwich de jamón y queso.", grupo_slug: "sandwich", imagen: "logo.jpg", ingredientes: ["Q. Mozzarella gratinado sencillo"] },
  { name: "Sandwich Hawaiano", precio: 14000, descripcion: "Sandwich con jamón, piña y queso.", grupo_slug: "sandwich", imagen: "logo.jpg", ingredientes: ["Piña", "Jamón"] },
  { name: "Sandwich de Pollo", precio: 17000, descripcion: "Sandwich de pollo con papas a la francesa.", grupo_slug: "sandwich", imagen: "sandwichdepollo.jpeg", ingredientes: ["Papas a la francesa"] },
  { name: "Súper Sandwich", precio: 24000, descripcion: "Pechuga, salami, queso cheddar, tocineta, jamón, mozzarella y papas a la francesa.", grupo_slug: "sandwich", imagen: "logo.jpg", ingredientes: ["Queso Cheddar", "Tocineta (2UN)", "Jamón", "Papas a la francesa"] },

  # -----------------------
  # SALVAJADAS
  # -----------------------
  { name: "Cuatro Sabores", precio: 42000, descripcion: "Salvajada para 2 o 3 personas.", grupo_slug: "salvajadas", imagen: "logo.jpg", ingredientes: [] },
  { name: "Salvajada", precio: 54000, descripcion: "Salvajada para 4 personas.", grupo_slug: "salvajadas", imagen: "logo.jpg", ingredientes: [] },
  { name: "Súper Salvajada", precio: 63000, descripcion: "Salvajada para 6 personas.", grupo_slug: "salvajadas", imagen: "logo.jpg", ingredientes: [] },

  # -----------------------
  # ASADOS
  # -----------------------
  { name: "Pechuga Asada", precio: 23000, descripcion: "Pechuga asada 300g.", grupo_slug: "asados", imagen: "pechugaasada.jpeg", ingredientes: ["Papas a la francesa"] },
  { name: "Alitas BBQ", precio: 23000, descripcion: "8 piezas de alitas BBQ.", grupo_slug: "asados", imagen: "logo.jpg", ingredientes: ["Salsa BBQ"] },
  { name: "Loncha de Cerdo", precio: 24000, descripcion: "Loncha de cerdo 350g.", grupo_slug: "asados", imagen: "lonchadecerdo.jpeg", ingredientes: ["Papas a la francesa"] },
  { name: "Carne Asada", precio: 26000, descripcion: "Carne asada 250g.", grupo_slug: "asados", imagen: "logo.jpg", ingredientes: ["Papas a la francesa"] },
  { name: "Asado Mixto", precio: 30000, descripcion: "Carne 125g, pechuga 150g, chorizo de cerdo.", grupo_slug: "asados", imagen: "logo.jpg", ingredientes: ["Chorizo de cerdo", "Pollo", "Res"] },
  { name: "Costillas BBQ", precio: 30000, descripcion: "Costillas de cerdo 500g bañadas en salsa BBQ.", grupo_slug: "asados", imagen: "costillasbbq.jpeg", ingredientes: ["Salsa BBQ"] },
  { name: "Churrasco", precio: 31000, descripcion: "Churrasco 300g.", grupo_slug: "asados", imagen: "logo.jpg", ingredientes: [] },
  { name: "Punta Gorda", precio: 33000, descripcion: "Punta Gorda 300g.", grupo_slug: "asados", imagen: "logo.jpg", ingredientes: [] },

  # -----------------------
  # HAMBURGUESA
  # -----------------------
  { name: "La Carnívora", precio: 18000, descripcion: "150g de carne de la casa.", grupo_slug: "hamburguesa", imagen: "logo.jpg", ingredientes: [] },
  { name: "Chicken Burger", precio: 18000, descripcion: "150g de filete de pollo.", grupo_slug: "hamburguesa", imagen: "logo.jpg", ingredientes: ["Pollo"] },
  { name: "Hawaiana", precio: 22000, descripcion: "Carne 150g, piña en trozos, queso costeño asado.", grupo_slug: "hamburguesa", imagen: "hamburguesahawaiana.jpeg", ingredientes: ["Piña", "Queso Costeño"] },
  { name: "Bacon Burger", precio: 23000, descripcion: "150g de carne, queso cheddar, 4 tiras de tocineta.", grupo_slug: "hamburguesa", imagen: "logo.jpg", ingredientes: ["Queso Cheddar", "Tocineta (2UN)"] },
  { name: "Burger Mixta", precio: 27000, descripcion: "150g carne + 100g pollo, queso cheddar.", grupo_slug: "hamburguesa", imagen: "burguermixta.jpeg", ingredientes: ["Queso Cheddar", "Pollo"] },
  { name: "Big Burger", precio: 27000, descripcion: "Doble carne 300g con queso cheddar.", grupo_slug: "hamburguesa", imagen: "Hamburguesadoblecarne.jpeg", ingredientes: ["Queso Cheddar"] },
  { name: "América Burger", precio: 27000, descripcion: "150g carne, 1/2 suiza, salsa de queso cheddar.", grupo_slug: "hamburguesa", imagen: "logo.jpg", ingredientes: ["Suiza", "Queso Cheddar"] },
  { name: "Choriburguer", precio: 27000, descripcion: "150g carne, queso americano, chorizo en chimichurri y cebolla caramelizada.", grupo_slug: "hamburguesa", imagen: "hamburguesachoriburguer.jpeg", ingredientes: ["Queso Americano", "Chorizo de cerdo", "Cebolla caramelizada"] },
  { name: "Deluxe Burger", precio: 27000, descripcion: "150g carne, tocineta, cebolla caramelizada, queso costeño, aros de cebolla, queso cheddar.", grupo_slug: "hamburguesa", imagen: "logo.jpg", ingredientes: ["Tocineta (2UN)", "Cebolla caramelizada", "Queso Costeño", "Queso Cheddar"] },
  { name: "La Callejera Burger", precio: 29000, descripcion: "150g carne, tocineta crunch, chorizo argentino, cebolla caramelizada, salsa de queso cheddar.", grupo_slug: "hamburguesa", imagen: "logo.jpg", ingredientes: ["Tocineta (2UN)", "Chorizo de cerdo", "Cebolla caramelizada", "Queso Cheddar"] }
]

productos_data.each do |producto_info|
  grupo = Grupo.find_by(slug: producto_info[:grupo_slug])
  unless grupo
    puts "⚠️ No se encontró el grupo con slug: #{producto_info[:grupo_slug]}"
    next
  end

  producto = Producto.find_or_initialize_by(name: producto_info[:name], grupo_id: grupo.id)
  producto.precio = producto_info[:precio]
  producto.descripcion = producto_info[:descripcion]
  producto.grupo = grupo
  producto.save!
  puts "✅ Producto creado o actualizado: #{producto.name}"

  # Imagen
  if producto.respond_to?(:foto) && !producto.foto.attached? && producto_info[:imagen].present?
    ruta_imagen = imagenes_path.join(producto_info[:imagen])
    if File.exist?(ruta_imagen)
      producto.foto.attach(io: File.open(ruta_imagen), filename: producto_info[:imagen])
      puts "📷 Foto adjuntada al producto: #{producto.name}"
    else
      default_img = imagenes_path.join("logo.jpg")
      producto.foto.attach(io: File.open(default_img), filename: "logo.jpg")
      puts "⚠️ Imagen no encontrada, se asignó logo por defecto al producto: #{producto.name}"
    end
  end

  # Adicionales
  if producto_info[:ingredientes].present?
    producto.adicionales.clear
    producto_info[:ingredientes].each do |nombre_ing|
      adicional = Adicional.find_by(ingredientes: nombre_ing)
      if adicional
        producto.adicionales << adicional unless producto.adicionales.include?(adicional)
        puts "   ➕ Ingrediente agregado: #{nombre_ing} a #{producto.name}"
      else
        puts "   ⚠️ Ingrediente no encontrado: #{nombre_ing}"
      end
    end
  end
end

# =======================
# Productos - Desgranados, Picadas Mini, Chuzo Desgranado, Salvajadas Desgranada, Gourmet
# =======================

puts "==== Cargando productos: Desgranados, Picadas Mini, Chuzo Desgranado, Salvajadas Desgranada, Gourmet ===="

productos_data = [
  # -----------------------
  # DESGRANADOS
  # -----------------------
  { name: "Sencilla", precio: 17000, descripcion: "Desgranado sencillo.", grupo_slug: "desgranados", imagen: "logo.jpg", ingredientes: ["Maíz", "Q. Mozzarella gratinado sencillo"] },
  { name: "Choripapa", precio: 20000, descripcion: "Desgranado con chorizo y papas.", grupo_slug: "desgranados", imagen: "logo.jpg", ingredientes: ["Chorizo de cerdo", "Papas a la francesa"] },
  { name: "Costeña", precio: 20000, descripcion: "Desgranado con toque costeño.", grupo_slug: "desgranados", imagen: "logo.jpg", ingredientes: [] },
  { name: "Suiza", precio: 22000, descripcion: "Desgranado con salchicha suiza.", grupo_slug: "desgranados", imagen: "logo.jpg", ingredientes: ["Suiza"] },
  { name: "Pollo", precio: 23000, descripcion: "Desgranado con pollo.", grupo_slug: "desgranados", imagen: "logo.jpg", ingredientes: ["Pollo"] },
  { name: "Carne", precio: 23000, descripcion: "Desgranado con carne.", grupo_slug: "desgranados", imagen: "logo.jpg", ingredientes: ["Res"] },
  { name: "Mixta", precio: 26000, descripcion: "Desgranado mixto de carne y pollo.", grupo_slug: "desgranados", imagen: "logo.jpg", ingredientes: ["Pollo", "Res"] },

  # -----------------------
  # PICADAS MINI
  # -----------------------
  { name: "Chorizo de Cerdo", precio: 14000, descripcion: "Picada con chorizo de cerdo.", grupo_slug: "picadas-mini", imagen: "logo.jpg", ingredientes: ["Chorizo de cerdo"] },
  { name: "Buti-Chorizo y Salchicha", precio: 14000, descripcion: "Picada de butifarra, chorizo y salchicha.", grupo_slug: "picadas-mini", imagen: "logo.jpg", ingredientes: ["Chorizo de cerdo"] },
  { name: "Pollo y Carne", precio: 16000, descripcion: "Picada con pollo y carne.", grupo_slug: "picadas-mini", imagen: "picadapolloycarne.jpeg", ingredientes: ["Pollo", "Res"] },

  # -----------------------
  # CHUZO DESGRANADO
  # -----------------------
  { name: "Buti-Chorizo y Salchicha", precio: 23000, descripcion: "Chuzo desgranado con butifarra, chorizo y salchicha.", grupo_slug: "chuzo-desgranado", imagen: "logo.jpg", ingredientes: ["Chorizo de cerdo"] },
  { name: "Pollo y Carne", precio: 28000, descripcion: "Chuzo desgranado con pollo y carne.", grupo_slug: "chuzo-desgranado", imagen: "logo.jpg", ingredientes: ["Pollo", "Res"] },
  { name: "Suizo", precio: 28000, descripcion: "Chuzo desgranado con salchicha suiza.", grupo_slug: "chuzo-desgranado", imagen: "logo.jpg", ingredientes: ["Suiza"] },

  # -----------------------
  # SALVAJADAS DESGRANADA
  # -----------------------
  { name: "Cuatro Sabores", precio: 46000, descripcion: "Salvajada desgranada para 2 personas.", grupo_slug: "salvajadas-desgranada", imagen: "logo.jpg", ingredientes: [] },
  { name: "Salvajada", precio: 58000, descripcion: "Salvajada desgranada para 4 personas.", grupo_slug: "salvajadas-desgranada", imagen: "logo.jpg", ingredientes: [] },
  { name: "Súper Salvajada", precio: 67000, descripcion: "Salvajada desgranada para 6 personas.", grupo_slug: "salvajadas-desgranada", imagen: "logo.jpg", ingredientes: [] },

  # -----------------------
  # GOURMET
  # -----------------------
  { name: "Creppes de Pollo con Champiñón", precio: 24000, descripcion: "Pollo en salsa Alfredo, champiñones, gratinado de mozzarella y parmesano.", grupo_slug: "gourmet", imagen: "logo.jpg", ingredientes: ["Pollo", "Champiñón", "Salsa Alfredo", "Queso Parmesano"] },
  { name: "Creppes de Lomito de Res con Champiñón", precio: 27000, descripcion: "Lomito de res en salsa Alfredo, champiñones, gratinado de mozzarella y parmesano.", grupo_slug: "gourmet", imagen: "logo.jpg", ingredientes: ["Res", "Champiñón", "Salsa Alfredo", "Queso Parmesano"] },
  { name: "Creppes Mixto con Champiñón", precio: 29000, descripcion: "Pollo y res en salsa Alfredo, champiñones, gratinado de mozzarella y parmesano.", grupo_slug: "gourmet", imagen: "logo.jpg", ingredientes: ["Pollo", "Res", "Champiñón", "Salsa Alfredo", "Queso Parmesano"] },
  { name: "Lasagna Boloñesa", precio: 22000, descripcion: "Carne molida en salsa napolitana, gratinado de mozzarella y parmesano.", grupo_slug: "gourmet", imagen: "logo.jpg", ingredientes: ["Res", "Salsa Napolitana", "Queso Parmesano"] },
  { name: "Lasagna de Pollo con Champiñón", precio: 26000, descripcion: "Pollo con champiñones en salsa Alfredo, gratinado de mozzarella y parmesano.", grupo_slug: "gourmet", imagen: "logo.jpg", ingredientes: ["Pollo", "Champiñón", "Salsa Alfredo", "Queso Parmesano"] },
  { name: "Lasagna Mixta", precio: 26000, descripcion: "Pollo y champiñones en salsa Alfredo y salsa napolitana, gratinado de mozzarella y parmesano.", grupo_slug: "gourmet", imagen: "logo.jpg", ingredientes: ["Pollo", "Champiñón", "Salsa Alfredo", "Salsa Napolitana", "Queso Parmesano"] }
]

productos_data.each do |producto_info|
  grupo = Grupo.find_by(slug: producto_info[:grupo_slug])
  unless grupo
    puts "⚠️ No se encontró el grupo con slug: #{producto_info[:grupo_slug]}"
    next
  end

  producto = Producto.find_or_initialize_by(name: producto_info[:name], grupo_id: grupo.id)
  producto.precio = producto_info[:precio]
  producto.descripcion = producto_info[:descripcion]
  producto.grupo = grupo
  producto.save!
  puts "✅ Producto creado o actualizado: #{producto.name}"

  # Imagen
  if producto.respond_to?(:foto) && !producto.foto.attached? && producto_info[:imagen].present?
    ruta_imagen = imagenes_path.join(producto_info[:imagen])
    if File.exist?(ruta_imagen)
      producto.foto.attach(io: File.open(ruta_imagen), filename: producto_info[:imagen])
      puts "📷 Foto adjuntada al producto: #{producto.name}"
    else
      default_img = imagenes_path.join("logo.jpg")
      producto.foto.attach(io: File.open(default_img), filename: "logo.jpg")
      puts "⚠️ Imagen no encontrada, se asignó logo por defecto al producto: #{producto.name}"
    end
  end

  # Adicionales
  if producto_info[:ingredientes].present?
    producto.adicionales.clear
    producto_info[:ingredientes].each do |nombre_ing|
      adicional = Adicional.find_by(ingredientes: nombre_ing)
      if adicional
        producto.adicionales << adicional unless producto.adicionales.include?(adicional)
        puts "   ➕ Ingrediente agregado: #{nombre_ing} a #{producto.name}"
      else
        puts "   ⚠️ Ingrediente no encontrado: #{nombre_ing}"
      end
    end
  end
end

# =======================
# Productos - Menú Infantil, Bebidas
# =======================

puts "==== Cargando productos: Menú Infantil, Bebidas ===="

productos_data = [
  # -----------------------
  # MENÚ INFANTIL
  # -----------------------
  { name: "Chicken Kinder", precio: 15000, descripcion: "150g filete de pechuga, papas a la francesa y bebida.", grupo_slug: "menu-infantil", imagen: "logo.jpg", ingredientes: ["Pollo", "Papas a la francesa"] },
  { name: "Nuggets de Pollo", precio: 15000, descripcion: "Cinco unidades de nuggets, papas a la francesa y bebida.", grupo_slug: "menu-infantil", imagen: "logo.jpg", ingredientes: ["Pollo", "Papas a la francesa"] },
  { name: "Rancheritas", precio: 15000, descripcion: "Dos unidades de rancheritas, papas a la francesa y bebida.", grupo_slug: "menu-infantil", imagen: "logo.jpg", ingredientes: ["Papas a la francesa"] },
  { name: "Jugo Infantil", precio: 2500, descripcion: "Jugo para menú infantil.", grupo_slug: "menu-infantil", imagen: "logo.jpg", ingredientes: [] },

  # -----------------------
  # BEBIDAS
  # -----------------------
  { name: "Postobón Personal", precio: 4000, descripcion: "Bebida Postobón personal 400ml.", grupo_slug: "bebidas", imagen: "logo.jpg", ingredientes: [] },
  { name: "Coca Cola Personal", precio: 4000, descripcion: "Bebida Coca Cola personal 400ml.", grupo_slug: "bebidas", imagen: "logo.jpg", ingredientes: [] },
  { name: "Jugo Hit Personal", precio: 4000, descripcion: "Jugo Hit personal 400ml.", grupo_slug: "bebidas", imagen: "logo.jpg", ingredientes: [] },
  { name: "Soda Hatsu", precio: 5000, descripcion: "Soda Hatsu.", grupo_slug: "bebidas", imagen: "logo.jpg", ingredientes: [] },
  { name: "Postobón 1.5L", precio: 8000, descripcion: "Postobón presentación 1.5 litros.", grupo_slug: "bebidas", imagen: "logo.jpg", ingredientes: [] },
  { name: "Coca Cola 1.75L", precio: 10000, descripcion: "Coca Cola presentación 1.75 litros.", grupo_slug: "bebidas", imagen: "logo.jpg", ingredientes: [] },
  { name: "Limonada Natural Frappé", precio: 5000, descripcion: "Limonada natural frappé.", grupo_slug: "bebidas", imagen: "logo.jpg", ingredientes: [] },
  { name: "Limonada Frappé Cerezada", precio: 6000, descripcion: "Limonada frappé sabor cereza.", grupo_slug: "bebidas", imagen: "logo.jpg", ingredientes: [] },
  { name: "Limonada Frappé Coco", precio: 7000, descripcion: "Limonada frappé sabor coco.", grupo_slug: "bebidas", imagen: "logo.jpg", ingredientes: [] },
  { name: "Jugo Natural Fresa Frappé", precio: 6000, descripcion: "Jugo natural de fresa en frappé.", grupo_slug: "bebidas", imagen: "logo.jpg", ingredientes: [] },
  { name: "Jugo Natural Fresa en Leche", precio: 8000, descripcion: "Jugo natural de fresa en leche.", grupo_slug: "bebidas", imagen: "logo.jpg", ingredientes: [] },
  { name: "Jugo Natural Maracuyá Frappé", precio: 6000, descripcion: "Jugo natural de maracuyá en frappé.", grupo_slug: "bebidas", imagen: "logo.jpg", ingredientes: [] },
  { name: "Jugo Natural Maracuyá en Leche", precio: 8000, descripcion: "Jugo natural de maracuyá en leche.", grupo_slug: "bebidas", imagen: "logo.jpg", ingredientes: [] },
  { name: "Agua 500ml", precio: 3000, descripcion: "Agua 500ml.", grupo_slug: "bebidas", imagen: "logo.jpg", ingredientes: [] },
  { name: "Margarita de Fresa", precio: 18000, descripcion: "Margarita de fresa.", grupo_slug: "bebidas", imagen: "logo.jpg", ingredientes: [] },
  { name: "Margarita de Maracuyá", precio: 18000, descripcion: "Margarita de maracuyá.", grupo_slug: "bebidas", imagen: "logo.jpg", ingredientes: [] },
  { name: "Cerveza Águila", precio: 5000, descripcion: "Cerveza Águila.", grupo_slug: "bebidas", imagen: "logo.jpg", ingredientes: [] },
  { name: "Coronita", precio: 5000, descripcion: "Cerveza Coronita.", grupo_slug: "bebidas", imagen: "logo.jpg", ingredientes: [] },
  { name: "Adicional Michelada", precio: 2000, descripcion: "Extra de michelada.", grupo_slug: "bebidas", imagen: "logo.jpg", ingredientes: [] }
]

productos_data.each do |producto_info|
  grupo = Grupo.find_by(slug: producto_info[:grupo_slug])
  unless grupo
    puts "⚠️ No se encontró el grupo con slug: #{producto_info[:grupo_slug]}"
    next
  end

  producto = Producto.find_or_initialize_by(name: producto_info[:name], grupo_id: grupo.id)
  producto.precio = producto_info[:precio]
  producto.descripcion = producto_info[:descripcion]
  producto.grupo = grupo
  producto.save!
  puts "✅ Producto creado o actualizado: #{producto.name}"

  # Imagen
  if producto.respond_to?(:foto) && !producto.foto.attached? && producto_info[:imagen].present?
    ruta_imagen = imagenes_path.join(producto_info[:imagen])
    if File.exist?(ruta_imagen)
      producto.foto.attach(io: File.open(ruta_imagen), filename: producto_info[:imagen])
      puts "📷 Foto adjuntada al producto: #{producto.name}"
    else
      default_img = imagenes_path.join("logo.jpg")
      producto.foto.attach(io: File.open(default_img), filename: "logo.jpg")
      puts "⚠️ Imagen no encontrada, se asignó logo por defecto al producto: #{producto.name}"
    end
  end

  # Adicionales
  if producto_info[:ingredientes].present?
    producto.adicionales.clear
    producto_info[:ingredientes].each do |nombre_ing|
      adicional = Adicional.find_by(ingredientes: nombre_ing)
      if adicional
        producto.adicionales << adicional unless producto.adicionales.include?(adicional)
        puts "   ➕ Ingrediente agregado: #{nombre_ing} a #{producto.name}"
      else
        puts "   ⚠️ Ingrediente no encontrado: #{nombre_ing}"
      end
    end
  end
end
