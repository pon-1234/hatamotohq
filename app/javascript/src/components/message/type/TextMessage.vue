<script>
export default {
  props: ['data'],
  render: function(h) {
    // eslint-disable-next-line no-useless-escape
    const urlRegex = /([\w+]+\:\/\/)?([\w\d-]+\.)*[\w-]+[\.\:]\w+([\/\?\=\&\#\.]?[\w-]+)*\/?/gim;
    const text = this.data.replace(urlRegex, function(url, protocol) {
      let actualUrl = url;
      if (protocol === undefined) actualUrl = '//' + actualUrl;
      return '<a href="' + actualUrl + '" target="_blank">' + url + '</a>';
    });
    return h(
      'div',
      {
        class: 'balloon'
      },
      [
        h(
          'div',
          {
            class: 'selectable chat-item-text'
          },
          [
            h('div', {
              class: 'view preview-text-content text-prewrap',
              domProps: {
                // eslint-disable-next-line no-undef
                innerHTML: emojione.toImage(text)
              }
            })
          ]
        )
      ]
    );
  }
};
</script>
<style lang="scss" scoped>
  .preview-text-content {
    white-space: pre-wrap;
    display: inline-block;
    text-align: left;
    .emojione {
      min-width: 20px;
      min-height: 20px;
    }
  }

  .chat-item-text {
    padding: 8px 12px;
    line-height: 1.25;
    position: relative;
    word-break: break-word;
    word-wrap: break-word;
  }

  .message-preview {
    .balloon {
      border-radius: 1rem;
      position: relative;
      background: #edeff0;
      max-width: 300px !important;
    }
  }
</style>
