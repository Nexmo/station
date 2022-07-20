<template>
  <div class="Wrapper">
    <div class="Wrapper-content">
      <svg class="Vlt-icon Vlt-grey Nxd-search-icon">
        <use xlink:href="/symbol/volta-icons.svg#Vlt-icon-search-full" />
      </svg>


      <div class="Nxd-search-input">
        <div class="Vlt-composite Vlt-composite--appendedicon">
          <div class="Vlt-composite__prepend Vlt-composite__prepend--icon">
            <svg><use xlink:href="/symbol/volta-icons.svg#Vlt-icon-search"/></svg>
          </div>
          <div class="Vlt-input">
            <input
              v-model="query"
              name="query"
              placeholder="Search"
              id="searchbox-test"
              type="text"
              autoComplete="off"
              v-on:keydown.esc="onEscDownHandler"
              v-on:input="onInputHandler"
              ></input>
          </div>
          <div class="Vlt-composite__append Vlt-composite__append--icon Nxd-search-close">
            <svg><use xlink:href="/symbol/volta-icons.svg#Vlt-icon-cross-bold"/></svg>
          </div>
        </div>
      </div>
    </div>

    <div v-show="showResults" class="Nxd-search">
      <div class="Nxd-search__wrapper">
        <div v-show="loading" class="spinner">
          <i class="icon icon-cog"></i>
        </div>
        <div v-show="!loading" class="Nxd-search__wrapper">
          <div class="Nxd-search__results" v-for="result in results" v-bind:key="result.index">
            <h3 class="Nx-search__title">
              {{ resultTitle(result.index) }}
            </h3>
            <div v-if="result.hits.length > 0" >
              <div v-if="isZendeskArticle(result)">
                <ZendeskArticle v-for="hit in result.hits" v-bind:hit="hit" v-bind:key="hitKey(result, hit)"/>
              </div>
              <div v-else-if="isNDPArticle(result)">
                <NDPArticle v-for="hit in result.hits" v-bind:hit="hit" v-bind:key="hitKey(result, hit)"/>
              </div>
              <div v-else-if="isBlog(result)">
                <Blog v-for="hit in result.hits" v-bind:hit="hit" v-bind:key="hitKey(result, hit)"/>
              </div>
            </div>
            <div v-else>
              <p class="Nxd-search--no-results"><i>No results</i></p>
            </div>
          </div>
        </div>
      </div>
    </div>
  </div>
</template>
<script>
import algoliasearch from 'algoliasearch'
import debounce from 'lodash/debounce'
import NDPArticle from './NDPArticle.vue';
import ZendeskArticle from './ZendeskArticle.vue';
import Blog from './Blog.vue';

