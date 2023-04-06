require "rails_helper"

RSpec.describe ReservationMailer, type: :mailer do
  describe 'reservation email' do
    let!(:restaurant) { create(:restaurant, :skip_validate) }
    let!(:time_module){create(:time_module, day_of_week_list: (0..6).to_a, restaurant: restaurant)}
    let!(:business_time){create(:business_time, time_module: time_module)}
    let!(:reservation) { create(:reservation, restaurant: restaurant) }
    let(:mail){described_class.reservated_email(reservation).deliver}

    it '#send_email' do 
      expect(mail.subject).to eq("#{restaurant.name}'s reservation information.")
    end

    it 'renders the receiver email' do
      expect(mail.to).to eq([reservation.email])
    end

    it 'renders the sender email' do
      expect(mail.from).to eq(["WoDing@woding.com"])
    end

    it 'assigns @name' do
      expect(mail.body.encoded).to match(reservation.name)
    end

  end
end