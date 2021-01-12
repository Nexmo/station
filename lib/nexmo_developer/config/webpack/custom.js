module.exports = {
  optimization: {
    splitChunks: {
      chunks: 'all'
    }
  },
  resolve: {
    alias: {
      vue: 'vue/dist/vue.js',
    },
    preferAbsolute: true
  },
  node: {
    Buffer: false,
    process: false
  }
}
