<template>
  <div
    id="modalFriendSearch"
    ref="modalFriendSearch"
    class="modal fade"
    tabindex="-1"
    role="dialog"
    aria-labelledby="info-header-modalLabel"
    aria-hidden="true"
  >
    <div class="modal-dialog modal-lg" :key="contentKey">
      <div class="modal-content">
        <div class="modal-header">
          <h5 class="modal-title" id="info-header-modalLabel">詳細検索</h5>
          <button type="button" class="close" data-dismiss="modal" aria-hidden="true" @click="closeModal()">×</button>
        </div>
        <div class="modal-body">
          <!-- 名前検索 -->
          <div class="row form-group">
            <div class="col-lg-4">名前</div>
            <div class="col-lg-8">
              <input
                type="text"
                id="name"
                v-model="keyword"
                class="form-control"
                placeholder="LINE登録名、表示名から検索"
                maxlength="64"
              />
            </div>
          </div>
          <!-- タグ検索 -->
          <div class="row form-group">
            <div class="col-lg-4">タグ</div>
            <div class="col-lg-8">
              <input-tag
                ref="inputTag"
                :tags="selectedTags"
                :tagIds="queryParams.tags_id_in"
                @input="onSelectTags"
                :allTags="true"
              />
            </div>
          </div>
          <!-- 登録日時 -->
          <div class="row form-group">
            <div class="col-lg-4">登録日時</div>
            <div class="col-lg-8">
              <daterange-picker class="d-block" :start_date.sync="created_at_gteq" :end_date.sync="created_at_lteq">
              </daterange-picker>
            </div>
          </div>

          <div class="row form-group">
            <div class="col-lg-4">状況</div>
            <div class="col-lg-8">
              <select class="form-control" v-model="status_eq">
                <option value="">すべて</option>
                <option value="active">有効</option>
                <option value="blocked">ブロックされた</option>
              </select>
            </div>
          </div>

          <div class="row form-group">
            <div class="col-lg-4">担当者</div>
            <div class="col-lg-8">
              <staff-selection
                :mode="'filter'"
                :selected="queryParams.channel_assignee_id_eq"
                @select="setAssigneeParam"
              ></staff-selection>
            </div>
          </div>

          <!-- ブロック、非表示した友達 -->
          <div class="mt-2 d-flex">
            <div class="flex-1 custom-control custom-checkbox mr-2">
              <input
                type="checkbox"
                class="custom-control-input"
                id="lockedFriendCheck"
                v-model="locked_eq"
                :true-value="null"
                :false-value="false"
              />
              <label class="custom-control-label" for="lockedFriendCheck">ブロックした人を表示</label>
            </div>

            <div class="flex-1 custom-control custom-checkbox">
              <input
                type="checkbox"
                class="custom-control-input"
                id="hiddenFriendCheck"
                v-model="visible_eq"
                :true-value="null"
                :false-value="true"
              />
              <label class="custom-control-label" for="hiddenFriendCheck">非表示した人を表示</label>
            </div>
          </div>
        </div>
        <div class="modal-footer d-flex">
          <button type="button" class="btn btn-sm btn-light" @click="resetSearch()">リセット</button>
          <button type="button" class="btn btn-sm btn-light ml-auto" data-dismiss="modal" @click="closeModal()">
            キャンセル
          </button>
          <button type="button" class="btn btn-sm btn-info" data-dismiss="modal" @click="search">検索</button>
        </div>
      </div>
      <!-- /.modal-content -->
    </div>
    <!-- /.modal-dialog -->
  </div>
  <!-- /.modal -->
</template>
<script>
import { mapActions, mapMutations, mapState } from 'vuex';
export default {
  data() {
    return {
      contentKey: 0,
      selectedTags: [],
      params: {}
    };
  },

  computed: {
    ...mapState('friend', {
      queryParams: state => state.queryParams,
      clearQueryParams: state => state.clearQueryParams
    }),

    keyword: {
      get() {
        return this.params.line_name_or_display_name_cont;
      },
      set(value) {
        this.params.line_name_or_display_name_cont = value;
      }
    },

    tags: {
      get() {
        return this.params.tags_id_in || [];
      },
      set(value) {
        const selectedTagIds = value.map(_ => _.id);
        this.params.tags_id_in = selectedTagIds;
      }
    },

    status_eq: {
      get() {
        return this.params.status_eq;
      },
      set(value) {
        this.params.status_eq = value;
      }
    },

    created_at_gteq: {
      get() {
        return this.params.created_at_gteq;
      },
      set(value) {
        this.params.created_at_gteq = value;
      }
    },

    created_at_lteq: {
      get() {
        return this.params.created_at_lteq;
      },
      set(value) {
        this.params.created_at_lteq = value;
      }
    },

    locked_eq: {
      get() {
        return this.params.locked_eq;
      },
      set(value) {
        this.params.locked_eq = value;
      }
    },

    visible_eq: {
      get() {
        return this.params.visible_eq;
      },
      set(value) {
        this.params.visible_eq = value;
      }
    }
  },
  methods: {
    ...mapMutations('friend', ['setQueryParams', 'setQueryParam', 'resetQueryParams', 'setClearQueryParams']),
    ...mapActions('friend', ['getFriends']),

    forceRerender() {
      this.contentKey++;
    },
    onSelectTags(tags) {
      this.tags = tags;
      this.selectedTags = tags;
    },
    search() {
      this.setQueryParams(this.params);
      this.getFriends();
    },
    resetSearch() {
      this.resetQueryParams();
      this.selectedTags = [];
      this.forceRerender();
      const resetParams = {
        page: 1,
        status_eq: 'active',
        line_name_or_display_name_cont: null,
        tags_id_in: null,
        created_at_gteq: null,
        created_at_lteq: null,
        visible_eq: true,
        locked_eq: false,
        channel_assignee_id_eq: null
      };
      Object.assign(this.params, resetParams);
    },
    closeModal() {
      this.selectedTags = [];
    },
    async showModal() {
      if (this.clearQueryParams) {
        this.selectedTags = [];
        this.setClearQueryParams(false);
      }
      this.forceRerender();
      this.params = _.cloneDeep(this.queryParams);

      if (this.params.tags_id_in) {
        this.$refs.inputTag.initData();
      }
    },

    setAssigneeParam(staffId) {
      this.params.channel_assignee_id_eq = staffId;
    }
  }
};
</script>
