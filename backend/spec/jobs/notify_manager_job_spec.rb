require 'rails_helper'

RSpec.describe NotifyManagerJob, type: :job do
  include ActiveJob::TestHelper

  before do
    ActiveJob::Base.queue_adapter = :test
  end

  it 'успешно ставит задачу в очередь default' do
    expect {
      NotifyManagerJob.perform_later(1)
    }.to have_enqueued_job.on_queue('default')
  end
end