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

        <small v-if="hasError"class="Vlt-form__element__error">This field is required</small>
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
  props: [],
  components: { FeedbackPath },
  data: function() {
    return {
      title: "Great! Please let us know what you think:",
      currentPathIndex: null,
      selected: false,
      cancelText: 'Cancel',
      hasError: false,
      paths: [
        {
          "question": "I found what I needed to know - thanks!",
          "steps": [
            {
              "title": "Thank You!",
              "type": "textarea",
              "content": "We’re glad you found what you were looking for.\n\nWe’re always trying to improve our documentation and feedback like yours helps us know when we are on the right track!",
              "label": "Anything we can improve on?",
              "placeholder": "Hint text"
            },
            {
              "title": "Thank You!",
              "type": "plain",
              "content": "We’re glad you found what you were looking for.\n\nWe’re always trying to improve our documentation and feedback like yours helps us know when we are on the right track!",
              "image": "/assets/images/done.svg"
            }
          ]
        },
        {
          "question": "There is a problem with the documentation.",
          "steps": [
            {
              "title": "Thanks for letting us know!\nPlease, tell us more:",
              "type": "radiogroup",
              "questions": [
                "The documentation is missing information.",
                "The documentation is unclear.",
                "The documentation is incorrect.",
                "There is a broken link.",
                "I don’t understand the terminology."
              ]
            },
            {
              "title": "What have we left out?",
              "type": "textarea",
              "placeholder": "Please leave feedback here"
            },
            {
              "title": "Thank You!",
              "type": "plain",
              "content": "We have recorded your feedback. Feedback like yours will help us better serve your needs in the future, and it’s much appreciated!",
              "image": "/assets/images/programming.svg"
            }
          ]
        },
        {
          "question": "I am having problems with the sample code.",
          "steps": [
            {
              "title": "Sorry you’re having trouble. What’s wrong?",
              "type": "radiogroup",
              "questions": [
                "The sample code doesn’t work.",
                "The sample code isn’t helpful.",
                "The sample(s) I was expecting to see are missing."
              ]
            },
            {
              "title": "Please help us help you by providing details.",
              "type": "textarea",
              "placeholder": "Please leave feedback here"
            },
            {
              "title": "Thank You!",
              "type": "plain",
              "content": "We have recorded your feedback. Feedback like yours will help us better serve your needs in the future, and it’s much appreciated!",
              "image": "/assets/images/programming.svg"
            }
          ]
        },
        {
          "question": "I need help with something else.",
          "steps": [
            {
              "title": "What do you need help with?",
              "type": "radiogroup",
              "questions": [
                "My account/billing.",
                "The capabilities of the product.",
                "Something else."
              ]
            },
            {
              "title": "Let's get you some help!",
              "type": "fieldset",
              "fields": [
                { "type": "input", "name": "firstName", "label": "First name" },
                { "type": "input", "name": "lastName", "label": "Last name" },
                { "type": "input", "name": "companyName", "label": "Company Name" },
                { "type": "input", "name": "apiKey", "label": "API Key", "hint": "(Hint: You can find this in the Developer Dashboard at https://dashboard.nexmo.com)" },
                { "type": "textarea", "name": "feedback", "label": "Please tell us how we can help you:", "placeholder": "Please leave feedback here" },
              ]
            },
            {
              "title": "Thank You!",
              "type": "plain",
              "content": "We have recorded your feedback and will get back to you as soon as we can.",
              "image": "/assets/images/productive-work.svg"
            }
          ]
        },
        {
          "question": "I don’t understand any of this!",
          "steps": [
            {
              "title": "Sorry Charlie",
              "type": "plain",
              "content": "You need to be a software developer to use our APIs.\n\nFor more information, see: https://www.vonage.co.uk/communications-apis/platform",
              "image": "/assets/images/oops.svg"
            }
          ]
        }
      ]
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
