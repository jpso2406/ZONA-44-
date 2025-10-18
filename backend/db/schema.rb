# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# This file is the source Rails uses to define your schema when running `bin/rails
# db:schema:load`. When creating a new database, `bin/rails db:schema:load` tends to
# be faster and is potentially less error prone than running all of your
# migrations from scratch. Old migrations may fail to apply correctly if those
# migrations use external dependencies or application code.
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema[8.0].define(version: 2025_10_18_042629) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "pg_catalog.plpgsql"

  create_table "active_storage_attachments", force: :cascade do |t|
    t.string "name", null: false
    t.string "record_type", null: false
    t.bigint "record_id", null: false
    t.bigint "blob_id", null: false
    t.datetime "created_at", null: false
    t.index ["blob_id"], name: "index_active_storage_attachments_on_blob_id"
    t.index ["record_type", "record_id", "name", "blob_id"], name: "index_active_storage_attachments_uniqueness", unique: true
  end

  create_table "active_storage_blobs", force: :cascade do |t|
    t.string "key", null: false
    t.string "filename", null: false
    t.string "content_type"
    t.text "metadata"
    t.string "service_name", null: false
    t.bigint "byte_size", null: false
    t.string "checksum"
    t.datetime "created_at", null: false
    t.index ["key"], name: "index_active_storage_blobs_on_key", unique: true
  end

  create_table "active_storage_variant_records", force: :cascade do |t|
    t.bigint "blob_id", null: false
    t.string "variation_digest", null: false
    t.index ["blob_id", "variation_digest"], name: "index_active_storage_variant_records_uniqueness", unique: true
  end

  create_table "adicional_tamanos", force: :cascade do |t|
    t.bigint "adicional_id", null: false
    t.bigint "tamano_pizza_id", null: false
    t.decimal "precio", precision: 8, scale: 2, null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["adicional_id", "tamano_pizza_id"], name: "index_adicional_tamanos_on_adicional_id_and_tamano_pizza_id", unique: true
    t.index ["adicional_id"], name: "index_adicional_tamanos_on_adicional_id"
    t.index ["tamano_pizza_id"], name: "index_adicional_tamanos_on_tamano_pizza_id"
  end

  create_table "adicionals", force: :cascade do |t|
    t.string "ingredientes"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "admins", force: :cascade do |t|
    t.string "email", default: "", null: false
    t.string "encrypted_password", default: "", null: false
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["email"], name: "index_admins_on_email", unique: true
    t.index ["reset_password_token"], name: "index_admins_on_reset_password_token", unique: true
  end

  create_table "borde_quesos", force: :cascade do |t|
    t.bigint "tamano_pizza_id", null: false
    t.decimal "precio", precision: 10, scale: 2
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["tamano_pizza_id"], name: "index_borde_quesos_on_tamano_pizza_id", unique: true
  end

  create_table "grupos", force: :cascade do |t|
    t.string "nombre"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "slug"
    t.index ["nombre"], name: "index_grupos_on_nombre", unique: true
    t.index ["slug"], name: "index_grupos_on_slug", unique: true
  end

  create_table "ingredientes", force: :cascade do |t|
    t.string "nombre"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "order_items", force: :cascade do |t|
    t.bigint "order_id", null: false
    t.bigint "producto_id", null: false
    t.integer "quantity", default: 1, null: false
    t.decimal "unit_price", precision: 10, scale: 2, null: false
    t.decimal "total_price", precision: 10, scale: 2, null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["order_id", "producto_id"], name: "index_order_items_on_order_id_and_producto_id"
    t.index ["order_id"], name: "index_order_items_on_order_id"
    t.index ["producto_id"], name: "index_order_items_on_producto_id"
  end

  create_table "orders", force: :cascade do |t|
    t.string "customer_name", null: false
    t.string "customer_email", null: false
    t.string "customer_phone"
    t.decimal "total_amount", precision: 10, scale: 2, null: false
    t.string "status", default: "pending"
    t.string "reference", null: false
    t.string "payu_order_id"
    t.text "notes"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "payment_method"
    t.string "payu_transaction_id"
    t.text "payu_response"
    t.string "order_number"
    t.string "delivery_type", default: "domicilio", null: false
    t.integer "estimated_time"
    t.bigint "user_id"
    t.string "customer_address"
    t.string "customer_city"
    t.index ["customer_email"], name: "index_orders_on_customer_email"
    t.index ["reference"], name: "index_orders_on_reference", unique: true
    t.index ["status"], name: "index_orders_on_status"
    t.index ["user_id"], name: "index_orders_on_user_id"
  end

  create_table "password_resets", force: :cascade do |t|
    t.bigint "user_id", null: false
    t.string "code", null: false
    t.datetime "expires_at", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["code"], name: "index_password_resets_on_code", unique: true
    t.index ["user_id"], name: "index_password_resets_on_user_id"
  end

  create_table "payment_transactions", force: :cascade do |t|
    t.bigint "order_id", null: false
    t.string "transaction_id", null: false
    t.string "payu_transaction_id"
    t.string "status", default: "pending"
    t.string "response_code"
    t.string "payment_method"
    t.decimal "amount", precision: 10, scale: 2, null: false
    t.string "currency", default: "COP"
    t.text "response_data"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["order_id"], name: "index_payment_transactions_on_order_id"
    t.index ["payu_transaction_id"], name: "index_payment_transactions_on_payu_transaction_id"
    t.index ["status"], name: "index_payment_transactions_on_status"
    t.index ["transaction_id"], name: "index_payment_transactions_on_transaction_id", unique: true
  end

  create_table "pizza_combinadas", force: :cascade do |t|
    t.string "nombre"
    t.text "descripcion"
    t.string "categoria"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.boolean "activo", default: true
  end

  create_table "pizza_especiales", force: :cascade do |t|
    t.string "nombre"
    t.text "descripcion"
    t.string "categoria"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.boolean "activo", default: true
    t.bigint "grupo_id"
    t.index ["grupo_id"], name: "index_pizza_especiales_on_grupo_id"
  end

  create_table "pizza_tamanos", force: :cascade do |t|
    t.bigint "pizza_tradicional_id"
    t.bigint "pizza_especial_id"
    t.bigint "pizza_combinada_id"
    t.bigint "tamano_pizza_id", null: false
    t.decimal "precio", precision: 10, scale: 2
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["pizza_combinada_id", "tamano_pizza_id"], name: "index_pizza_tamanos_combinada", unique: true, where: "(pizza_combinada_id IS NOT NULL)"
    t.index ["pizza_combinada_id"], name: "index_pizza_tamanos_on_pizza_combinada_id"
    t.index ["pizza_especial_id", "tamano_pizza_id"], name: "index_pizza_tamanos_especial", unique: true, where: "(pizza_especial_id IS NOT NULL)"
    t.index ["pizza_especial_id"], name: "index_pizza_tamanos_on_pizza_especial_id"
    t.index ["pizza_tradicional_id", "tamano_pizza_id"], name: "index_pizza_tamanos_tradicional", unique: true, where: "(pizza_tradicional_id IS NOT NULL)"
    t.index ["pizza_tradicional_id"], name: "index_pizza_tamanos_on_pizza_tradicional_id"
    t.index ["tamano_pizza_id"], name: "index_pizza_tamanos_on_tamano_pizza_id"
  end

  create_table "pizza_tradicionales", force: :cascade do |t|
    t.string "nombre"
    t.text "descripcion"
    t.string "categoria"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.boolean "activo", default: true
    t.bigint "grupo_id"
    t.index ["grupo_id"], name: "index_pizza_tradicionales_on_grupo_id"
  end

  create_table "pizzas", force: :cascade do |t|
    t.string "nombre"
    t.string "descripcion"
    t.decimal "precio"
    t.integer "tamano"
    t.boolean "borde_queso"
    t.integer "tipo_pizza"
    t.bigint "adicional_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["adicional_id"], name: "index_pizzas_on_adicional_id"
  end

  create_table "producto_adicionales", force: :cascade do |t|
    t.bigint "producto_id", null: false
    t.bigint "adicional_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["adicional_id"], name: "index_producto_adicionales_on_adicional_id"
    t.index ["producto_id"], name: "index_producto_adicionales_on_producto_id"
  end

  create_table "producto_ingredientes", force: :cascade do |t|
    t.bigint "producto_id", null: false
    t.bigint "ingrediente_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["ingrediente_id"], name: "index_producto_ingredientes_on_ingrediente_id"
    t.index ["producto_id"], name: "index_producto_ingredientes_on_producto_id"
  end

  create_table "productos", force: :cascade do |t|
    t.string "name"
    t.integer "precio"
    t.string "descripcion"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.bigint "grupo_id"
    t.index ["grupo_id"], name: "index_productos_on_grupo_id"
  end

  create_table "promociones", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "nombre"
    t.decimal "precio_total"
    t.decimal "precio_original"
    t.decimal "descuento"
    t.bigint "producto_id", null: false
    t.index ["producto_id"], name: "index_promociones_on_producto_id"
  end

  create_table "tamano_pizzas", force: :cascade do |t|
    t.string "nombre"
    t.integer "slices"
    t.integer "tamano_cm"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "users", force: :cascade do |t|
    t.string "email", default: "", null: false
    t.string "encrypted_password", default: "", null: false
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "role", default: 0, null: false
    t.string "document_type"
    t.string "document_number"
    t.string "first_name"
    t.string "last_name"
    t.date "birthdate"
    t.string "phone"
    t.string "department"
    t.string "city"
    t.string "address"
    t.string "api_token"
    t.string "provider"
    t.string "uid"
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
  end

  add_foreign_key "active_storage_attachments", "active_storage_blobs", column: "blob_id"
  add_foreign_key "active_storage_variant_records", "active_storage_blobs", column: "blob_id"
  add_foreign_key "adicional_tamanos", "adicionals"
  add_foreign_key "adicional_tamanos", "tamano_pizzas"
  add_foreign_key "borde_quesos", "tamano_pizzas"
  add_foreign_key "order_items", "orders"
  add_foreign_key "order_items", "productos"
  add_foreign_key "orders", "users"
  add_foreign_key "password_resets", "users"
  add_foreign_key "payment_transactions", "orders"
  add_foreign_key "pizza_tamanos", "pizza_combinadas"
  add_foreign_key "pizza_tamanos", "pizza_especiales", column: "pizza_especial_id"
  add_foreign_key "pizza_tamanos", "pizza_tradicionales", column: "pizza_tradicional_id"
  add_foreign_key "pizza_tamanos", "tamano_pizzas"
  add_foreign_key "pizzas", "adicionals"
  add_foreign_key "producto_adicionales", "adicionals"
  add_foreign_key "producto_adicionales", "productos"
  add_foreign_key "producto_ingredientes", "ingredientes"
  add_foreign_key "producto_ingredientes", "productos"
  add_foreign_key "productos", "grupos"
  add_foreign_key "promociones", "productos"
end
