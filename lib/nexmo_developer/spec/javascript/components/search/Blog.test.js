import { shallowMount } from '@vue/test-utils';
import Blog from 'components/search/Blog.vue';

describe('Blog', function() {
  const blog = {
    "title": "Vonage APIs rock!",
    "_snippetResult": { "description": { "value": "highlighted snippet" } },
    "_highlightResult": { "description": { "value": "highlighted snippet" } },
    "category": { "name": "Category name" },
    "link": "1/2/3/latest_blog"
  };

  it('renders the blog', function() {
    const wrapper = shallowMount(Blog, { propsData: { "hit": blog } });

    expect(wrapper.find('.Nxd-search__result__link').attributes().href).toEqual(
      'https://developer.vonage.com/1/2/3/latest_blog'
    );

    expect(wrapper.find('h6.Vlt-blue-dark').text()).toEqual('Vonage APIs rock!');

    expect(wrapper.find('.Nxd-search__result__highlight').text()).toEqual(
      '...highlighted snippet...'
    );

    expect(wrapper.find('.Nxd-search__badge').text()).toEqual('Category name');
  });
});
