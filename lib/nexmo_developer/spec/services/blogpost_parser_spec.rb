require 'rails_helper'

RSpec.describe BlogpostParser do

  context 'self.fetch_all' do
    it 'can load blogposts/blogposts_info.json' do
      expect(BlogpostParser.fetch_all).to_not eq(nil)
    end
  end

  context 'self.fetch_all_published' do
    it 'can load published blogposts from blogposts_info.json' do
      expect(BlogpostParser.fetch_all).to_not eq(BlogpostParser.fetch_all_published)
    end
  end

end
