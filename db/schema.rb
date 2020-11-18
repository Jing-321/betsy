# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# This file is the source Rails uses to define your schema when running `rails
# db:schema:load`. When creating a new database, `rails db:schema:load` tends to
# be faster and is potentially less error prone than running all of your
# migrations from scratch. Old migrations may fail to apply correctly if those
# migrations use external dependencies or application code.
#
# It's strongly recommended that you check this file into your version control system.

<<<<<<< HEAD
ActiveRecord::Schema.define(version: 2020_11_18_024735) do
=======

ActiveRecord::Schema.define(version: 2020_11_18_203003) do

>>>>>>> c475389600634657c8d0fa5007eccbbad01bcf72

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

<<<<<<< HEAD
  create_table "products", force: :cascade do |t|
    t.string "name"
    t.string "description"
    t.integer "price"
    t.integer "stock"
    t.integer "order_item_id"
    t.integer "review_id"
    t.integer "category_id"
=======

  create_table "categories", force: :cascade do |t|
    t.string "name"
>>>>>>> c475389600634657c8d0fa5007eccbbad01bcf72
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

<<<<<<< HEAD
  create_table "users", force: :cascade do |t|
    t.string "username"
    t.string "email"
    t.integer "order_id"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

=======
  create_table "orders", force: :cascade do |t|
    t.string "status", default: "pending"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.bigint "user_id"
    t.index ["user_id"], name: "index_orders_on_user_id"
  end
>>>>>>> c475389600634657c8d0fa5007eccbbad01bcf72
end
