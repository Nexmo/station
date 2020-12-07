const webpack = require('webpack')
const { environment } = require('@rails/webpacker')
/* const erb = require('./loaders/erb') */
const { VueLoaderPlugin } = require('vue-loader')
const vue = require('./loaders/vue')
const ManifestPlugin = require('webpack-manifest-plugin')
const customConfig = require('./custom')

const babelLoader = environment.loaders.get('babel')
babelLoader.exclude = []
environment.splitChunks()

// Merge custom config
environment.config.merge(customConfig)

environment.plugins.prepend('VueLoaderPlugin', new VueLoaderPlugin())
environment.plugins.prepend('Provide',
  new webpack.ProvidePlugin({
    $: 'jquery/src/jquery',
    jQuery: 'jquery/src/jquery',
    Popper: ['popper.js', 'default']
  })
);

environment.loaders.prepend('vue', vue)

environment.loaders.get('sass').use.splice(-1, 0, {
  loader: 'resolve-url-loader',
});

/* environment.loaders.prepend('erb', erb) */
module.exports = environment
