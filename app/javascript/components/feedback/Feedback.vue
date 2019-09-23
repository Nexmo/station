<template>
  <div class="Vlt-box Vlt-box--left feedback">
    <div class="Vlt-grid">
      <div class="Vlt-col Vlt-col--3of4">
        <h5>Was this documentation helpful?</h5>

        <div class="sentiments">
          <div v-if="uploadingSentiment">
            <div class="Vlt-spinner Vlt-spinner--small"></div>
          </div>
          <div>
            <span v-on:click="setSentiment('positive')" v-bind:class="[{ 'Vlt-btn_active': sentiment == 'positive' }, 'Vlt-btn Vlt-btn--large Vlt-btn--tertiary Vlt-btn--icon']">
              <svg class="Vlt-green"><use xlink:href="/symbol/volta-icons.svg#Vlt-icon-happy"/></svg>
            </span>
            <span v-on:click="setSentiment('negative')" v-bind:class="[{ 'Vlt-btn_active': sentiment == 'negative' }, 'Vlt-btn Vlt-btn--large Vlt-btn--tertiary Vlt-btn--icon']">
              <svg class="Vlt-red"><use xlink:href="/symbol/volta-icons.svg#Vlt-icon-unhappy"/></svg>
            </span>
          </div>
        </div>
      </div>

      <div class="Vlt-col Vlt-col--right Vlt-col--1of4">
        <span v-show="githubUrl" id="feedback__improve">
          <svg class="Vlt-icon Vlt-black">
            <use xlink:href="/symbol/volta-icons.svg#Vlt-icon-github" />
          </svg>
          <a v-bind:href="githubUrl" target="_blank"> Improve this page</a>
        </span>
      </div>
    </div>

    <p v-show="error" class="form__error">{{error}}</p>

    <div v-show="sentiment && !showExtendedFields">
      <hr/>
      <p>Great! Thanks for the feedback.</p>
    </div>

    <div v-show="showExtendedFields && id && !feedbackComplete">
      <hr/>
      <p>We see that this page didn’t meet your expectations. We’re really sorry!<br/></p>
      <div class="Vlt-form__element">
        <p><strong>We’d like a chance to fix that. Please would you give us some more information?</strong></p>
        <label class="Vlt-label">What didn’t work for me: <small class="Vlt-grey-darker">(required)</small></label>
        <div class="Vlt-textarea">
          <textarea v-model="comment"/>
        </div>
      </div>

      <div v-show="!currentUser" class="Vlt-form__element Vlt-form__element--elastic">
        <p><strong>Can we let you know when we've solved your issue?</strong></p>
        <label class="Vlt-label">My email: <small class="Vlt-grey-darker">(optional)</small></label>
        <div class="Vlt-input">
          <input type="email" size="20" value="email"/>
        </div>
      </div>


      <input v-on:click="submitFeedback" v-bind:disabled="isSubmitDisabled" type="submit" class="Vlt-btn Vlt-btn--primary Vlt-btn--app" value="Send Feedback" />
      <p>Your data will be treated in accordance with our <a href="https://www.nexmo.com/privacy-policy">Privacy Policy</a>, which sets out the rights you have in respect of your data.</p>
    </div>

    <div v-show="feedbackComplete">
      <hr/>
      <p>Thank you for your feedback</p>
    </div>

    <p v-show="currentUser">
      <br/>
      Logged in as {{ currentUser.email }}.
      <a v-bind:href="currentUser.signout_path">Sign out</a>
    </p>

  </div>
