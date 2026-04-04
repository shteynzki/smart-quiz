class AddUtmToLeads < ActiveRecord::Migration[8.1]
  def change
    add_column :leads, :utm_source, :string unless column_exists?(:leads, :utm_source)
    add_column :leads, :utm_medium, :string unless column_exists?(:leads, :utm_medium)
    add_column :leads, :utm_campaign, :string unless column_exists?(:leads, :utm_campaign)
    add_column :leads, :utm_content, :string unless column_exists?(:leads, :utm_content)
    add_column :leads, :utm_term, :string unless column_exists?(:leads, :utm_term)
  end
end