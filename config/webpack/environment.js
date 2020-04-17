const webpack = require('webpack')
const { environment } = require('@rails/webpacker')
const { VueLoaderPlugin } = require('vue-loader')
const vue = require('./loaders/vue')

const babelLoader = environment.loaders.get('babel')
babelLoader.exclude = []
environment.splitChunks()

environment.plugins.prepend('VueLoaderPlugin', new VueLoaderPlugin())
environment.loaders.prepend('vue', vue)

environment.loaders.get('sass').use.splice(-1, 0, {
  loader: 'resolve-url-loader',
});

module.exports = environment
