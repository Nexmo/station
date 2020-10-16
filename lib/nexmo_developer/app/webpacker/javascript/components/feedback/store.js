export default {
  state: {
    path: null,
    sentiment: null,
    source: null,
    configId: null,
    steps: [],
  },
  setPath: function(path) {
    this.state.path = path;
  },
  setSentiment: function(sentiment) {
    this.state.sentiment = sentiment;
  },
  setSource: function(source) {
    this.state.source = source;
  },
  setConfigId: function(id) {
    this.state.configId = id;
  },
  addStep: function(step) {
    this.state.steps.push(step);
  },
  clearState: function() {
    this.state.path = null;
    this.state.sentiment = null;
    this.state.source = null;
    this.state.configId = null;
    this.state.steps = [];
  }
};
