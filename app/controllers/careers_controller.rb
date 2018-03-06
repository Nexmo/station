class CareersController < ApplicationController
  def show
    @carrer = Career.find(params['id'])
  end
end
