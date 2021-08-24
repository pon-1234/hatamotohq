<template>
  <div>
    <filter-message @input="changeFilter"/>

    <div class="tbl-admin01 tbl-linebot01 table-responsive tbl-stream01 fz14 text-center">
      <b-table
        responsive="sm"
        class="table-hover"
        :busy="isBusy"
        :items="messages"
        :fields="fields"
        :per-page="perPage"
        @row-clicked="showDetailMessage"
        @sort-changed="sortingChanged"
      >
        <template v-slot:table-busy>
          <div class="text-center text-danger my-2">
            <b-spinner class="align-middle"></b-spinner>
          </div>
        </template>

        <template v-slot:cell(schedule_at)="data">
          <span v-if="data.item.status === 'done'">{{formatDateTime(data.item.schedule_at)}}</span>
          <span v-else>未配信 </span>
        </template>
        <template v-slot:cell(title)="data">{{data.item.title}}</template>
        <template v-slot:cell(tags)="data">
          <div v-if="data.item.tags && data.item.tags.length > 0" >
            <span class="tag1 selected tag-selected" v-for="(tag, index) in data.item.tags" :key="index"  @click.stop="showListFriends(tag.id)" data-toggle="modal" data-target="#modal-friends-tag">{{tag.name}}</span>
          </div>
          <div v-else>全員</div>
        </template>
        <template v-slot:cell(status)="data">
          <span class="status reserve" v-if="data.item.status === 'pending'">配信予約
              </span>
              <span class="status sending" v-if="data.item.status === 'sending'">配信待ち
              </span>
              <span class="status complete" v-if="data.item.status === 'done'">配信済み
              </span>
              <span class="status draft" v-if="data.item.status === 'draft'">下書き
              </span>
        </template>

        <template v-slot:cell(action)="data">
          <div v-if="data.item.status != 'done'" class="btn-edit01" data-toggle="tooltip" title="編集">
            <a  class="btn-more btn-more-linebot btn-block" @click.stop="moveToEdit(data.item.id)"><i class="fas fa-edit"></i></a>
          </div>
          <div class="btn-copy01" data-toggle="tooltip" title="複製">
            <a href="#" class="btn-more btn-more-linebot btn-block" data-toggle="modal" data-target="#modal-confirm"  @click.stop="setCopyMessageId(data.item.id)"><i class="fas fa-copy"></i></a>
          </div>
          <div v-if="data.item.status != 'done'" class="btn-delete01" data-toggle="tooltip"  title="削除">
            <a class="btn-more btn-more-linebot btn-block" data-toggle="modal" data-target="#modal-delete" @click.stop="deleteMessage(data.item)">
              <i class="fas fa-trash-alt"></i>
            </a>
          </div>
        </template>
      </b-table>

    </div>
    <div style="text-align: center">
      <b-pagination
              v-model="currentPage"
              :total-rows="total"
              :per-page="perPage"
              aria-controls="my-table"
              @change="changePage"
      ></b-pagination>
    </div>
    <modal-delete-message v-bind:data="messageDetail" v-if="messageDetail" @input="submitDeleteMessage"/>
    <modal-confirm v-bind:title="'コピーしますか？'" type='confirm' @input="confirmCopy"/>
    <modal-detail-message-deliver :data="messageDetail"/>
    <modal-list-friends-tag :friends="friendsTag"/>
  </div>
</template>
<script>
import { mapState, mapActions } from 'vuex';
import Util from '@/core/util';
import moment from 'moment';

export default {
  data() {
    return {
      currentPage: 1,
      messageDetail: null,
      copyMessageId: null,
      isBusy: true,
      fields: [
        { key: 'schedule_at', label: '配信日時', sortable: true, thClass: 'w15' },
        { key: 'title', label: 'タイトル', sortable: true, thClass: 'w15', thStyle: 'min-width: 115px;' },
        { key: 'tags', label: '配信先', sortable: false, thClass: 'th-none-event w25' },
        { key: 'status', label: 'ステータス', sortable: true, thClass: 'w15' },
        { key: 'action', label: '', sortable: false, thClass: 'th-none-event w30', tdClass: 'row-btn', thStyle: 'min-width: 212px;' }
      ]
    };
  },

  watch: {
    success: {
      handler(val) {
        if (val.status) {
          window.toastr.success(val.message);
        } else {
          window.toastr.error(val.message);
        }
      },
      deep: true
    }
  },

  computed: {
    ...mapState('message', {
      messages: state =>
        state.messages,
      params: state =>
        state.params,
      total: state =>
        state.total,
      perPage: state =>
        state.per_page
    }),
    ...mapState('system', {
      success: state => state.success
    }),

    ...mapState('tag', {
      friendsTag: state => state.friendsTag
    })
  },

  created() {
    if (performance.navigation.type !== performance.navigation.TYPE_RELOAD) {
      if (Util.getQueryParamsUrl('is_updated') === 'true') {
        window.toastr.success('メッセージの変更は完成しました');
      }

      if (Util.getQueryParamsUrl('is_created') === 'true') {
        window.toastr.success('メッセージ配信を登録しました');
      }
    }
  },

  async beforeMount() {
    await this.fetchItem();
    await this.getTags();
  },

  methods: {
    ...mapActions('message', ['fetchListMessageDelivers', 'setParams', 'copyMessageDelivers', 'deleteMessageDelivers']),
    ...mapActions('tag', ['getFriendsByTag']),
    ...mapActions('tag', ['getTags']),

    async fetchItem() {
      await this.fetchListMessageDelivers(this.params);
      this.isBusy = false;
    },

    async changePage(page) {
      this.setParams({ page: page });
      await this.fetchItem();
    },

    deleteMessage(message) {
      this.messageDetail = message;
      $('#modal-delete').modal('show');
    },

    showDetailMessage(message) {
      this.messageDetail = message;
      $('#modal-detail').modal('show');
    },

    submitDeleteMessage(id) {
      this.deleteMessageDelivers({ id: id });
    },

    async changeFilter(value) {
      this.setParams(value);
      await this.fetchItem();
    },

    setCopyMessageId(id) {
      this.copyMessageId = id;
      $('#modal-confirm').modal('show');
    },

    confirmCopy() {
      this.copyMessageDelivers({ id: this.copyMessageId });
    },

    async showListFriends(id) {
      await this.getFriendsByTag({ id: id });
      $('#modal-friends-tag').modal('show');
    },

    moveToEdit(id) {
      window.location.href = process.env.MIX_ROOT_PATH + '/streams/' + id;
    },

    formatDateTime(time) {
      return moment(time).format('YYYY年MM月DD日 HH:mm');
    },

    async sortingChanged(ctx) {
      // await this.setParams({ sort_by: ctx.sortBy, sort_type: ctx.sortDesc ? 'DESC' : 'ASC' });
      // await this.fetchItem();
    }
  }
};
</script>

<style lang="scss" scoped>
::v-deep {
  .message-deliver-item {
    cursor: pointer!important;
  }

  .sr-only {
    display: none!important;
  }

   .th-none-event {
    pointer-events: none!important;
  }

  .b-table tr {
      cursor: pointer!important;
  }

  .modal-dialog {
    margin: auto !important;
  }
}

</style>
