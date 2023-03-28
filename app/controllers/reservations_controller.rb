class ReservationsController < ApplicationController
  def show
  end

  def update

  end

  def edit
  end

  def new
  end
  
  def create
  end

  def destroy
  end

  private

  def find_reservation
  end

  def reservation_params
    params.require(:reservation).permit(:serial, :name, :phone, :email, :gender, :comment, :arrival_time, :state, :adult_quantity, :child_quantity)
  end
end
