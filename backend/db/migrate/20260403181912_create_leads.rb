class CreateLeads < ActiveRecord::Migration[8.1]
  def change
    create_table :leads do |t|
      t.string :name
      t.string :phone
      t.string :email
      t.jsonb :answers

      t.timestamps
    end
  end
end
