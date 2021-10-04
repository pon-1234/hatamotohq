<template>
  <div id="modalFriendSearch" class="modal fade" tabindex="-1" role="dialog" aria-labelledby="info-header-modalLabel" aria-hidden="true">
    <div class="modal-dialog modal-lg">
      <div class="modal-content">
        <div class="modal-header">
          <h5 class="modal-title" id="info-header-modalLabel">詳細検索</h5>
          <button type="button" class="close" data-dismiss="modal" aria-hidden="true">×</button>
        </div>
        <div class="modal-body">
          <!-- 名前検索 -->
          <div class="row form-group">
            <div class="col-lg-4">名前</div>
            <div class="col-lg-8">
              <input type="text" id="name" v-model="queryParams.keyword" class="form-control">
            </div>
          </div>
          <!-- タグ検索 -->
          <div class="row form-group">
            <div class="col-lg-4">タグ</div>
            <div class="col-lg-8">
              <input-tag @input="queryParams.tags" :allTags="true"/>
            </div>
          </div>
        </div>
        <div class="modal-footer">
          <button type="button" class="btn btn-sm btn-light" data-dismiss="modal">キャンセル</button>
          <button type="button" class="btn btn-sm btn-info" data-dismiss="modal" @click="confirm">確定</button>
        </div>
      </div><!-- /.modal-content -->
    </div><!-- /.modal-dialog -->
  </div><!-- /.modal -->
</template>
<script>
import { mapActions, mapGetters } from 'vuex';
export default {
  data() {
    return {
      queryParams: null
    };
  },
  created() {
    this.queryParams = _.cloneDeep(this.getQueryParams);
  },
  computed: {
    ...mapGetters('friend', [
      'getQueryParams'
    ])
  },
  methods: {
    ...mapActions('friend', [
      'setQueryParams'
    ]),
    confirm() {
      this.$emit('confirm');
    }
  }
};
</script>
