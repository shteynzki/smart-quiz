class AddIndexesToLeads < ActiveRecord::Migration[8.1]
  def change
    add_index :leads, :phone
    add_index :leads, :created_at
    # Если в базе PostgreSQL, это ускорит поиск по ответам квиза
    add_index :leads, :answers, using: :gin
  end
end
