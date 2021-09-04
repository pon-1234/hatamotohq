<script>
export default {
  props: ['data', 'className'],
  render: function(h) {
    return h(
      'div',
      {
        class: this.className ? this.className + ' chat-item' : 'chat-item'
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
</style>
