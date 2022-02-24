require 'rails_helper'

RSpec.describe 'blogpost route', type: :routing do
  describe 'blogpost#show' do
    it 'routes /blog/:year/:month/:day/:blog_path/' do
      expect(get('/blog/2021/12/25/santa-is-here'))
        .to route_to(controller: 'blog/blogpost', action: 'show', year: '2021', month: '12', day: '25', blog_path: 'santa-is-here')
    end
  end
end
