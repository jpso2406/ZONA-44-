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
