<template>
  <fieldset>
    <div class="Vlt-form-element" v-bind:class="{ 'Vlt-form__element--error': hasError }">
      <div v-for="field in step.fields">
        <label class="Vlt-label" v-if="field.label !== undefined">{{field.label}}</label>
        <div v-if="field.type === 'input'" class="Vlt-input">
          <input :name="field.name" v-model="$data[field.name]"></input>
          <small class="Vlt-form__element__hint" v-if="field.hint !== undefined">{{field.hint}}</small>
        </div>
        <div v-else-if="field.type === 'textarea'" class="Vlt-textarea">
          <textarea :name="field.name" v-model="$data[field.name]" rows="5" :placeholder="field.placeholder"></textarea>
        </div>
        <div v-else></div>
      </div>

      <small v-if="hasError"class="Vlt-form__element__error">These fields are required</small>
      <button v-show="!lastStep" class="Vlt-btn Vlt-btn--app Vlt-btn--tertiary Vlt-modal__cancel" v-on:click="reset">Cancel</button>
      <button v-show="lastStep" class="Vlt-btn Vlt-btn--app Vlt-btn--secondary Vlt-modal__cancel" v-on:click="reset">Close</button>
      <button v-show="!lastStep" class="Vlt-btn Vlt-btn--app Vlt-btn--secondary" v-on:click="validate">Continue</button>
    </div>
  </fieldset>
</template>
<script>

import eventHub from '../eventHub';

export default {
  props: ['step', 'lastStep'],
  data: function() {
    return {
      firstName: '',
      lastName: '',
      companyName: '',
      apiKey: '',
      feedback: '',
      hasError: false,
    }
  },
  computed: {
    answer: function() {
      return {
        firstName: this.firstName,
        lastName: this.lastName,
        companyName: this.companyName,
        apiKey: this.apiKey,
        feedback: this.feedback
      };
    }
  },
  methods: {
    resetFields: function() {
      this.firstName = '';
      this.lastName = '';
      this.companyName = '';
      this.apiKey = '';
      this.feedback = '';
      this.hasError = false;
    },
    validate: function() {
      if (this.firstName === '' || this.lastName === '' || this.companyName === '' || this.apiKey === '' || this.feedback === '') {
        this.hasError = true;
      } else {
        this.hasError = false;
        eventHub.$emit('next-step', this.answer);
      }
    },
    reset: function() {
      eventHub.$emit('reset-modal');
    }
  },
  mounted: function() {
    eventHub.$on('reset-modal', this.resetFields);
  }
}
</script>
<style scoped>
  .content {
    white-space: pre-line;
    max-width: 434px;
  }
</style>
