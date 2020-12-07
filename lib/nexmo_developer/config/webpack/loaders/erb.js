module.exports = {
  test: /\.erb$/,
  enforce: 'pre',
  exclude: /node_modules/,
  use: [{
    loader: 'rails-erb-loader',
    options: {
      runner: 'bundle exec rails runner',
      env: {
        ...process.env,
        DISABLE_SPRING: 1
      }
    }
  }]
}
