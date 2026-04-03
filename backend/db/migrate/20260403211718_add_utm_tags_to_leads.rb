class AddUtmTagsToLeads < ActiveRecord::Migration[8.1]
  def change
    add_column :leads, :utm_source, :string
    add_column :leads, :utm_medium, :string
    add_column :leads, :utm_campaign, :string
  end
end
