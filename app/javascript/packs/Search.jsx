import 'whatwg-fetch'
import React from 'react'
import debounce from 'lodash/debounce'

class Search extends React.Component {
  constructor(props) {
    super(props)
    this.state = {
      results: [],
      query: '',
      loading: false,
      analyticsTriggered: false,
    }

     this.triggerAnalyticalSearch =  this.triggerAnalyticalSearch.bind(this)

     this.fetchOptions = {}
     const basicAuthUsername = $('meta[name=basic_auth_username]').attr('content')
     const basicAuthPassword = $('meta[name=basic_auth_password]').attr('content')

     this.searchUrl = $('meta[name=search_url]').attr('content')
     this.environment = $('meta[name=environment]').attr('content')

     if (basicAuthUsername && basicAuthPassword) {
       const base64Credentials = btoa(`${basicAuthUsername}:${basicAuthPassword}`)

       this.fetchOptions = {
         headers: {
           'Authorization': `Basic ${base64Credentials}`,
         }
       }
     }
  }

  handleChange(event) {
    event.persist()
    if (this.state.query === '') {
      this.onChange.bind(this)(event)
    } else {
      debounce(this.onChange.bind(this), 250)(event)
    }
  }

  onChange(event) {
    if (event.target.value === '') {
      return this.reset()
    }

    $('.wrapper').addClass('wrapper--blur')

    this.setState({
      query: event.target.value,
      loading: this.state.query === '',
      analyticsTriggered: false,
    })

    // Setup event listeners for Analytics
    this.resetAnalyticsListeners()
    this.analyticsStrongIndicationOfReadingTimer = setTimeout(this.triggerAnalyticalSearch, 2000)
    window.addEventListener('mousemove', this.triggerAnalyticalSearch)

    fetch(`${this.searchUrl}?query=${event.target.value}&hitsPerPage=4&environment=${this.environment}&analytics=false`, this.fetchOptions)
    .then((response) => {
      return response.json()
    })
    .then((payload) => {
      this.setState({ results: payload['results'], loading: false })
    })
  }

  triggerAnalyticalSearch() {
    fetch(`${this.searchUrl}?query=${this.state.query}&hitsPerPage=1&environment=${this.environment}&analytics=true`, this.fetchOptions)
    this.setState({ analyticsTriggered: true })
    this.resetAnalyticsListeners()
  }

  resetAnalyticsListeners() {
    clearTimeout(this.analyticsStrongIndicationOfReadingTimer)
    window.removeEventListener('mousemove', this.triggerAnalyticalSearch)
  }

  handleKeyDown(event) {
    // Handle escape
    if (event.keyCode === 27) {
      if (!this.state.analyticsTriggered && this.state.query != '') {
        this.triggerAnalyticalSearch()
      }

      this.reset()
    }
  }

  reset() {
    $('.wrapper').removeClass('wrapper--blur')
    this.resetAnalyticsListeners()
    this.refs.input.value = '';
    this.setState({
      results: [],
      query: '',
      loading: false,
    })
  }

  shouldShowResults() {
    if (this.state.query != '') {
      return true
    }
  }

  renderHeading(hit) {
    if(!hit.heading) { return }
    if(hit.title == hit.heading) { return }

    return (
      <small> &gt; { hit.heading }</small>
    )
  }

  renderIndexResults(index) {
    return index.hits.map((hit) => {
      if (index.index == 'zendesk_nexmo_articles') {
        return (
          <div className="search-result" key={ index.index + hit.objectID }>
            <a href={ `https://help.nexmo.com/hc/en-us/articles/${hit.id}` } target="_blank">
              <div>
                <span className="meta">{ hit.section.full_path }</span>
                <h3>{ hit.title }</h3>
                <p
                  className="search-highlighted"
                  dangerouslySetInnerHTML={{ __html: `...${hit._snippetResult.body_safe.value}...` }}
                ></p>
              </div>
            </a>
          </div>
        )
      } else if (index.index.includes('nexmo_developer')) {
        return (
          <div className="search-result" key={ index.index + hit.objectID }>
            <a href={ `${hit.path}#${hit.anchor}` }>
              <div>
                <span className="meta">{ hit.product }</span>
                <h3>
                  { hit.title }
                  { this.renderHeading(hit) }
                </h3>

                <p><b>{ hit.description ? hit.description.substring(0, 150) : '' }</b></p>
                <p
                  className="search-highlighted"
                  dangerouslySetInnerHTML={{ __html: `...${hit._snippetResult.body.value}...` }}
                >
                </p>
              </div>
            </a>
          </div>
        )
      }
    })
  }

  renderIndexHeading(indexName) {
    if (indexName == 'zendesk_nexmo_articles') {
      return "Knowlegebase"
    } else if (indexName.includes('nexmo_developer')) {
      return "Nexmo Developer"
    }
  }

  renderIndexResultsEmpty() {
    return (
      <p><i>No results</i></p>
    )
  }

  renderLoading() {
    return (
      <div className="spinner">
        <i className="icon icon-cog"></i>
      </div>
    )
  }

  renderResults() {
    if (this.state.loading) {
      return this.renderLoading()
    } else {
      return this.state.results.map((index) => {
        return(
          <div className="results-index" key={ index.index }>
            <h3>{ this.renderIndexHeading(index.index) }</h3>
            { index.hits.length > 0 ? this.renderIndexResults(index) : this.renderIndexResultsEmpty(index) }
          </div>
        )
      })
    }
  }

  renderClearButton() {
    if (this.state.query !== '') {
      return (
        <i id="search-clear" className="icon icon-times-circle" onClick={ this.reset.bind(this) }></i>
      )
    }
  }

  render() {
    return (
      <div>
        <input
          type="text"
          id="searchbox"
          name="query"
          placeholder="Search"
          name="query"
          autoComplete="off"
          onChange={ this.handleChange.bind(this) }
          onKeyDown={ this.handleKeyDown.bind(this) }
          ref="input"
        />

        { this.renderClearButton() }

        { this.shouldShowResults() &&
          <div className="quicksearch">
            <div className="quicksearch__results">
              { this.renderResults() }
            </div>
          </div>
        }
      </div>
    )
  }
}

export default Search
