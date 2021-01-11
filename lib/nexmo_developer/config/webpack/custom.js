module.exports = {
  optimization: {
    splitChunks: {
      chunks: 'all'
    }
  },
  node: false,
  resolve: {
    alias: {
      vue: 'vue/dist/vue.js',
    }
  }
}
