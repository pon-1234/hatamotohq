<template>
  <div class="chat-panel d-flex flex-column py-2 px-3 bg-white">
    <!-- start search box -->
    <div class="app-search sticky-top fh-55 w-100">
      <div class="form-group position-relative">
        <input type="text" class="form-control" placeholder="検索" v-model="keyword" @keyup="debouncedSearch"/>
        <span class="mdi mdi-magnify search-icon"></span>
      </div>
    </div>
    <!-- users -->
    <div class="flex-grow-1 overflow-auto w-100">
      <channel-list-item
        v-for="(channel, index) in channels" :key="index"
        :channel="channel"
        :active="activeChannel && channel.id === activeChannel.id"
        @click.native="switchChannel(channel, index)">
      </channel-list-item>
      <infinity-scroll @intersect="loadMore" v-if="shouldShowSpinner"></infinity-scroll>
      <div v-if="channels.length === 0 && !shouldShowSpinner" class="w-100 mt-4 text-center text-sm">チャンネルはありません。</div>
    </div>
  </div>
</template>
<script>
import { mapState, mapActions, mapMutations } from 'vuex';

export default {
  data() {
    return {
      keyword: null,
      loading: false
    };
  },

  computed: {
    ...mapState('channel', {
      channels: state => state.channels,
      allChannelLoaded: state => state.allChannelLoaded,
      isLoadMoreChannel: state => state.isLoadMoreChannel,
      activeChannel: state => state.activeChannel
    }),

    shouldShowSpinner() {
      return !this.allChannelLoaded || this.loading;
    }
  },

  methods: {
    ...mapActions('channel', ['getChannels', 'getMessages', 'setActiveChannel']),
    ...mapMutations('channel', [
      'setChannelParams',
      'setChannelParam',
      'resetChannels',
      'resetMessages'
    ]),

    loadMore() {
      const before = !_.isEmpty(this.channels) ? (_.last(this.channels)).last_activity_at : null;
      this.setChannelParam({ before: before });
      this.getChannels();
    },

    debouncedSearch: _.debounce(async function() {
      this.loading = true;
      this.resetChannels();
      this.setChannelParams({ before: null, keyword: this.keyword });
      await this.getChannels();
      this.loading = false;
    }, 300),

    async switchChannel(channel, index) {
      const notChanged = this.activeChannel.id === channel.id;
      this.$emit('switchChannel', !notChanged);
      // Do nothing if channel is not changed
      if (notChanged) return;

      // Activate new channel
      this.setActiveChannel(channel);
      this.resetMessages();
    }
  }
};
</script>
