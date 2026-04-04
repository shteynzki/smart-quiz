class AddIndexesToLeads < ActiveRecord::Migration[8.1]
  def change
    add_index :leads, :phone
    add_index :leads, :created_at
    add_index :leads, :answers, using: :gin
  end
end
