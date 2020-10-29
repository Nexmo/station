import Vue from 'vue';
import { shallowMount } from '@vue/test-utils';

import TextArea from 'components/feedback/step/TextArea.vue';

jest.mock('components/feedback/eventHub');
import eventHub from 'components/feedback/eventHub';

describe('TextArea', function() {
  const step = { content: 'Some content', type: 'textarea', label: 'Anything we can improve on?', placeholder: 'Hint text', email: true };

  it('renders its content and corresponding buttons', function() {
    const wrapper = shallowMount(TextArea, { propsData: { step: step, lastStep: false }})

    expect(wrapper.find('p.content').text()).toEqual(step.content);
    expect(wrapper.findAll('label').at(1).text()).toEqual(step.label);
    expect(wrapper.find('textarea').attributes('placeholder')).toEqual(step.placeholder);

    expect(wrapper.find('input[type="email"]').exists()).toBeTruthy();

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
      const wrapper = shallowMount(TextArea, { propsData: { step: step, lastStep: true }})

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
    it('renders an error when the textarea is empty', async function() {
      const wrapper = shallowMount(TextArea, { propsData: { step: step, lastStep: false }})

      await wrapper.find('.Vlt-btn--secondary:not(.Vlt-modal__cancel)').trigger('click');
      expect(wrapper.find('.Vlt-form__element--error').exists()).toBeTruthy();
      expect(wrapper.find('.Vlt-form__element__error').text()).toEqual('This field is required');

      wrapper.destroy();
    });

    it('emits next-step event when textarea is not empty', async function() {
      const wrapper = shallowMount(TextArea, { propsData: { step: step, lastStep: false } })

      await wrapper.find('textarea').setValue("Some random feedback");
      await wrapper.find('.Vlt-btn--secondary:not(.Vlt-modal__cancel)').trigger('click');
      expect(wrapper.find('.Vlt-form__element--error').exists()).toBeFalsy();

      expect(eventHub.$emit).toHaveBeenCalledWith('next-step', 'Some random feedback');
      expect(wrapper.emitted()).toBeTruthy();

      wrapper.destroy();
    });
  });
});
