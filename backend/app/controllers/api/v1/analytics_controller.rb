class Api::V1::AnalyticsController < ApplicationController
  def create
    AnalyticsEvent.create!(
      event_type: params[:event_type],
      session_id: params[:session_id] || request.remote_ip,
      payload: params[:payload] || {}
    )
    head :ok
  rescue => e
    render json: { error: e.message }, status: :unprocessable_entity
  end
end