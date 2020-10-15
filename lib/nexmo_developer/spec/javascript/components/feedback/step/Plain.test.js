import Vue from 'vue';
import { shallowMount } from '@vue/test-utils';

import Plain from 'components/feedback/step/Plain.vue';

describe('Plain', function() {
  const step = { content: 'Some content', type: 'plain' };

  it('renders its content and corresponding buttons', function() {
    const wrapper = shallowMount(Plain, { propsData: { step: step, lastStep: false }})

    expect(wrapper.find('p.content').text()).toEqual(step.content);

    expect(wrapper.find('.Vlt-btn--tertiary').text()).toEqual('Cancel');
    expect(wrapper.find('.Vlt-btn--tertiary').isVisible()).toBeTruthy();

    expect(wrapper.find('.Vlt-btn--secondary.Vlt-modal__cancel').text()).toEqual('Close');
    expect(wrapper.find('.Vlt-btn--secondary.Vlt-modal__cancel').isVisible()).toBeFalsy();

    wrapper.destroy();
  });

  describe('when it is the last step', function() {
    it('renders the close button', function() {
      const wrapper = shallowMount(Plain, { propsData: { step: step, lastStep: true }})

      expect(wrapper.find('p.content').text()).toEqual(step.content);

      expect(wrapper.find('.Vlt-btn--tertiary').text()).toEqual('Cancel');
      expect(wrapper.find('.Vlt-btn--tertiary').isVisible()).toBeFalsy();

      expect(wrapper.find('.Vlt-btn--secondary.Vlt-modal__cancel').text()).toEqual('Close');
      expect(wrapper.find('.Vlt-btn--secondary.Vlt-modal__cancel').isVisible()).toBeTruthy();

      wrapper.destroy();
    });
  });
});