export default {
  data: function() {
    return {
      analyticsTriggered: false,
      client: undefined,
      expanded: false,
      loading: false,
      query: '',
      results: [],
      analyticsStrongIndicationOfReadingTimer: undefined,
    }
  },
  created: function() {
    this.client = algoliasearch(
      document.querySelector('meta[name=algolia_application_id]').getAttribute('content'),
      document.querySelector('meta[name=algolia_search_key]').getAttribute('content')
    );
  },
  mounted: function() {
    if (document.querySelector('.Nxd-template')) {
      document.querySelector('.Nxd-template').addEventListener('click', this.onClickOutside.bind(this));
    } else if (document.querySelector('.Adp-landing')) {
      document.querySelector('.Adp-landing .wrapper').addEventListener('click', this.onClickOutside.bind(this));
    }
    this.$el.querySelector('.Nxd-search-icon').addEventListener('click', this.handleSearchToggle.bind(this));
    this.$el.querySelector('.Nxd-search-close').addEventListener('click', this.handleSearchToggle.bind(this));
  },
  onDestroy: function() {
    if (document.querySelector('.Nxd-template')) {
      document.querySelector('.Nxd-template').removeEventListener('click', this.onClickOutside.bind(this));
    } else if (document.querySelector('.Adp-landing')) {
      document.querySelector('.Adp-landing .wrapper').removeEventListener('click', this.onClickOutside.bind(this));
    }
  },
  computed: {
    showResults: function() {
      return this.query != '';
    }
  },
  methods: {
    resultTitle: function(name) {
      if (name == 'zendesk_nexmo_articles') {
        return 'Knowledgebase';
      } else if (name.includes('nexmo_developer')) {
        return 'Vonage Developer';
      } else if (name == 'prod_blogposts') {
        return 'Blog';
      }
    },
    isZendeskArticle: function(result) {
      return result.index == 'zendesk_nexmo_articles';
    },
    isNDPArticle: function(result) {
      return result.index.includes('nexmo_developer');
    },
    isBlog: function(result) {
      return result.index == 'prod_blogposts';
    },
    hitKey: function(result, hit) {
      return result.index + hit.objectID;
    },
    onClickOutside: function(event) {
      if (this.showResults) {
        this.reset();
      }
      if (this.expanded) {
        this.expanded = false;
      }
    },

    handleSearchToggle: function(event) {
      event.preventDefault();
      event.stopPropagation();

      this.toggleSearch();
    },

    toggleSearch: function(hide) {
      let search = this.$el.querySelector('.Nxd-search-input');
      if (hide === true || search.style.display == 'flex') {
        search.style.display = 'none';
      } else {
        search.style.display = 'flex';
      }
    },
    onEscDownHandler: function(event) {
      if (!this.analyticsTriggered && this.query !== '') {
        this.triggerAnalyticalSearch();
      }
      this.reset();
    },
    reset: function() {
      this.resetAnalyticsListeners();
      this.query = '';
      this.results = [];
      this.loading = false;
    },
    onInputHandler: function(event) {
      event.stopPropagation();
      if (this.query === '') {
        this.reset();
      } else {
        debounce(this.handleSearch.bind(this), 250)(event);
      }
    },
    handleSearch: function(event) {
      this.loading = this.query === '';
      this.analyticsTriggered = false;
      this.performSearch();

      this.resetAnalyticsListeners();
      this.analyticsStrongIndicationOfReadingTimer = setTimeout(this.triggerAnalyticalSearch, 2000);
      window.addEventListener('mousemove', this.triggerAnalyticalSearch);
    },
    performSearch: function(analytics = false) {
      const parameters = Array.from(document.querySelectorAll('meta[name=algolia_index]')).map((element) => {
        return {
          indexName: element.getAttribute('content'),
          query: this.query,
          params: {
            analytics: analytics,
            hitsPerPage: analytics ? 1 : 4
          }
        }
      })

      const searchPromise = this.client.search(parameters)

      if (!analytics) {
        searchPromise.then((response) => {
          this.results = response['results'];
          this.loading = false;
        })
      }
    },
    resetAnalyticsListeners: function() {
      clearTimeout(this.analyticsStrongIndicationOfReadingTimer);
      window.removeEventListener('mousemove', this.triggerAnalyticalSearch);
    },
    triggerAnalyticalSearch: function() {
      this.performSearch(true);
      this.analyticsTriggered = true;
      this.resetAnalyticsListeners();
    }
  },
  components: {
    ZendeskArticle, NDPArticle, Blog
  }
}
</script>
<style scoped>
.Wrapper {
  top: 55px;
  right: 13px;
  display: flex;
  position: absolute;
}
.Wrapper-content {
  display: flex;
  flex-direction: column;
  align-items: flex-end;
}
.Nxd-search-input {
  display: none;
  width: 756px;
  padding: 20px 30px;
  background: white;
  height: 87px;
  border-radius: 8px;
  margin-top: 5px;
  z-index: 100003;
}
.Vlt-composite {
  width: 100%;
}
.Nxd-search-icon {
  margin-right: 10px;
}
#searchbox-test {
  border: 1px solid white;
}
</style>
