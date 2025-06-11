json.extract! producto, :id, :name, :precio, :descripcion, :created_at, :updated_at
json.url producto_url(producto, format: :json)
