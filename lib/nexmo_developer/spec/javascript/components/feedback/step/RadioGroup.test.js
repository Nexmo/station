import Vue from 'vue';
import { shallowMount } from '@vue/test-utils';

import RadioGroup from 'components/feedback/step/RadioGroup.vue';

jest.mock('components/feedback/eventHub');
import eventHub from 'components/feedback/eventHub';

describe('RadioGroup', function() {
  const step = {
    title: "Thanks for letting us know!",
    type: "radiogroup",
    questions: [
      "The documentation is missing information.",
      "The documentation is unclear.",
      "The documentation is incorrect.",
      "There is a broken link.",
      "I don’t understand the terminology."
    ]
  };

  it('renders its content and corresponding buttons', function() {
    const wrapper = shallowMount(RadioGroup, { propsData: { step: step, lastStep: false }})

    expect(wrapper.find('.Vlt-radio:nth-of-type(1)').text()).toEqual(step.questions[0]);
    expect(wrapper.find('.Vlt-radio:nth-of-type(2)').text()).toEqual(step.questions[1]);
    expect(wrapper.find('.Vlt-radio:nth-of-type(3)').text()).toEqual(step.questions[2]);
    expect(wrapper.find('.Vlt-radio:nth-of-type(4)').text()).toEqual(step.questions[3]);
    expect(wrapper.find('.Vlt-radio:nth-of-type(5)').text()).toEqual(step.questions[4]);

    expect(wrapper.find('.Vlt-btn--tertiary').text()).toEqual('Cancel');
    expect(wrapper.find('.Vlt-btn--tertiary').isVisible()).toBeTruthy();

    expect(wrapper.find('.Vlt-btn--secondary.Vlt-modal__cancel').text()).toEqual('Close');
    expect(wrapper.find('.Vlt-btn--secondary.Vlt-modal__cancel').isVisible()).toBeFalsy();

    expect(wrapper.find('.Vlt-btn--secondary:not(.Vlt-modal__cancel)').text()).toEqual('Continue');
    expect(wrapper.find('.Vlt-btn--secondary:not(.Vlt-modal__cancel)').isVisible()).toBeTruthy();

    wrapper.destroy();
  });

  describe('when it is the last step', function() {
    it('renders the close button', function() {
      const wrapper = shallowMount(RadioGroup, { propsData: { step: step, lastStep: true }})

      expect(wrapper.find('.Vlt-btn--tertiary').text()).toEqual('Cancel');
      expect(wrapper.find('.Vlt-btn--tertiary').isVisible()).toBeFalsy();

      expect(wrapper.find('.Vlt-btn--secondary.Vlt-modal__cancel').text()).toEqual('Close');
      expect(wrapper.find('.Vlt-btn--secondary.Vlt-modal__cancel').isVisible()).toBeTruthy();

      expect(wrapper.find('.Vlt-btn--secondary:not(.Vlt-modal__cancel)').text()).toEqual('Continue');
      expect(wrapper.find('.Vlt-btn--secondary:not(.Vlt-modal__cancel)').isVisible()).toBeFalsy();

      wrapper.destroy();
    });
  });

  describe('clicking Continue', function() {
    it('renders an error when nothing was selected', async function() {
      const wrapper = shallowMount(RadioGroup, { propsData: { step: step, lastStep: false }})

      await wrapper.find('.Vlt-btn--secondary:not(.Vlt-modal__cancel)').trigger('click');
      expect(wrapper.find('.Vlt-form__element--error').exists()).toBeTruthy();
      expect(wrapper.find('.Vlt-form__element__error').text()).toEqual('This field is required');

      wrapper.destroy();
    });

    it('emits next-step event when something was selected', async function() {
      const wrapper = shallowMount(RadioGroup, { propsData: { step: step, lastStep: false } })

      await wrapper.findAll('input[type="radio"]').at(0).trigger('click')
      await wrapper.find('.Vlt-btn--secondary:not(.Vlt-modal__cancel)').trigger('click');
      expect(wrapper.find('.Vlt-form__element--error').exists()).toBeFalsy();
      expect(eventHub.$emit).toHaveBeenCalledWith('next-step', 0);
      expect(wrapper.emitted()).toBeTruthy();

      wrapper.destroy();
    });
  });
});
