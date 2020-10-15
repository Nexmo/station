import Vue from 'vue';
import { shallowMount } from '@vue/test-utils';

import Feedback from 'components/feedback/Feedback.vue';
import FeedbackPath from 'components/feedback/FeedbackPath.vue';

describe('Feedback', function() {
  const title = "Great! Please let us know what you think:";
  const paths = [
    {
      "question": "I found what I needed to know - thanks!",
      "steps": [
        {
          "title": "Thank You!",
          "type": "textarea",
          "content": "We’re glad you found what you were looking for.",
          "label": "Anything we can improve on?",
          "placeholder": "Hint text"
        },
        {
          "title": "Thank You!",
          "type": "plain",
          "content": "We’re glad you found what you were looking for.",
          "image": "/assets/images/done.svg"
        }
      ]
    },
    {
      "question": "I don't understand any of this!",
      "steps": [
        {
          "title": "Sorry Charlie",
          "type": "plain",
          "content": "You need to be a software developer to use our APIs.",
          "image": "/assets/images/oops.svg"
        }
      ]
    }
  ];

  it('renders the different paths the user can take', function() {
    const wrapper = shallowMount(Feedback, { propsData: { paths: paths, title: title }})

    expect(wrapper.find("span").text()).toEqual("Feedback");
    expect(wrapper.find("h4").text()).toEqual("Great! Please let us know what you think:");

    expect(wrapper.findAll('.Vlt-radio').at(0).text()).toEqual("I found what I needed to know - thanks!")
    expect(wrapper.findAll('.Vlt-radio').at(1).text()).toEqual("I don't understand any of this!")

    wrapper.destroy();
  });

  describe('selecting a path', function() {
    it('renders an error when no path is selected', async function() {
      const wrapper = shallowMount(Feedback, { propsData: { paths: paths, title: title }})

      await wrapper.find('.Vlt-btn--secondary').trigger('click');
      expect(wrapper.find('.Vlt-form__element--error').exists()).toBeTruthy();
      expect(wrapper.find('.Vlt-form__element__error').text()).toEqual('This field is required');

      wrapper.destroy();
    });

    it('renders the selected path', async function() {
      const wrapper = shallowMount(Feedback, { propsData: { paths: paths, title: title }})

      wrapper.findAll('.Vlt-radio__icon').at(0).trigger('click');
      await wrapper.find('.Vlt-btn--secondary').trigger('click');
      expect(wrapper.findComponent(FeedbackPath).exists()).toBeTruthy();

      wrapper.destroy();
    });
  });
});
