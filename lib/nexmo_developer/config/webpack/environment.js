const webpack = require('webpack')
const { environment } = require('@rails/webpacker')
const jquery = require('./plugins/jquery')
const { VueLoaderPlugin } = require('vue-loader')
const vue = require('./loaders/vue')
const ManifestPlugin = require('webpack-manifest-plugin')
const customConfig = require('./custom')
const dotenv = require('dotenv')
dotenv.config({path: __dirname + '/.env'})
environment.plugins.insert(
	"Environment",
	 new webpack.EnvironmentPlugin(process.env)
  )

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

// Create a global var in Webpack for Adobe Analytics
new webpack.DefinePlugin({
  'ADOBE_LAUNCH_PRIMARY_CATEGORY': JSON.stringify(process.env.ADOBE_LAUNCH_PRIMARY_CATEGORY),
});

environment.loaders.get('sass').use.splice(-1, 0, {
  loader: 'resolve-url-loader',
});

environment.plugins.prepend('jquery', jquery)
module.exports = environment
