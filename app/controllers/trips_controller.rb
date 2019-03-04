class TripsController < ApplicationController

  def index
    @trip = Trip.new

    if params[:search].present?
      start_addresses_id = Address.near(params[:search][:start_address], 1).map(&:id)
      end_addresses_id = Address.near(params[:search][:end_address], 1).map(&:id)
      @trips = Trip.where(start_address_id: start_addresses_id, end_address_id: end_addresses_id)
    else
      @trips = Trip.all
    end
  end

  def show
    @trip = Trip.find(params[:id])
    @trips = Trip.where.not(start_address_id: nil, end_address_id: nil)
    @markers = @trips.map do |trip|
      {
        lng: trip.start_address.longitude,
        lat: trip.start_address.latitude
      }
    end
  end

  def search
  end

  def create
    @start_address = Address.create!(title: params[:search][:start_address], state: 0)
    @end_address = Address.create!(title: params[:search][:end_address], state: 1)
    @trip = Trip.new(transport: params[:search][:transport].last.to_i,
                     start_time: Time.now + 60 * params[:search][:start_time].last.to_i
                    )
    @trip.start_address = @start_address
    @trip.end_address = @end_address
    if @trip.save
      @booking = Booking.new(user_id: current_user.id, trip_id: @trip.id)
      if @booking.save
        redirect_to trips_path
      else
        render :index
      end
    else
      render :index
    end
  end

  private

  def trip_params
    # params[:transport] = params[:transport].to_i
    params.require(:search).permit(:transport, :start_time, :started)
  end
end


