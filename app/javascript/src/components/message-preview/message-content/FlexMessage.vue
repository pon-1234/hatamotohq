<template>
  <div style="overflow: auto" class="flex-message-el">
    <div  class="preview"><div v-html="flexMessageHtml"></div></div>
  </div>
</template>
<script>
import Util from '@/core/util';

export default {
  props: ['data', 'source'],
  data() {
    return {
      isLoading: false,
      flexMessageHtml: null
    };
  },
  watch: {
    data(val) {
      if (val && val.id) {
        this.fetchFlexMessageLayout(val);
      } else {
        this.flexMessageHtml = null;
      }
    }
  },
  mounted() {
    if (this.data && this.data.id) {
      this.fetchFlexMessageLayout(this.data, this.source);
    } else {
      this.flexMessageHtml = 'FlexMessage: Fetch error';
    }
  },
  methods: {
    fetchFlexMessageLayout(flexMessage, source) {
      this.isLoading = true;
      this.$store.dispatch('flexMessage/renderFlexMessage', {
        flexMessageId: flexMessage.id,
        source: source
      }).done((html) => {
        this.flexMessageHtml = html;
        this.$nextTick(() => {
          Util.addMouseScrollHorizontal($('.preview>div'));
        });
      }).fail(() => {
        this.flexMessageHtml = 'FlexMessage: Fetch error';
      }).always(() => {
        this.isLoading = false;
      });
    }
  }

};
</script>

<style scoped lang="scss">

  ::v-deep {
    .preview {
      display: flex;
      zoom: 0.6;
      overflow: auto;
      padding: 10px;
      width: 400px;
      text-align: initial;
    }
     .preview > div {
        margin: auto !important;
        > div{
          display: inline;
          width: 100%;

        }
     }

    .preview:hover {
      cursor: col-resize;

    }

    .flex-editor {
      border: 0px solid transparent;
    }

    .flex-editor:hover {
      border: 0px solid #0a90eb;
    }
    .preview>div{
      display: contents;
    }
  }
  .chat.chat-reverse .preview{
    direction: rtl;
  }

  .flex-message-el {
    min-height: 290px;
     display: flex;
      flex-direction: row;
      overflow: scroll;
      &::before ,
      &::after {
        content:'';
        flex:1;
      }
  }
</style>