</template>
<script>
  export default {
    data: function() {
      return {
        codeLanguage: undefined,
        codeLanguageSetByUrl: undefined,
        codeLanguageSelectedWhilstOnPage: undefined,
        comment: '',
        currentUser: undefined,
        error: false,
        feedbackAuthor: undefined,
        feedbackComplete: undefined,
        githubUrl: undefined,
        id: undefined,
        recaptchaToken: undefined,
        sentiment: undefined,
        showExtendedFields: false,
        source: undefined,
        submittingFeedback: undefined,
        uploadingSentiment: false,
      };
    },
    created: function() {
      this.codeLanguage = window.feedbackProps.code_language || window.initialLanguage;
      this.codeLanguageSelectedWhilstOnPage = window.feedbackProps.code_language_selected_whilst_on_page || false;
      this.codeLanguageSetByUrl = window.feedbackProps.code_language_set_by_url;
      this.currentUser = window.feedbackProps.current_user;
      this.feedbackAuthor = window.feedbackProps.feedback_author;
      this.githubUrl = window.feedbackProps.github_url;
      this.recaptcha = window.feedbackProps.recaptcha;
      this.source = window.feedbackProps.source;
    },
    mounted: function() {
      document.addEventListener('codeLanguageChange', this.handleCodeLanguageChange.bind(this));
    },
    beforeDestroy: function() {
      document.removeEventListener('codeLanguageChange', this.handleCodeLanguageChange.bind(this));
    },
    computed: {
      email: function() {
        return this.feedbackAuthor && this.feedbackAuthor.email ||
          this.currentUser && this.currentUser.email;
      },
      isSubmitDisabled: function() {
        return this.submittingFeedback || this.comment === '';
      }
    },
    methods: {
      setSentiment: function(sentiment) {
        this.sentiment = sentiment;
        this.showExtendedFields = sentiment == 'negative';
        this.uploadingSentiment = true;
        this.error = undefined;
        this.createOrUpdate();
      },
      parameters: function() {
        return {
          'g-recaptcha-response': this.recaptchaToken,
          feedback_feedback: {
            id: this.id,
            sentiment: this.sentiment,
            comment: this.comment,
            email: this.email,
            code_language: this.codeLanguage,
            code_language_selected_whilst_on_page: this.codeLanguageSelectedWhilstOnPage,
            code_language_set_by_url: this.codeLanguageSetByUrl,
            source: this.source,
          }
        };
      },
      invisibleCaptchaCallback: function(recaptchaToken) {
        this.recaptchaToken = recaptchaToken;
        this.createOrUpdate();
      },
      createOrUpdate: function() {
        if (this.recaptcha.enabled && !this.recaptcha.skip && this.recaptchaToken == undefined) {
          const element = $('<div></div>').appendTo('#recaptcha-container')[0]

          const id = grecaptcha.render(element, {
            sitekey: this.recaptcha.sitekey,
            callback: this.invisibleCaptchaCallback.bind(this),
            size: 'invisible',
            badge: 'inline',
          })
          return grecaptcha.execute(id)
        }

        let request = new Request('/feedback/feedbacks', {
          method: 'POST',
          credentials: 'same-origin',
          body: JSON.stringify(this.parameters()),
          headers: { 'Content-Type': 'application/json' }
        })

        fetch(request)
        .then((response) => {
          if (response.ok) { return response.json() }
          return Promise.reject({ message: 'Bad response from server', response })
        })
        .then((payload) => {
          this.feedbackComplete = this.submittingFeedback;
          this.uploadingSentiment = false;
          this.submittingFeedback = false;
          this.id = payload.id;
        })
        .catch((error) => {
          console.log(error)

          this.uploadingSentiment = false;
          this.submittingFeedback = false;

          if (error.response) {
            error.response.json()
              .then((payload) => { this.error = payload.error; })
              .catch(() => { this.error = "Something went wrong! Try again later"; })
          } else {
            this.error = "Something went wrong! Try again later";
          }
        })
      },
      submitFeedback: function() {
        this.submittingFeedback = true;
        this.createOrUpdate();
      },
      handleCodeLanguageChange: function(event, data) {
        this.codeLanguage = data.language;
        this.codeLanguageSelectedWhilstOnPage = true;
        this.codeLanguageSetByUrl = false;
      }
    }
  }
</script>
<style scoped>
</style>
