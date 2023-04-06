require 'rails_helper'

RSpec.describe ReservationJob, type: :job do
  include ActiveJob::TestHelper

  it "queue_as default" do
    expect(ReservationJob.new.queue_name).to eq("default")
  end

  describe "perform" do
    let!(:restaurant) { create(:restaurant, :skip_validate) }
    let!(:time_module){create(:time_module, day_of_week_list: (0..6).to_a, restaurant: restaurant)}
    let!(:business_time){create(:business_time, time_module: time_module)}
    let!(:reservation) { create(:reservation, restaurant: restaurant) }
    subject(:job) { described_class.perform_later(reservation) }

    it "queues the job" do
      expect { job }.to change(ActiveJob::Base.queue_adapter.enqueued_jobs, :size).by(1)
    end

    it 'is in default queue' do
      expect(ReservationJob.new.queue_name).to eq('default')
    end
  end
end
