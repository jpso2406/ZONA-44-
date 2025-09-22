RouteTranslator.config do |config|
  config.force_locale = true  # Obliga a que siempre se incluya el locale en la URL (ej: /es/productos)
  config.generate_unlocalized_routes = true  # Opcional: genera rutas sin el locale (ej: /productos)
end
