<template>
  <div class="chat-panel d-flex flex-column py-2 px-3 bg-white">
    <!-- start search box -->
    <div class="app-search sticky-top fh-55 w-100">
      <div class="form-group position-relative">
        <input
          type="text"
          class="form-control"
          placeholder="LINE登録名、表示名から検索、タグ名"
          v-model="keyword"
          maxlength="64"
          @keyup="debouncedSearch"
        />
        <span class="mdi mdi-magnify search-icon"></span>
        <div class="mdi mdi-close clear-icon" role="button" @click="resetSearch()" v-show="keyword"></div>
      </div>
    </div>
    <!-- users -->
    <div class="flex-grow-1 overflow-auto w-100">
      <channel-list-item
        v-for="(channel, index) in channels"
        :key="index"
        :channel="channel"
        :active="activeChannel && channel.id === activeChannel.id"
        @click.native="switchChannel(channel, index)"
      >
      </channel-list-item>
      <infinity-scroll @intersect="loadMore" v-if="shouldShowSpinner"></infinity-scroll>
      <div v-if="channels.length === 0 && !shouldShowSpinner" class="w-100 mt-4 text-center text-sm">
        チャンネルはありません。
      </div>
    </div>
  </div>
</template>
<script setup>
import { ref, computed } from 'vue'
import { useStore } from 'vuex'
import { debounce } from 'lodash'

const store = useStore()

const keyword = ref(null)
const loading = ref(false)

const channels = computed(() => store.state.channel.channels)
const allChannelLoaded = computed(() => store.state.channel.allChannelLoaded)
const activeChannel = computed(() => store.state.channel.activeChannel)
const showChatBox = computed(() => store.state.channel.showChatBox)
const shouldShowSpinner = computed(() => !allChannelLoaded.value || loading.value)

const resetSearch = () => {
  keyword.value = null
  fetchData()
}

const loadMore = () => {
  const before = channels.value.length > 0 ? channels.value[channels.value.length - 1].last_activity_at : null
  store.commit('channel/setChannelParam', { before: before })
  store.dispatch('channel/getChannels')
}

const fetchData = async () => {
  loading.value = true
  store.commit('channel/resetChannels')
  store.commit('channel/setChannelParams', { before: null, keyword: keyword.value })
  await store.dispatch('channel/getChannels')
  loading.value = false
}

const debouncedSearch = debounce(fetchData, 300)

const switchChannel = async (channel, index) => {
  if (!showChatBox.value) store.commit('channel/setShowChatBox', true)
  const notChanged = activeChannel.value?.id === channel.id
  // Do nothing if channel is not changed
  if (notChanged) return

  // Activate new channel
  store.dispatch('channel/setActiveChannel', channel)
  store.commit('channel/resetMessages')
}
</script>

<style lang="scss" scoped>
  .app-search {
    z-index: 9;
  }
</style>
