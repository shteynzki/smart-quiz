class AnalyticsEvent < ApplicationRecord
  validates :event_type, presence: true
  validates :session_id, presence: true

  scope :quiz_starts, -> { where(event_type: "quiz_start") }
  scope :submissions, -> { where(event_type: "quiz_submit") }

  def self.stats
    group(:event_type).count
  end
end
