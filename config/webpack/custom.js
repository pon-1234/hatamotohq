const path = require('path');

module.exports = {
  resolve: {
    alias: {
      '@': path.resolve(__dirname, '..', '..', 'app/javascript/src'),
      '@channels': path.resolve(__dirname, '..', '..', 'app/javascript/channels'),
      '@style': path.resolve(__dirname, '..', '..', 'app/javascript/stylesheets'),
      '@pages': path.resolve(__dirname, '..', '..', 'app/javascript/src/pages'),
      '@components': path.resolve(__dirname, '..', '..', 'app/javascript/src/components'),
      vue: 'vue/dist/vue.min.js'
    }
  }
};