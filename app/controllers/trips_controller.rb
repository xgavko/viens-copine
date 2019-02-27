class TripsController < ApplicationController

  def search
  end

  def index
    @trip = Trip.new
  end

  def create
    @trip = Trip.new(trip_params)
   @trip.user = current_user
   if @trip.save
    redirect_to trips_path
    else
      render :new
    end
  end
end

  private

  def trip_params
    # params[:transport] = params[:transport].to_i
    params.require(:trip).permit(:transport, :start_time, :end_address, :started, :created_at, :updated_at)

   end

end


