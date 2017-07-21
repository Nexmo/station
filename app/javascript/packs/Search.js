import debounce from 'lodash/debounce'

class Search extends React.Component {
  constructor(props) {
    super(props)
    this.state = {
      results: [],
      query: '',
      loading: false,
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

    this.setState({
      query: event.target.value,
      loading: this.state.query === '',
    })

    let options = {}
    let basicAuthUsername = $('meta[name=basic_auth_username]').attr('content')
    let basicAuthPassword = $('meta[name=basic_auth_password]').attr('content')

    if (basicAuthUsername && basicAuthPassword) {
      const base64Credentials = btoa(`${basicAuthUsername}:${basicAuthPassword}`)

      options = {
        headers: {
          'Authorization': `Basic ${base64Credentials}`,
        }
      }
    }

    fetch(`/search.json?query=${event.target.value}`, options)
    .then((response) => {
      return response.json()
    })
    .then((payload) => {
      this.setState({ results: payload, loading: false })
    })
  }

  handleKeyDown(event) {
    // Handle escape
    if (event.keyCode === 27) {
      this.reset()
    }
  }

  reset() {
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

  renderIndexResults(index) {
    return index.hits.map((hit) => {
      if (index.index == 'zendesk_nexmo_articles') {
        return (
          <div className="search-result">
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
          <div className="search-result">
            <a href={ hit.path }>
              <div>
                <span className="meta">{ hit.product }</span>
                <h3>{ hit.title }</h3>
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

  renderHeading(indexName) {
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
          <div className="results-index">
            <h3>{ this.renderHeading(index.index) }</h3>
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
            { this.renderResults() }
          </div>
        }
      </div>
    )
  }
}

export default Search
