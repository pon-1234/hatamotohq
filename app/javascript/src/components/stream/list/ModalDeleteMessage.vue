<template>
  <div class="modal fade modal-delete modal-common01" id="modal-delete" tabindex="-1" role="dialog" aria-labelledby="myModalLabel" aria-hidden="true">
    <div class="modal-dialog" role="document">
      <div class="modal-content">
        <div class="modal-body">
          <button type="button" class="close" data-dismiss="modal" aria-label="Close"><span aria-hidden="true">&times;</span></button>
          <p class="mb10 fz14">以下のメッセージを削除します。よろしいですか？</p>
          <dl class="flex group-modal01 no-mgn flex-wrap justify-content-between">
            <dt>配信日時</dt>
            <dd>{{formatDateTime(data.date_start)}}</dd>
            <dt>タイトル</dt>
            <dd>{{data.title}}</dd>
            <dt>配信先</dt>
            <dd>全員</dd>
            <dt>ステータス</dt>
            <dd>
              <span v-if="data.status === 'pending'">配信待ち
              </span>
              <span v-if="data.status === 'sending'">配信待ち
              </span>
              <span v-if="data.status === 'done'">配信済み
              </span>
              <span v-if="data.status === 'draft'">下書き
              </span>
              <span v-if="data.status === 'error'">配信エラー
              </span>
            </dd>
          </dl>
        </div>
        <div class="modal-footer flex center">
          <button type="button" class="btn btn-common01 btn-modal-delete" data-dismiss="modal" @click="deleteMessage">削除</button>
          <button type="button" class="btn btn-common01 btn-modal-cancel" data-dismiss="modal">キャンセル</button>
        </div>
      </div>
    </div>
  </div>
</template>
<script>
import moment from 'moment';

export default {
  props: ['data'],
  methods: {
    deleteMessage() {
      this.$emit('input', this.data.id);
    },

    formatDateTime(time) {
      return moment(time).format('YYYY年MM月DD日 HH:mm');
    }
  }
};
</script>
