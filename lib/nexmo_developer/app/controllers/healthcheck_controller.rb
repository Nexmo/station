class HealthcheckController < ApplicationController
  def ping
    respond_to do |format|
      format.html { render plain: 'OK', status: :ok }
      format.json { render json: { ping: 'OK' }, status: :ok }
    end
  end
end
