# =======================
# Admin
# =======================
if Rails.env.development?
  admin_email = 'admin@example.com'
  admin_password = '123456'

  admin = Admin.find_or_initialize_by(email: admin_email)
  unless admin.persisted?
    admin.password = admin_password
    admin.password_confirmation = admin_password
    admin.save!
    puts "✅ Admin creado: #{admin_email}"
  else
    puts "ℹ️ Admin ya existe: #{admin_email}"
  end
end

# =======================
# Usuario normal (opcional)
# =======================
user_email = 'user@example.com'
user_password = '123456'

user = User.find_or_initialize_by(email: user_email)
unless user.persisted?
  user.password = user_password
  user.password_confirmation = user_password
  user.role = :user
  user.save!
  puts "✅ Usuario creado: #{user_email}"
else
  puts "ℹ️ Usuario ya existe: #{user_email}"
end

# =======================
# Grupos
# =======================
grupos = [
  { nombre: "Hamburguesa", imagen: "hamburguesa.png" },
  { nombre: "Perro Caliente", imagen: "perro_caliente.png" }, # unificado
  { nombre: "Pizza", imagen: "pizza.png" },
  { nombre: "Chuzo Desgranado", imagen: "chuzo_desgranado.png" },
  { nombre: "Salchipapas", imagen: "salchipapas.png" }, # unificado
  { nombre: "Desgranados", imagen: "desgranados.png" },
  { nombre: "Menú Infantil", imagen: "menu_infantil.png" },
  { nombre: "Gourmet", imagen: "gourmet.png" }
]

grupos.each do |grupo_data|
  file_path = Rails.root.join("app/assets/images/#{grupo_data[:imagen]}")
  imagen_file = File.exist?(file_path) ? File.open(file_path) : File.open(Rails.root.join("app/assets/images/logo.png"))

  grupo = Grupo.find_or_initialize_by(nombre: grupo_data[:nombre])
  grupo.imagen.attach(io: imagen_file, filename: grupo_data[:imagen]) unless grupo.imagen.attached?
  grupo.save!
  puts "✅ Grupo creado/actualizado: #{grupo.nombre}"
end

# =======================
# Productos
# =======================
productos = [
  # Hamburguesas
  { nombre: "Clásica", grupo: "Hamburguesa" },
  { nombre: "Mixta", grupo: "Hamburguesa" },
  { nombre: "Zona44", grupo: "Hamburguesa" }, # agregado de rama 298
  { nombre: "Burguer Mixta", grupo: "Hamburguesa" }, # agregado de rama 298

  # Perros calientes
  { nombre: "Perro sencillo", grupo: "Perro Caliente" },
  { nombre: "Perro con queso", grupo: "Perro Caliente" },
  { nombre: "Zona44", grupo: "Perro Caliente" }, # agregado de rama 298

  # Pizzas
  { nombre: "Hawaiana", grupo: "Pizza" },
  { nombre: "Mexicana", grupo: "Pizza" },

  # Salchipapas
  { nombre: "Sencilla", grupo: "Salchipapas" },
  { nombre: "Especial", grupo: "Salchipapas" }
]

productos.each do |producto_data|
  grupo = Grupo.find_by(nombre: producto_data[:grupo])
  if grupo
    producto = Producto.find_or_initialize_by(nombre: producto_data[:nombre], grupo: grupo)
    producto.save!
    puts "✅ Producto creado/actualizado: #{producto.nombre} (#{grupo.nombre})"
  else
    puts "⚠️ Grupo no encontrado para el producto: #{producto_data[:nombre]}"
  end
end

# =======================
# Adicionales
# =======================
adicionales = [
  # Base main
  { nombre: "Carne", precio: 3000 },
  { nombre: "Pollo", precio: 3000 },
  { nombre: "Tocineta", precio: 3000 },
  { nombre: "Salchicha", precio: 3000 },
  { nombre: "Maíz", precio: 2000 },
  { nombre: "Papas", precio: 2000 },
  { nombre: "Q. Mozzarella gratinado sencillo", precio: 2000 },
  { nombre: "Q. Mozzarella gratinado especial", precio: 3000 },
  { nombre: "Queso Cheddar", precio: 2000 },
  { nombre: "Huevo de codorniz", precio: 2000 },
  { nombre: "Salsa de la casa", precio: 1500 },
  { nombre: "Salsa tártara", precio: 1500 },
  { nombre: "Salsa BBQ", precio: 1500 },
  { nombre: "Salsa de ajo", precio: 1500 },

  # Extras de rama 298 (ajustados nombres)
  { nombre: "Queso Mozzarella", precio: 2000 }, # ya existía parecido
  { nombre: "Huevo de gallina", precio: 2000 }
]

adicionales.each do |adicional_data|
  adicional = Adicional.find_or_initialize_by(nombre: adicional_data[:nombre])
  adicional.precio = adicional_data[:precio]
  adicional.save!
  puts "✅ Adicional creado/actualizado: #{adicional.nombre} (#{adicional.precio})"
end
