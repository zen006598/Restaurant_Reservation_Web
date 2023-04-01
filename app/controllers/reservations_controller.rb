class ReservationsController < ApplicationController
  before_action :find_restaurant, only: %i[new create]
  before_action :find_reservation_info, only: %i[new]
  before_action :find_reservation, only: %i[show edit update]
  
  def show
    @restaurant = @reservation.restaurant
  end

  def update
  end

  def edit
  end

  def new
    @reservation = Reservation.new
  end
  
  def create
    @reservation = @restaurant.reservations.new(reservation_params)
    if @reservation.save
      redirect_to @reservation
    else
      render :new
    end
  end

  private

  def find_restaurant
    @restaurant = Restaurant.find(params[:restaurant_id])
  end

  def reservation_params
    params.require(:reservation).permit(:name, :phone, :email, :gender, :comment, :arrival_time, :adult_quantity, :child_quantity)
  end

  def find_reservation_info
    @arrival_time = params[:arrival_time] 
    @child_quantity = params[:reservation][:child_quantity]
    @adult_quantity = params[:reservation][:adult_quantity]
    @table_type = params[:reservation][:table_type]
  end

  def find_reservation
    @reservation = Reservation.find(params[:id])
  end
end
