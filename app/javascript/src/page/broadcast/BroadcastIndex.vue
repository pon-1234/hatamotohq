<template>
  <div class="row">
    <div class="col-12">
      <div class="card">
        <div class="card-header">
          <div class="btn btn-success mr-2" @click="openNew()"><i class="uil-plus"></i> 新規作成</div>
        </div>
        <div class="card-body">
          <table class="table table-centered mb-0">
            <thead class="thead-light">
              <tr>
                <th>配信日時</th>
                <th>タイトル</th>
                <th>状況</th>
                <th class="fw-300">配信先</th>
                <th>配信数</th>
                <th class="fw-150">操作</th>
              </tr>
            </thead>
            <tbody>
                <tr v-for="(broadcast, index) in broadcasts" :key="index">
                  <td>
                    <template v-if="broadcast.deliver_at">
                      {{ formattedDatetime(broadcast.deliver_at) }}
                    </template>
                    <template v-else>
                      <div>未配信</div>
                      <div><span class="text-sm">予約 {{ formattedDatetime(broadcast.schedule_at) }} </span></div>
                    </template>
                  </td>
                  <td>{{ broadcast.title }}</td>
                  <td><broadcast-status :status="broadcast.status"></broadcast-status></td>
                  <td><broadcast-deliver-target :broadcast="broadcast"></broadcast-deliver-target></td>
                  <td></td>
                  <td>
                    <div class="btn-group">
                      <button type="button" class="btn btn-light btn-sm dropdown-toggle" data-toggle="dropdown" aria-expanded="false"> 操作 <span class="caret"></span> </button>
                      <div class="dropdown-menu">
                        <a role="button" class="dropdown-item" @click="openEdit(broadcast)">一斉配信を編集する</a>
                        <a role="button" class="dropdown-item" data-toggle="modal" data-target="#modalcopyBroadcast" @click="curBroadcastIndex = index">一斉配信をコピー</a>
                        <a role="button" class="dropdown-item" data-toggle="modal" data-target="#modaldeleteBroadcast" @click="curBroadcastIndex = index">一斉配信を削除</a>
                      </div>
                    </div>
                  </td>
                </tr>
            </tbody>
          </table>
          <div class="d-flex justify-content-center mt-4 text-center">
            <b-pagination
              v-if="totalRows > perPage"
              v-model="currentPage"
              :total-rows="totalRows"
              :per-page="perPage"
              @change="loadPage"
              aria-controls="my-table"
            ></b-pagination>
            <b v-if="!loading && totalRows === 0">一斉配信はありません。</b>
          </div>
        </div>

        <loading-indicator :loading="loading"></loading-indicator>
      </div>
    </div>

    <!-- START: Delete broadcast modal -->
    <modal-confirm title="この一斉配信を削除してもよろしいですか？" id='modaldeleteBroadcast' type='delete' @confirm="submitdeleteBroadcast">
      <template v-slot:content>
        <div v-if="curBroadcast">
          一斉配信名：<b>{{curBroadcast.title}}</b>
        </div>
      </template>
    </modal-confirm>
    <!-- END: Delete broadcast modal -->

    <!-- START: Copy broadcast modal -->
    <modal-confirm title="この一斉配信をコピーしてもよろしいですか？" id='modalcopyBroadcast' type='confirm' @confirm="submitcopyBroadcast">
      <template v-slot:content>
        <div v-if="curBroadcast">
          一斉配信名：<b>{{curBroadcast.title}}</b>
        </div>
      </template>
    </modal-confirm>
    <!-- END: Copy broadcast modal -->
  </div>
</template>

<script>
import { mapActions, mapMutations, mapState } from 'vuex';
import Util from '@/core/util';

export default {
  data() {
    return {
      loading: true,
      contentKey: 0,
      currentPage: 1,
      curBroadcastIndex: 0
    };
  },
  async beforeMount() {
    await this.getBroadcasts();
    this.loading = false;
  },
  computed: {
    ...mapState('broadcast', {
      broadcasts: (state) => state.broadcasts,
      totalRows: (state) => state.totalRows,
      perPage: (state) => state.perPage
    }),

    curBroadcast() {
      return this.broadcasts[this.curBroadcastIndex];
    }
  },
  methods: {
    ...mapMutations('broadcast', [
      'setCurPage'
    ]),
    ...mapActions('broadcast', [
      'getBroadcasts',
      'copyBroadcast',
      'deleteBroadcast'
    ]),

    forceRerender() {
      this.contentKey++;
    },

    async loadPage() {
      // bootstrap pagination return old value of current page,
      // using nextTick to solve the issue
      this.$nextTick(async() => {
        this.loading = true;
        this.setCurPage(this.currentPage);
        await this.getBroadcasts();
        this.forceRerender();
        this.loading = false;
      });
    },

    openNew() {
      window.location.href = `${process.env.MIX_ROOT_PATH}/user/broadcasts/new`;
    },

    openEdit(broadcast) {
      window.open(`${process.env.MIX_ROOT_PATH}/user/broadcasts/${broadcast.id}/edit`);
    },

    openMessageIndex(broadcast) {
      window.location.href = `${process.env.MIX_ROOT_PATH}/user/broadcasts/${broadcast.id}/messages`;
    },

    formattedDatetime(time) {
      return Util.formattedDatetime(time);
    },

    async submitdeleteBroadcast() {
      const response = await this.deleteBroadcast(this.curBroadcast.id);
      if (response) {
        window.toastr.showSuccessThenRedirect('一斉配信の削除は完了しました。', window.location.href);
      } else {
        window.toastr.error('一斉配信の削除は失敗しました。');
      }
    },

    async submitcopyBroadcast() {
      const response = await this.copyBroadcast(this.curBroadcast.id);
      if (response) {
        Util.showSuccessThenRedirect('一斉配信のコピーは完了しました。', window.location.href);
      } else {
        window.toastr.error('一斉配信のコピーは失敗しました。');
      }
    }
  }
};
</script>

<style lang="scss" scoped>
  .text-sm {
    font-size: 0.7rem !important;
  }
</style>