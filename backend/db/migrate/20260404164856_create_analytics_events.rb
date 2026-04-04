class CreateAnalyticsEvents < ActiveRecord::Migration[8.1]
  def change
    create_table :analytics_events do |t|
      t.string :event_type
      t.string :session_id
      t.jsonb :payload

      t.timestamps
    end
  end
end
