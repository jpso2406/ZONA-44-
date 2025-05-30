json.extract! producto, :id, :name, :descripcion, :precios, :created_at, :updated_at
json.url producto_url(producto, format: :json)
