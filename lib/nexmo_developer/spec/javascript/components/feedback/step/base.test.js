import Vue from 'vue';
import { shallowMount } from '@vue/test-utils';

import Base from 'components/feedback/step/Base.vue';
import TextArea from 'components/feedback/step/TextArea.vue';
import RadioGroup from 'components/feedback/step/RadioGroup.vue';
import Plain from 'components/feedback/step/Plain.vue';
import FieldSet from 'components/feedback/step/FieldSet.vue';

describe('Base', function() {
  describe('rendering a Plain step', function() {
    describe('with an image', function() {
      const step = {
        title: 'Awesome step title',
        type: 'plain',
        image: '/assets/images/oops.svg'
      };

      it('renders the Plain component and the image', function() {
        const wrapper = shallowMount(Base, { propsData: { step: step, lastStep: false }})

        expect(wrapper.find('h4').text()).toEqual('Awesome step title');
        expect(wrapper.find('img[src="/assets/images/oops.svg"]').exists()).toBe(true);
        expect(wrapper.findComponent(Plain).exists()).toBe(true);

        wrapper.destroy();
      });
    });

    describe('without an image', function() {
      const step = {
        title: 'Awesome step title',
        type: 'plain'
      };

      it('renders the Plain component and no image', function() {
        const wrapper = shallowMount(Base, { propsData: { step: step, lastStep: false }})

        expect(wrapper.find('span').text()).toEqual('Feedback');
        expect(wrapper.find('h4').text()).toEqual('Awesome step title');
        expect(wrapper.find('img').exists()).toBe(false);
        expect(wrapper.findComponent(Plain).exists()).toBe(true);

        wrapper.destroy();
      });
    });
  });

  describe('rendering a fieldset', function() {
    const step = {
      title: 'Awesome step title',
      type: 'fieldset'
    };

    it('renders the FieldSet component', function() {
      const wrapper = shallowMount(Base, { propsData: { step: step, lastStep: false }})

      expect(wrapper.find('span').text()).toEqual('Feedback');
      expect(wrapper.find('h4').text()).toEqual('Awesome step title');
      expect(wrapper.find('img').exists()).toBe(false);
      expect(wrapper.findComponent(FieldSet).exists()).toBe(true);

      wrapper.destroy();
    });
  });

  describe('rendering a radiogroup', function() {
    const step = {
      title: 'Awesome step title',
      type: 'radiogroup'
    };

    it('renders the RadioGroup component', function() {
      const wrapper = shallowMount(Base, { propsData: { step: step, lastStep: false }})

      expect(wrapper.find('span').text()).toEqual('Feedback');
      expect(wrapper.find('h4').text()).toEqual('Awesome step title');
      expect(wrapper.find('img').exists()).toBe(false);
      expect(wrapper.findComponent(RadioGroup).exists()).toBe(true);

      wrapper.destroy();
    });
  });

  describe('rendering a textarea', function() {
    const step = {
      title: 'Awesome step title',
      type: 'textarea'
    };

    it('renders the TextArea component', function() {
      const wrapper = shallowMount(Base, { propsData: { step: step, lastStep: false }})

      expect(wrapper.find('span').text()).toEqual('Feedback');
      expect(wrapper.find('h4').text()).toEqual('Awesome step title');
      expect(wrapper.find('img').exists()).toBe(false);
      expect(wrapper.findComponent(TextArea).exists()).toBe(true);

      wrapper.destroy();
    });
  });

  describe('rendering something else', function() {
    const step = {
      title: 'Awesome step title',
      type: 'other'
    };

    it('renders the title', function() {
      const wrapper = shallowMount(Base, { propsData: { step: step, lastStep: false }})

      expect(wrapper.find('span').text()).toEqual('Feedback');
      expect(wrapper.find('h4').text()).toEqual('Awesome step title');
      expect(wrapper.find('img').exists()).toBe(false);

      wrapper.destroy();
    });
  });
});
