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
    { nombre: "Perro", slug: "perro", imagen: "perroh.jpg" }
  ]

  grupos_data.each do |grupo_info|
    grupo = Grupo.find_or_initialize_by(slug: grupo_info[:slug])
    if grupo.new_record?
      grupo.nombre = grupo_info[:nombre]
      grupo.save!
      puts "Grupo creado: #{grupo.nombre}"
    else
      puts "El grupo ya existe: #{grupo.nombre}"
    end

    # Adjuntar foto si no está y si hay imagen definida
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
    { name: "salchipapa sensilla", precio: 8000, descripcion: "Salchipapa con salsa", grupo_slug: "salchipapa", imagen: "salchipapasencilla.jpg" },
    { name: "perro sencillo", precio: 7000, descripcion: "Perro con papas", grupo_slug: "perro", imagen: "perrosencillo.jpg" }
  ]

  productos_data.each do |producto_info|
    grupo = Grupo.find_by(slug: producto_info[:grupo_slug])
    unless grupo
      puts "⚠️ No se encontró el grupo con slug: #{producto_info[:grupo_slug]}"
      next
    end

    producto = Producto.find_or_initialize_by(name: producto_info[:name], grupo_id: grupo.id)
    if producto.new_record?
      producto.precio = producto_info[:precio]
      producto.descripcion = producto_info[:descripcion]
      producto.grupo = grupo
      producto.save!
      puts "Producto creado: #{producto.name}"
    else
      puts "El producto ya existe: #{producto.name}"
    end

    # Adjuntar foto si no está y si hay imagen definida
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
