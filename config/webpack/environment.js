const {
  environment
} = require('@rails/webpacker');
const {
  VueLoaderPlugin
} = require('vue-loader');
const vue = require('./loaders/vue');
const dotenv = require('dotenv');
dotenv.config({ path: '.env', silent: true });

const customConfig = require('./custom');

environment.config.merge(customConfig);

const webpack = require('webpack');
environment.plugins.append('Provide',
  new webpack.ProvidePlugin({
    $: 'jquery',
    jQuery: 'jquery',
    Popper: ['popper.js', 'default']
  })
);

environment.plugins.prepend('VueLoaderPlugin', new VueLoaderPlugin());

environment.plugins.prepend(
  'Environment',
  new webpack.EnvironmentPlugin(process.env)
);

environment.loaders.prepend('vue', vue);

module.exports = environment;