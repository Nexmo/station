require 'rails_helper'

# RSpec.describe Blog::CategoriesController, type: :controller do
#   describe 'GET show' do
#     context "with category that exists" do
#       let(:category) { 'tutorial'}

#       it 'returns a 200 HTTP code' do
#         get :show, :params => { slug: category }
#         expect(response).to have_http_status(:ok)
#       end

#       it 'renders the show template' do
#         get :show, :params => { slug: category }
#         expect(response).to render_template(:show)
#       end
#     end

#     context "with category that does not exist" do
#       let(:category) { 'some-made-up-category'}

#       # it 'returns a 404 HTTP code' do
#       #   get :show, :params => { slug: category }
#       #   expect(response).to have_http_status(:not_found)
#       # end

#       # it 'renders the custom 404 template' # TODO: once we have the custom 404 page
#     end
#   end
# end
