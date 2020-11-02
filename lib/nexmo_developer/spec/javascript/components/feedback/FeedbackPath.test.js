import Vue from 'vue';
import { shallowMount, mount } from '@vue/test-utils';

import FeedbackPath from 'components/feedback/FeedbackPath.vue';
import Step from 'components/feedback/step/base.vue';

jest.mock('components/feedback/store');
import store from 'components/feedback/store';

describe('FeedbackPath', function() {
  const path = {
    question: "I found what I needed to know - thanks!",
    steps: [
      {
        title: "Thank You!",
        type: "textarea",
        content: "We’re glad you found what you were looking for.",
        label: "Anything we can improve on?",
        placeholder: "Hint text"
      },
      {
        title: "Thank You!",
        type: "plain",
        content: "We’re glad you found what you were looking for.",
        image: "/assets/images/done.svg"
      }
    ]
  };

  it('renders all the steps', function() {
    const wrapper = shallowMount(FeedbackPath, { propsData: { feedback_path: path }})

    expect(wrapper.findAllComponents(Step).length).toEqual(2);
    expect(wrapper.findAllComponents(Step).at(0).isVisible()).toBeTruthy();
    expect(wrapper.findAllComponents(Step).at(1).isVisible()).toBeFalsy();

    wrapper.destroy();
  });

  it('', async function() {
    const wrapper = mount(FeedbackPath, { propsData: { feedback_path: path }})

    await wrapper.find('textarea').setValue("Some random feedback");
    await wrapper.find('.Vlt-btn--secondary:not(.Vlt-modal__cancel)').trigger('click');

    expect(store.addStep).toHaveBeenCalledWith('Some random feedback');

    wrapper.destroy();
  });
});
