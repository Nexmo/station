require 'rails_helper'

# RSpec.describe Blog::AuthorsController, type: :controller do
#   # describe 'GET index' do
#   #   it 'returns a 200 HTTP code' do
#   #     get :index
#   #     expect(response).to have_http_status(:ok)
#   #   end

#   #   it 'renders the index template' do
#   #     get :index
#   #     expect(response).to render_template(:index)
#   #   end
#   # end

#   describe 'GET show' do
#     context "with author that exists" do
#       let(:author) { 'abdul-ajetunmobi'}

#       it 'returns a 200 HTTP code' do
#         get :show, :params => { name: author }
#         expect(response).to have_http_status(:ok)
#       end

#       it 'renders the show template' do
#         get :show, :params => { name: author }
#         expect(response).to render_template(:show)
#       end
#     end

#     context "with author that does not exist" do
#       let(:author) { 'joe-bloggs'}

#       it 'returns a 404 HTTP code' do
#         get :show, :params => { name: author }
#         expect(response).to have_http_status(404)
#       end

#       # it 'renders the custom 404 template' # TODO: change once we have the custom 404 page
#       it 'renders the show template' do
#         get :show, :params => { name: author }
#         expect(response).to render_template("static/404")
#       end

#     end
#   end
# end
