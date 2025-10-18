# config/schedule.rb
# Tareas programadas con Whenever

# Ejecutar el job de limpieza de órdenes huérfanas cada 30 minutos
every 30.minutes do
  runner "CleanupOrdersJob.perform_later"
end
