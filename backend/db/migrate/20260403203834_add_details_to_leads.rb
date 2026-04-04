class AddDetailsToLeads < ActiveRecord::Migration[7.1]
  def change
    add_column :leads, :comment, :text unless column_exists?(:leads, :comment)
    add_column :leads, :page_url, :string unless column_exists?(:leads, :page_url)
  end
end
