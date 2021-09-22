const { styles } = require('@ckeditor/ckeditor5-dev-utils');

module.exports = {
  test: /ckeditor5-[^/\\]+[/\\].+\.css$/,
  use: [{
    loader: 'style-loader',
    options: {
      injectType: 'singletonStyleTag',
      attributes: {
        'data-cke': true
      }
    }
  }, {
    loader: 'postcss-loader',
    options: styles.getPostCssConfig({
      minify: true,
      themeImporter: {
        themePath: require.resolve('@ckeditor/ckeditor5-theme-lark')
      }
    })
  }]
};