
import Vue from 'vue';
import { shallowMount } from '@vue/test-utils';

import FieldSet from 'components/feedback/step/FieldSet.vue';

jest.mock('components/feedback/eventHub');
import eventHub from 'components/feedback/eventHub';

describe('Fieldset', function() {
  const step = {
    title: "Let's get you some help!",
    type: "fieldset",
    fields: [
      { "type": "input", "name": "name", "label": "Your name" },
      { "type": "input", "name": "companyName", "label": "Company Name" },
      { "type": "input", "name": "email", "label": "Your email" },
      { "type": "textarea", "name": "feedback", "label": "Please tell us how we can help you:", "placeholder": "Please leave feedback here" },
    ]
  };

  it('renders its content and corresponding buttons', function() {
    const wrapper = shallowMount(FieldSet, { propsData: { step: step, lastStep: false }})

    expect(wrapper.findAll('label').at(0).text()).toEqual(step.fields[0].label);
    expect(wrapper.findAll('label').at(1).text()).toEqual(step.fields[1].label);
    expect(wrapper.findAll('label').at(2).text()).toEqual(step.fields[2].label);

    expect(wrapper.find('input[name="name"]').exists()).toBeTruthy();
    expect(wrapper.find('input[name="companyName"]').exists()).toBeTruthy();
    expect(wrapper.find('textarea[name="feedback"]').exists()).toBeTruthy();
    expect(wrapper.find('textarea').attributes('placeholder')).toEqual(step.fields[3].placeholder);

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
      const wrapper = shallowMount(FieldSet, { propsData: { step: step, lastStep: true }})

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
    it('renders an error when the fields are empty', async function() {
      const wrapper = shallowMount(FieldSet, { propsData: { step: step, lastStep: false }})

      await wrapper.find('.Vlt-btn--secondary:not(.Vlt-modal__cancel)').trigger('click');
      expect(wrapper.find('.Vlt-form__element--error').exists()).toBeTruthy();
      expect(wrapper.find('.Vlt-form__element__error').text()).toEqual('These fields are required');

      wrapper.destroy();
    });

    it('emits next-step event when fields are filled in', async function() {
      const wrapper = shallowMount(FieldSet, { propsData: { step: step, lastStep: false } })

      await wrapper.find('input[name="name"]').setValue('John Doe');
      await wrapper.find('input[name="companyName"]').setValue('Vonage');
      await wrapper.find('input[name="email"]').setValue('john.doe@vonage.com');
      await wrapper.find('textarea').setValue('Some random feedback');

      await wrapper.find('.Vlt-btn--secondary:not(.Vlt-modal__cancel)').trigger('click');
      expect(wrapper.find('.Vlt-form__element--error').exists()).toBeFalsy();
      expect(eventHub.$emit).toHaveBeenCalledWith(
        'next-step',
        { name: 'John Doe', companyName: 'Vonage', feedback: 'Some random feedback', email: 'john.doe@vonage.com' }
      );
      expect(wrapper.emitted()).toBeTruthy();

      wrapper.destroy();
    });
  });
});
