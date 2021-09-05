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

<style lang='scss' >
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

.balloon:after {
  content: "";
  position: absolute;
  left: 0;
  top: 0.75rem;
  width: 0;
  height: 0;
  border: 8px solid transparent;
  border-right-color: #edeff0;
  border-left: 0;
  border-top: 0;
  margin-left: -7px;
}

.chat-body .chat-main .chat-item.balloon {
  margin-right: 1.25rem;
}

.chat-item.balloon {
  border-radius: 1rem;
  display: inline-block;
  background: white;
}
</style>
