class CareersController < ApplicationController
  def show
    @carrer = Career.friendly.find(params['id'])
  end
end
