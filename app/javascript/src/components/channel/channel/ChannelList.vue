<template>
  <div class="card">
    <div class="card-body">
      <!-- start search box -->
      <div class="app-search">
        <form>
          <div class="form-group position-relative">
            <input type="text" class="form-control" placeholder="People, groups & messages..." />
            <span class="mdi mdi-magnify search-icon"></span>
          </div>
        </form>
      </div>
      <!-- users -->
      <div class="row">
        <div class="col">
          <div data-simplebar style="max-height: 550px">
            <channel-list-item
              v-for="(channel, index) in showChannels" :key="index"
              :data="channel"
              :active="activeChannel && channel.id === activeChannel.id"
              @click.native="switchChannel(channel, index)">
            </channel-list-item>
          </div>
        </div>
      </div>
    </div>
    <!-- end search box -->
    <!-- <talk-channel-action/> -->
    <!-- <div class="list-view" ref="channelListView" @scroll="loadMoreChannel()">
      <channel-list-item
        v-for="(channel, index) in showChannels" :key="index"
        :data="channel"
        :active="activeChannel && channel.id === activeChannel.id"
        @click.native="switchChannel(channel, index)"
        />
    </div> -->
  </div>
</template>
<script>
import { mapState, mapActions } from 'vuex';

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
      isLoadMoreChannel: state => state.isLoadMoreChannel,
      messageParams: state => state.messageParams,
      totalPages: state => state.channel_LastPage || 1,
      currentPage: state => state.channel_CurrentPage || 1,
      activeChannel: state => state.activeChannel
    })
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
    ...mapActions('channel', ['getChannels', 'getMessages', 'setActiveChannel', 'setMessageParams', 'resetMessages']),
    async switchChannel(channel, index) {
      const notChanged = this.activeChannel.id === channel.id;
      this.$emit('switchChannel', !notChanged);
      // Do nothing if channel is not changed
      if (notChanged) return;

      // Activate new channel
      this.setActiveChannel(channel);
      this.resetMessages();
      const totalUnreadMessage = channel.total_unread_messages ? channel.total_unread_messages : channel.total_unread_messages;
      await this.setMessageParams({ channelId: channel.id, unread: totalUnreadMessage });
      await this.getMessages(this.messageParams);
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
