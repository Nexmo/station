<template>
  <div class="wrapper">
    <p class="content">{{ step.content }}</p>
    <br>

    <div class="step-textarea Vlt-form__element" v-bind:class="{ 'Vlt-form__element--error': error }">
      <div class="Vlt-textarea" v-bind:class="{ 'step-textarea__no-content': step.content === undefined }">
        <label for="answer">{{ step.label }}</label>
        <textarea id="answer" :placeholder="step.placeholder" v-model="answer"></textarea>
      </div>
      <small v-if="error" class="Vlt-form__element__error">This field is required</small>
    </div>

    <button v-show="!lastStep" class="Vlt-btn Vlt-btn--app Vlt-btn--tertiary Vlt-modal__cancel" v-on:click="reset">Cancel</button>
    <button v-show="lastStep" class="Vlt-btn Vlt-btn--app Vlt-btn--secondary Vlt-modal__cancel" v-on:click="reset">Close</button>
    <button v-show="!lastStep" class="Vlt-btn Vlt-btn--app Vlt-btn--secondary" v-on:click="validate">Continue</button>
  </div>
</template>
<script>

import eventHub from '../eventHub';

export default {
  props: ['step', 'lastStep'],
  data: function() {
    return { answer: null, error: false };
  },
  methods: {
    resetFields: function() {
      this.answer = null;
      this.error = false;
    },
    reset: function() {
      eventHub.$emit('reset-modal');
    },
    validate: function() {
      if (this.answer === null || this.answer === '') {
        this.error = true;
      } else {
        this.error = false;
        eventHub.$emit('next-step');
      }
    }
  },
  mounted: function() {
    eventHub.$on('reset-modal', this.resetFields);
  }
}

</script>
<style scoped>
  .wrapper {
    flex-direction: column;
    max-width: 434px;
  }
  .content {
    white-space: pre-line;
  }
  .step-textarea {
    display: flex;
    flex-direction: column;
  }
  .step-textarea textarea {
    resize: none;
    max-width: 441px;
    height: 73px;
    margin-top: 11px;
  }
  .step-textarea__no-content textarea {
    height: 169px;
    @media only screen and (min-width: 576px) {
      width: 450px;
    };
  }
</style>
