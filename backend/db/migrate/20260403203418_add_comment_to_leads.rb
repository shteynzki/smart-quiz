class AddCommentToLeads < ActiveRecord::Migration[8.1]
  def change
    add_column :leads, :comment, :text
  end
end
