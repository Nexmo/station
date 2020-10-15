<template>
  <div class="Vlt-modal__panel">
    <div class="Vlt-modal__dismiss" v-on:click="reset"></div>
    <div class="Vlt-modal__header" v-if="!showSteps">
      <span>Feedback</span>
      <h4 class="Vlt-modal__title">{{title}}</h4>
    </div>

    <div class="Vlt-modal__content">
      <feedback-path v-bind:feedback_path="selectedPath" v-if="showSteps"/>
      <div v-show="!showSteps" class="paths Vlt-form__element" v-bind:class="{ 'Vlt-form__element--error': hasError }">
        <div v-for="(path, index) in paths" class="radio-button Vlt-radio">
          <label :for=index>
            <span class="Vlt-radio__button">
              <input name="feedbackPath" type="radio" :id=index :value=index v-model="currentPathIndex">
              <span class="Vlt-radio__icon"></span>
            </span>
            {{path.question}}
          </label>
        </div>

        <small v-if="hasError" class="Vlt-form__element__error">This field is required</small>
        <button class="Vlt-btn Vlt-btn--app Vlt-btn--tertiary Vlt-modal__cancel" v-on:click="reset">Cancel</button>
        <button class="Vlt-btn Vlt-btn--app Vlt-btn--secondary" v-on:click="onPathSelection">Continue</button>
      </div>
    </div>
  </div>
</template>
<script>

import FeedbackPath from './FeedbackPath.vue';
import eventHub from './eventHub';

export default {
  props: ['paths', 'title'],
  components: { FeedbackPath },
  data: function() {
    return {
      currentPathIndex: null,
      selected: false,
      cancelText: 'Cancel',
      hasError: false,
    }
  },
  computed: {
    showSteps: function() {
      return this.currentPathIndex !== null && this.selected;
    },
    selectedPath: function() {
      return this.paths[this.currentPathIndex];
    },
  },
  methods: {
    onPathSelection: function() {
      if (this.$el.querySelector('input[type="radio"][name="feedbackPath"]:checked') !== null) {
        this.hasError = false;
        this.selected = true;
      } else {
        this.hasError = true;
      }
    },
    reset: function() {
      this.selected = false;
      this.hasError = false;
      this.currentPathIndex = null;
      Array.from(document.getElementsByClassName('Vlt-modal_visible'), function(modal) {
        modal.classList.remove('Vlt-modal_visible');
      })
      return false;
    }
  },
  mounted: function() {
    eventHub.$on('reset-modal', this.reset);
  }
}
</script>
<style scoped>
  .radio-button {
    margin-bottom: 11px;
  }
  .Vlt-modal__panel {
    padding: 0px;
    width: auto;
  }
  .Vlt-modal__header {
    padding: 32px 32px 0 32px;
  }
  .Vlt-modal__title {
    margin: auto;
    white-space: pre-line;
  }
  .Vlt-modal__content {
    padding: 0px;
  }
  .paths {
    padding: 32px;
    @media only screen and (min-width: 575px) {
      min-width: 500px;
    };
  }
</style>
