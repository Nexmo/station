require 'rails_helper'

RSpec.describe Blog::BlogpostController, type: :controller do
  describe 'GET index' do
    it 'returns a 200 HTTP code' do
      get :index
      expect(response).to have_http_status(:ok)
    end

    it 'renders the index template' do
      get :index
      expect(response).to render_template(:index)
    end
  end

  describe 'GET show' do
    context "with blogpost that exists" do
      let(:path) { '5-ways-to-build-a-node-js-api'}
      let(:year) { '20'}
      let(:month) { '08'}
      let(:day) { '20'}

      it 'returns a 200 HTTP code' do
        get :show, :params => { "year"=> year, "month"=> month, "day"=> day, blog_path: path }
        expect(response).to have_http_status(:ok)
      end

      it 'renders the show template' do
        get :show, :params => { "year"=> year, "month"=> month, "day"=> day, blog_path: path }
        expect(response).to render_template(:show)
      end
    end

    context "with blogpost that does not exist" do
      let(:path) { 'some-made-up-path'}

      # it 'returns a 404 HTTP code' do
      #   get :show, :params => { "year"=> year, "month"=> month, "day"=> day, blog_path: path }
      #   expect(response).to have_http_status(:not_found)
      # end

      # it 'renders the custom 404 template' # TODO: once we have the custom 404 page
    end
  end
end
