module.exports = function(api) {
  var validEnv = ['development', 'test', 'production', 'staging']
  var currentEnv = api.env()
  var isDevelopmentEnv = api.env('development')
  var isStagingEnv = api.env('staging')
  var isProductionEnv = api.env('production')
  var isTestEnv = api.env('test')

  if (!validEnv.includes(currentEnv)) {
    throw new Error(
      'Please specify a valid `NODE_ENV` or ' +
        '`BABEL_ENV` environment variables. Valid values are "development", ' +
        '"test", and "production". Instead, received: ' +
        JSON.stringify(currentEnv) +
        '.'
    )
  }

  return {
    presets: [
      isTestEnv && [
        require('@babel/preset-env').default,
        {
          targets: {
            node: 'current'
          }
        }
      ],
      (isProductionEnv || isDevelopmentEnv || isStagingEnv) && [
        require('@babel/preset-env').default,
        {
          forceAllTransforms: true,
          modules: false,
          targets: {
            browsers: '> 1%',
          },
          exclude: ['transform-typeof-symbol']
        }
      ]
    ].filter(Boolean),
    plugins: [
      require('babel-plugin-macros'),
      require('@babel/plugin-syntax-dynamic-import').default,
      isTestEnv && require('babel-plugin-dynamic-import-node'),
      require('@babel/plugin-transform-destructuring').default,
      [
        require('@babel/plugin-proposal-class-properties').default,
        {
          loose: true,
          spec: true
        }
      ],
      [
        require('@babel/plugin-proposal-object-rest-spread').default,
        {
          useBuiltIns: true
        }
      ],
      [
        require('@babel/plugin-transform-runtime').default,
        {
          helpers: false,
          regenerator: true
        }
      ],
      [
        require('@babel/plugin-transform-regenerator').default,
        {
          async: false
        }
      ]
    ].filter(Boolean)
  }
}
