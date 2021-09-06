<template>
  <div class="modal fade modal-common01" id="modal-detail" tabindex="-1" role="dialog" aria-labelledby="myModalLabel" aria-hidden="true">
      <div class="modal-dialog" role="document">
        <div class="modal-content">
          <div class="modal-body">
            <button type="button" class="close" data-dismiss="modal" aria-label="Close"><span aria-hidden="true">&times;</span></button>
            <h3 class="mb10 modal-title">メッセージ配信詳細</h3>
            <dl class="flex group-modal01 no-mgn flex-wrap justify-content-between scroll-el">
              <dt>タイトル</dt>
              <dd v-if="data">{{data.title}}</dd>
              <dt class="d-flex align-items-center">内容</dt>
              <dd v-if="data" style="background: #ededed">
                <div v-for="(item, index) in data.broadcast_messages" :key="index" class="message-detail-content d-flex align-items-center">
                  <message-content :data="item.content" ></message-content>
                  <message-type-label :data="item.content"/>
                </div>
              </dd>
              <dt>ステータス</dt>
              <dd>
                <span v-if="data && data.status === 'pending'">配信待ち
                </span>
                <span v-if="data && data.status === 'sending'">配信待ち
                </span>
                <span v-if="data && data.status === 'done'">配信済み
                </span>
                <span v-if="data && data.status === 'draft'">下書き
                </span>
                <span v-if="data && data.status === 'error'">配信エラー
                </span>
              </dd>
            </dl>
          </div>
        </div>
      </div>
    </div>
</template>

<script>
export default {
  props: ['data']
};
</script>

<style lang="scss" scoped>
.scroll-el {
  overflow-y: auto;
  max-height: 500px;
}

.message-detail-content {
  border-top: 1px solid #ccc;
  padding: 10px 10px;
}

.message-detail-content:first-child {
  border-top: none!important;
}

.modal-dialog {
  max-width: 700px!important;
}

.modal-title {
  font-weight: bold;
}

::v-deep {
  .chat-item-text {
    text-align: left!important;
  }

  .message-text-content {
    white-space: nowrap;
  }
}
</style>
