<template>
  <div class="conversations">
    <talk-channel-action/>
    <div class="list-view" ref="channelListView" @scroll="loadMoreChannel()">
      <talk-channel-item
        v-for="(channel, index) in showChannels" :key="index"
        :data="channel"
        :active="selected ? channel.id === selected.id : false"
        @click.native="changeChanel(channel, index)"
        />
    </div>
  </div>
</template>
<script>
import { mapState, mapActions } from 'vuex';

export default {
  data() {
    return {
      selected: null,
      showChannels: [],
      currentIndexChannel: 0,
      isLastChannel: false,
      hiddenChannels: [],
      PER_PAGE: 20
    };
  },
  created() {
    if (this.activeChannel) {
      this.selected = this.channels.firstWhere(item => item.id === this.activeChannel.id);
    }
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
        if (this.activeChannel) {
          this.selected = _.first(this.channels, item => item.id === this.activeChannel.id);
        }

        this.currentIndexChannel = 0;
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
    async changeChanel(channel, index) {
      const isCurrentChannel = this.selected ? (channel.id === this.selected.id) : false;
      this.$emit('activeChannel', !isCurrentChannel);

      if (isCurrentChannel) return;
      this.selected = channel;
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
      let index = 0; // bộ đến mỗi page
      const lengthChannel = channels.length;

      for (; this.currentIndexChannel < lengthChannel; this.currentIndexChannel++) {
        const channel = channels[this.currentIndexChannel];
        // nếu có message thì push
        if (channel.last_message) {
          this.showChannels.push(channel);
          index++;
          if (index >= perPage) {
            isBreak = true;
            break;
          }
        }
      }

      if (!isBreak) {
        this.isLastChannel = true;
      }
      this.currentIndexChannel += 1;
    },

    async loadMoreChannel() {
      const listView = this.$refs.channelListView;

      console.log(listView, listView.scrollHeight, listView.scrollTop, listView.clientHeight, this.isLoadMoreChannel);

      if (listView.scrollHeight - listView.scrollTop - listView.clientHeight < 10 && !this.isLoadMoreChannel) {
        if (this.isLastChannel) {
          return;
        }

        // lấy thêm channel
        this.getChannelsFromCache(this.channels);

        // if (this.currentPage >= this.totalPages) return;
        // await this.getChannels({
        //   page: this.currentPage + 1
        // });
      }
    }
  }
};
</script>
