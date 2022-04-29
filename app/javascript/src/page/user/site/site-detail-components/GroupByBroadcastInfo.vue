<template>
  <div class="col-12">
    <div class="row">
      <div class="col-sm-12">
        <table class="table table-striped mt-3">
          <thead>
            <tr>
              <th>送信日</th>
              <th>送信対象</th>
              <th colspan="2">本文</th>
              <th>クリック数</th>
              <th>訪問人数</th>
            </tr>
          </thead>
          <tbody>
            <tr v-for="(broadcastMessage, index) in broadcasts" :key="index">
              <td>
                <template v-if="broadcastMessage.broadcast.deliver_at">
                  {{ formattedDatetime(broadcastMessage.broadcast.deliver_at) }}
                </template>
                <template v-else>
                  <div>未配信</div>
                  <div>
                    <span class="text-sm">予約 {{ formattedDatetime(broadcastMessage.broadcast.schedule_at) }} </span>
                  </div>
                </template>
              </td>
              <td class="fw-300"><broadcast-deliver-target :broadcast="broadcastMessage.broadcast"></broadcast-deliver-target></td>
              <td class="has_emoji w-250"><p class="broadcast-message-content w-250 mt-0 mb-0">{{broadcastMessage.content.text}}</p></td>
              <td>
                <a
                  @click="currentBroadcastIndex = index"
                  type="button"
                  data-toggle="modal"
                  data-target="#modalMessagePreview"
                  class="btn btn-xs btn-default btn-light"
                  >プレビュー</a
                >
              </td>
              <td><b>{{broadcastMessage.click_count}}</b>回 / <b>{{broadcastMessage.sending_count}}</b>送信</td>
              <td><b>{{broadcastMessage.visitor_count}}</b>人 / <b>{{broadcastMessage.receiver_count}}</b>人送信</td>
            </tr>
          </tbody>
        </table>
      </div>
    </div>
    <modal-message-preview :message="broadcasts[currentBroadcastIndex] || {}" type="broadcast" />
  </div>
</template>
<script>
import { mapActions, mapState } from 'vuex';
import Util from '@/core/util';

export default {
  props: ['siteId'],
  data() {
    return {
      loading: true,
      currentBroadcastIndex: null
    };
  },
  async beforeMount() {
    await this.getBroadcasts({ id: this.siteId });
    this.loading = false;
  },
  computed: {
    ...mapState('site', {
      broadcasts: (state) => state.broadcasts
    })
  },
  methods: {
    ...mapActions('site', ['getBroadcasts']),
    formattedDatetime(time) {
      return Util.formattedDatetime(time);
    }
  }
};
</script>
<style lang="scss" scoped>
  .broadcast-message-content {
    display:-webkit-box;
    -webkit-line-clamp:1;
    -webkit-box-orient: vertical;
    overflow: hidden;
    text-overflow: ellipsis;
    word-break: break-all;
  }
  .table {
    tr {
      td {
        vertical-align: middle;
      }
    }
  }
</style>
