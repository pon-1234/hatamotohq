<script>
export default {
  props: ['data'],
  render: function(h) {
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
              class: 'view preview-text-content',
              domProps: {
                // eslint-disable-next-line no-undef
                innerHTML: emojione.toImage(this.data)
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
    text-align: center;
    position: relative;
    word-break: break-word;
    word-wrap: break-word;
  }

  .balloon {
    border-radius: 1rem;
    position: relative;
    background: #edeff0;
    max-width: 300px !important;
  }

  .user, .bot, .friend {
    .balloon {
      background: #edeff0;
    }
    .balloon::after {
      content: "";
      position: absolute;
      width: 0;
      height: 0;
      top: 0.75rem;
      border: 1rem solid transparent;
      margin-left: -0.375rem;
      margin-right: -0.375rem;
    }
  }

  .user {
    .balloon {
      background: #b8ebb8;
    }
    .balloon::after {
      left: auto;
      right: 0;
      border-right: 0;
      border-top: 0;
      border-left-color: #b8ebb8;
      margin-right: -0.375rem;
    }
  }

  .bot {
    .balloon {
      background: #edeff0;
    }
    .balloon::after {
      left: auto;
      right: 0;
      border-right: 0;
      border-top: 0;
      border-left-color: #edeff0;
      margin-right: -0.375rem;
    }
  }

  .friend {
    .balloon {
      background: #d1dcf5;
    }
    .balloon::after {
      border-left-color: #d1dcf5;
      left: 0;
      right: auto;
      border-right-color: #d1dcf5;
      border-left: 0;
      border-top: 0;
    }
  }
</style>
