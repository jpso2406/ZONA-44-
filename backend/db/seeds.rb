# This file should ensure the existence of records required to run the application in every environment (production,
# development, test). The code here should be idempotent so that it can be executed at any point in every environment.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Example:
#
#   ["Action", "Comedy", "Drama", "Horror"].each do |genre_name|
#     MovieGenre.find_or_create_by!(name: genre_name)
#   end

if Rails.env.development?
  admin_email = 'ojeison21@gmail.com'
  admin_password = '1234567'

  admin = Admin.find_or_initialize_by(email: admin_email)

  unless admin.persisted?
    admin.password = admin_password
    admin.password_confirmation = admin_password
    admin.confirmed_at = Time.now if admin.respond_to?(:confirmed_at)
    admin.save!
    puts "Admin creado: #{admin_email}"
  else
    puts "El admin ya existe, no se ha creado de nuevo: #{admin_email}"
  end
end

if Rails.env.development?
  puts "==== Cargando datos de prueba con fotos ===="

  imagenes_path = Rails.root.join("db", "seeds", "imagenes")

  # Grupos
  grupos_data = [
    { nombre: "Bebidas", slug: "bebidas", imagen: "bebida.jpg" },
    { nombre: "Salchipapa", slug: "salchipapa", imagen: "salchipapa.jpg" },
    { nombre: "Perro", slug: "perro", imagen: "perroh.jpg" },
    { nombre: "Hamburguesa", slug: "hamburguesa", imagen: "hamburguesa.jpeg" },
    { nombre: "Picadas Mini", slug: "picadas-mini", imagen: "picadapolloycarne.jpeg" },
    { nombre: "Sandwich", slug: "sandwich", imagen: "sandwichdepollo.jpeg" },
    { nombre: "Asados", slug: "asados", imagen: "lonchadecerdo.jpeg" }
  ]

  grupos_data.each do |grupo_info|
    grupo = Grupo.find_by(slug: grupo_info[:slug]) || Grupo.find_by(nombre: grupo_info[:nombre])

    if grupo.nil?
      grupo = Grupo.create!(nombre: grupo_info[:nombre], slug: grupo_info[:slug])
      puts "Grupo creado: #{grupo.nombre}"
    else
      puts "Grupo ya existente: #{grupo.nombre}"
    end

    if grupo.respond_to?(:foto) && !grupo.foto.attached? && grupo_info[:imagen].present?
      ruta_imagen = imagenes_path.join(grupo_info[:imagen])
      if File.exist?(ruta_imagen)
        grupo.foto.attach(io: File.open(ruta_imagen), filename: grupo_info[:imagen])
        puts "Foto adjuntada al grupo: #{grupo.nombre}"
      else
        puts "⚠️ Imagen no encontrada para grupo: #{grupo_info[:imagen]}"
      end
    end
  end

  # Productos
  productos_data = [
    { name: "salchipapa sencilla", precio: 14000, descripcion: "Salchipapa con salsa", grupo_slug: "salchipapa", imagen: "salchipapasencilla.jpg" },
    { name: "El Sencillito Mozzarella", precio: 7000, descripcion: "Perro con papas", grupo_slug: "perro", imagen: "perrosencillo.jpg" },
    { name: "El Sencillito a la Plancha", precio: 8000, descripcion: "Perro a la plancha", grupo_slug: "perro", imagen: "elsencilloalaplancha.jpeg" },
    { name: "Zona44", precio: 23000, descripcion: "Salchicha Suiza, pollo, tocineta, maíz, bañada en salsa Alfredo y queso parmesano", grupo_slug: "perro", imagen: "perrozona44.jpeg" },
    { name: "Chorri Perro", precio: 14000, descripcion: "Chorizo de cerdo", grupo_slug: "perro", imagen: "chorriperro.jpeg" },
    { name: "Gemelo Mozzarella", precio: 12000, descripcion: "Perro con queso", grupo_slug: "perro", imagen: "gemelomozzarella.jpeg" },
    { name: "Burguer Mixta", precio: 27000, descripcion: "150gr de la carne de la casa, 100gr de pollo, queso cheddar", grupo_slug: "hamburguesa", imagen: "burguermixta.jpeg" },
    { name: "Big Burguer", precio: 27000, descripcion: "Doble carne de la casa (300gr) con queso cheddar", grupo_slug: "hamburguesa", imagen: "Hamburguesadoblecarne.jpeg" },
    { name: "ChoriBurguer", precio: 27000, descripcion: "Carne de la casa 150 gr, queso americano, chorizo en chimichurri y cebolla caramelizada", grupo_slug: "hamburguesa", imagen: "hamburguesachoriburguer.jpeg" },
    { name: "Hawaiana", precio: 22000, descripcion: "Carne de la casa 150 gr, piña en trozos, queso costeño asado", grupo_slug: "hamburguesa", imagen: "hamburguesahawaiana.jpeg" },
    { name: "Picada Pollo y Carne", precio: 16000, descripcion: "Picada pollo y carne", grupo_slug: "picadas-mini", imagen: "picadapolloycarne.jpeg" },
    { name: "Sandwich de Pollo", precio: 17000, descripcion: "sandwich de pollo", grupo_slug: "sandwich", imagen: "sandwichdepollo.jpeg" },
    { name: "Loncha de Cerdo", precio: 24000, descripcion: "Loncha de cerdo con papas", grupo_slug: "asados", imagen: "lonchadecerdo.jpeg" },
    { name: "Pechuga Asada", precio: 23000, descripcion: "Pechuga 300gr con papas", grupo_slug: "asados", imagen: "pechugaasada.jpeg" },
    { name: "Costillas BBQ", precio: 30000, descripcion: "500gr con papas", grupo_slug: "asados", imagen: "costillasbbq.jpeg" },
    { name: "Limonada Frappe Cerezada", precio: 6000, descripcion: "Limonada Cerezada", grupo_slug: "bebidas", imagen: "limonadafrappecerezada.jpeg" },
    { name: "Cocacola Personal", precio: 4000, descripcion: "Bebida Personal", grupo_slug: "bebidas", imagen: "cocacola.jpg" },
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
    puts "Producto creado o actualizado: #{producto.name}"

    if producto.respond_to?(:foto) && !producto.foto.attached? && producto_info[:imagen].present?
      ruta_imagen = imagenes_path.join(producto_info[:imagen])
      if File.exist?(ruta_imagen)
        producto.foto.attach(io: File.open(ruta_imagen), filename: producto_info[:imagen])
        puts "Foto adjuntada al producto: #{producto.name}"
      else
        puts "⚠️ Imagen no encontrada para producto: #{producto_info[:imagen]}"
      end
    end
  end

  puts "==== Datos de prueba con fotos cargados ===="
end
# Adicionales
adicionales_data = [
  { ingredientes: "Tocineta" },
  { ingredientes: "Queso Mozzarella" },
  { ingredientes: "Huevo de codorniz" },
  { ingredientes: "Carne Desmechada" },
  { ingredientes: "Pollo Crispy" },
  { ingredientes: "Chorizo" }
]

adicionales_data.each do |adicional_info|
  adicional = Adicional.find_or_initialize_by(ingredientes: adicional_info[:ingredientes])
  adicional.save!
  puts "Adicional creado o actualizado: #{adicional.ingredientes}"
end
