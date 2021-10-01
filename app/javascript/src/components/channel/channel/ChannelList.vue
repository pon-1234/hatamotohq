<template>
  <div class="chat-panel d-flex flex-column py-2 px-3 bg-white">
    <!-- start search box -->
    <div class="app-search sticky-top fh-55 w-100">
      <form>
        <div class="form-group position-relative">
          <input type="text" class="form-control" placeholder="検索" @change="onSearchChannel"/>
          <span class="mdi mdi-magnify search-icon"></span>
        </div>
      </form>
    </div>
    <!-- users -->
    <div class="flex-grow-1 overflow-auto w-100">
      <channel-list-item
        v-for="(channel, index) in showChannels" :key="index"
        :channel="channel"
        :active="activeChannel && channel.id === activeChannel.id"
        @click.native="switchChannel(channel, index)">
      </channel-list-item>
      <infinity-scroll @intersect="loadMore" v-if="shouldShowSpinner"></infinity-scroll>
    </div>
  </div>
</template>
<script>
import { mapState, mapActions, mapMutations } from 'vuex';

export default {
  data() {
    return {
      showChannels: [],
      curChannelIndex: 0,
      isLastChannel: false,
      hiddenChannels: [],
      PER_PAGE: 20
    };
  },

  computed: {
    ...mapState('channel', {
      channels: state => state.channels,
      allChannelLoaded: state => state.allChannelLoaded,
      isLoadMoreChannel: state => state.isLoadMoreChannel,
      messageParams: state => state.messageParams,
      totalPages: state => state.channel_LastPage || 1,
      currentPage: state => state.channel_CurrentPage || 1,
      activeChannel: state => state.activeChannel
    }),

    shouldShowSpinner() {
      return true;
    }
  },

  watch: {
    channels: {
      handler(val) {
        this.curChannelIndex = 0;
        const lengthShowChannel = val.length;
        this.isLastChannel = false;
        this.showChannels = [];
        this.getChannelsFromCache(val, lengthShowChannel);
      },
      deep: true
    }
  },

  methods: {
    ...mapActions('channel', ['getChannels', 'getMessages', 'setActiveChannel']),
    ...mapMutations('channel', [
      'resetMessages'
    ]),

    loadMore() {
      console.log('-----loading more-----');
    },

    onSearchChannel() {
    },

    async switchChannel(channel, index) {
      const notChanged = this.activeChannel.id === channel.id;
      this.$emit('switchChannel', !notChanged);
      // Do nothing if channel is not changed
      if (notChanged) return;

      // Activate new channel
      this.setActiveChannel(channel);
      this.resetMessages();
    },

    getChannelsFromCache(channels, perPage = 0) {
      if (perPage === 0) {
        perPage = this.PER_PAGE;
      }
      let isBreak = false;
      let index = 0;
      const lengthChannel = channels.length;

      for (; this.curChannelIndex < lengthChannel; this.curChannelIndex++) {
        const channel = channels[this.curChannelIndex];
        this.showChannels.push(channel);
        index++;
        if (index >= perPage) {
          isBreak = true;
          break;
        }
      }

      if (!isBreak) {
        this.isLastChannel = true;
      }
      this.curChannelIndex += 1;
    },

    async loadMoreChannel() {
      const listView = this.$refs.channelListView;

      console.log(listView, listView.scrollHeight, listView.scrollTop, listView.clientHeight, this.isLoadMoreChannel);

      if (listView.scrollHeight - listView.scrollTop - listView.clientHeight < 10 && !this.isLoadMoreChannel) {
        if (this.isLastChannel) {
          return;
        }

        this.getChannelsFromCache(this.channels);
      }
    }
  }
};
</script>
