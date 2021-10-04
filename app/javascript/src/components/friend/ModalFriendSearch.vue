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
              <input type="text" id="name" v-model="keyword" class="form-control" placeholder="LINE登録名、表示名から検索">
            </div>
          </div>
          <!-- タグ検索 -->
          <div class="row form-group">
            <div class="col-lg-4">タグ</div>
            <div class="col-lg-8">
              <input-tag @input="onSelectTags" :allTags="true"/>
            </div>
          </div>
          <!-- 登録日時 -->
          <div class="row form-group">
            <div class="col-lg-4">登録日時</div>
            <div class="col-lg-8">
              <daterange-picker
                class="d-block"
                :start_date.sync="created_at_gte"
                :end_date.sync="created_at_lte">
              </daterange-picker>
            </div>
          </div>

          <div class="row from-group">
            <div class="col-lg-4">状況</div>
            <div class="col-lg-8">
              <select class="form-control" v-model="status_eq">
                <option value="">すべて</option>
                <option value="active">正常</option>
                <option value="blocked">ブロック中</option>
              </select>
            </div>
          </div>
          <!-- ブロック、非表示した友達 -->
          <div class="custom-control custom-checkbox mt-2">
            <input type="checkbox" class="custom-control-input" id="hiddenFriendCheck" v-model="visible_eq">
            <label class="custom-control-label" for="hiddenFriendCheck">自分が非表示・ブロックした人を表示</label>
          </div>
        </div>
        <div class="modal-footer">
          <button type="button" class="btn btn-sm btn-light" data-dismiss="modal">キャンセル</button>
          <button type="button" class="btn btn-sm btn-info" data-dismiss="modal" @click="search">検索</button>
        </div>
      </div><!-- /.modal-content -->
    </div><!-- /.modal-dialog -->
  </div><!-- /.modal -->
</template>
<script>
import { mapActions, mapMutations, mapState } from 'vuex';
export default {
  computed: {
    ...mapState('friend', {
      queryParams: (state) => state.queryParams
    }),
    keyword: {
      get() { return this.queryParams.line_name_or_display_name_cont; },

      set(value) { this.setQueryParam({ line_name_or_display_name_cont: value }); }
    },

    tags: {
      get() { return this.queryParams.tags_id_in || []; },

      set(value) {
        const tagIds = value.map(_ => _.id);
        this.setQueryParam({ tags_id_in: tagIds });
      }
    },

    status_eq: {
      get() { return this.queryParams.status_eq; },
      set(value) { this.setQueryParam({ status_eq: value }); }
    }
  },
  methods: {
    ...mapMutations('friend', [
      'setQueryParams',
      'setQueryParam'
    ]),
    ...mapActions('friend', [
      'getFriends'
    ]),
    onSelectTags(tags) {
      this.tags = tags;
    },
    search() {
      this.setQueryParams(this.queryParams);
      this.getFriends();
    }
  }
};
</script>
