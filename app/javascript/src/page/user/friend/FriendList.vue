<template>
  <div>
    <div class="row-ttl01 flex  ai_center mb40 flex-wrap justify-content-between">
      <div class="flex-column-x" style="width: 100%">
          <h3 class="hdg3">
            <span>友だちリスト</span>
            <button v-if="hasPermisionPid('get-friends') && plan.level !== '2'" class="btn fetch-friends " @click="fetchListFriend"><i class="fas fa-sync"></i></button>
          </h3>
          <div class="row-ttl02 flex flex-column-x" style="margin: auto 0; ">
            <div class="box-search fz14">
              <input type="text" v-model="keyword" placeholder="検索する" />
              <button type="submit" @click="filterBasic()">
                <i class="fa fa-search" aria-hidden="true"></i>
              </button>
            </div>
            <div class="btn-detail fz14" id="btn-detail" style="width: auto; display: flex;">
              <a href="javascript:void(0);" @click="showFilter()">
                <span>詳細検索</span>
              </a>
            </div>
          </div>
      </div>
      <div class="box-detail">
        <friend-filter @input="changeFilter" />
      </div>
    </div>

    <!--TABLE-->
    <div class="tbl-admin01 tbl-linebot01 table-responsive fz14 text-center">
      <b-table
        responsive="sm"
        class="table-hover"
        :busy="isBusy"
        :items="tableData"
        :fields="fields"
        :per-page="perPage"
        sort-icon-left
        @row-clicked="goToTalk"
        @sort-changed="sortingChanged"
      >
        <template v-slot:table-busy>
          <div class="text-center text-danger my-2">
            <b-spinner class="align-middle"></b-spinner>
          </div>
        </template>

        <template v-slot:cell(#)="data">{{ (data.index + 1) + perPage*(currentPage - 1) }}</template>
        <template v-slot:cell(line_customers.line_name)="data">
          <div class="avatar-item">
            <img :src="data.item.line_customer.line_picture_url ? data.item.line_customer.line_picture_url : '/img/no-image-profile.png'">
          </div>
          <span class="x-fix-name"> {{ data.item.line_customer.display_name || data.item.line_customer.line_name }}</span>
          </template>
        <template v-slot:cell(created_at)="data"><span>{{formatDateTime(data.item.created_at)}}</span></template>
        <template v-slot:cell(tags)="data">
          <span  v-if="data.item.tags.length > 0">
            <span class="tag1 selected tag-selected" v-for="(tag, index) in data.item.tags" :key="index" >{{tag.name}}</span>
          </span>
          <span v-else> なし </span>
        </template>

        <template v-slot:cell(status)="data" >
          <span v-if="data.item.status === 'active' && data.item.status_from_bot === 'active'" class="status complete">
            正常
          </span>
          <span v-if="data.item.status === 'active' && data.item.status_from_bot === 'hide'" class="status" style="color: #eb5213">
            非表示
          </span>
          <span v-if="data.item.status === 'active' && data.item.status_from_bot === 'block'" class="status complete" style="color: #dc3545">
            ブロック中
          </span>
          <span v-else-if="data.item.status === 'block' && data.item.status_from_bot === 'active'" class="status draft">
            友達からブロック
          </span>
          <span v-else-if="data.item.status === 'block' && data.item.status_from_bot === 'hide'" class="status draft">
            友達からブロック<br> <span style="color: #eb5213">非表示</span>
          </span>
          <span v-else-if="data.item.status === 'block' && data.item.status_from_bot === 'block'" class="status draft">
            友達からブロック<br> <span style="color: #dc3545">ブロック中</span>
          </span>
        </template>

        <template v-slot:cell(action)="data">
          <b-button
            class="btn-more btn-more-linebot btn-block"
            @click="showFriendDetail(data.item)"
          >
            <span>詳細</span>
          </b-button>
        </template>
      </b-table>

    </div>
    <div style="text-align: center">
    <b-pagination v-if="totalRows > 0"
                  v-model="currentPage"
                  :total-rows="totalRows"
                  :per-page="perPage"
                  @change="changePage">
    </b-pagination>
    </div>

    <!--MOdal-->
    <modal-friend-detail :data="friendDetail" @editTag="editTag"/>
    <modal-alert :title="'友達をロードするために少し待ってください'"></modal-alert>

  </div>
</template>

<script>
import { mapActions, mapState } from 'vuex';
import moment from 'moment';

export default {
  props: ['data', 'permissions', 'plan'],
  data() {
    return {
      isBusy: false,
      perPage: 0,
      totalRows: 0,
      tableData: [],
      currentPage: 1,
      fields: [
        { key: '#', label: 'No.', sortable: false, thClass: 'th-none-event' },
        { key: 'line_customers.line_name', label: '名前', sortable: true, tdClass: 'friend-name', thClass: 'th-friend-name w20', thStyle: 'min-width: 150px' },
        { key: 'created_at', label: '登録日', sortable: true, thClass: 'th-friend-created w20', thStyle: 'min-width: 188px' },
        { key: 'tags', label: 'タグ', sortable: false, thClass: 'th-none-event', thStyle: 'min-width: 150px' },
        { key: 'status', label: 'ステータス', sortable: false, thClass: 'text-center' },
        { key: 'action', label: '', sortable: false, thClass: 'th-none-event' }
      ],
      friendDetail: null,
      query: {},
      keyword: '',
      isFilter: false,
      isShowTags: false
    };
  },
  beforeMount() {
    this.getFriendList({ page: 1 });
    this.getTags();
  },

  computed: {
    ...mapState('system', {
      success: state => state.success
    })
  },
  methods: {
    ...mapActions('tag', [
      'getTags'
    ]),

    hasPermisionPid(pid) {
      return this.permissions && this.permissions.firstWhere(permision => permision.pid === pid);
    },

    showFilter() {
      this.isFilter = !this.isFilter;
    },

    showFriendDetail(data) {
      this.goToTalk(data);
    },

    filterBasic() {
      this.isFilter = false;
      document.querySelectorAll('.box-detail').forEach(e => {
        e.style.display = 'none';
      });
      document.getElementById('btn-detail').className = 'btn-detail fz14';
      this.query = Object.assign({ page: 1 }, { keyword: this.keyword, sort_by: this.query.sort_by, sort_type: this.query.sort_type });
      this.getFriendList(this.query);
    },

    changePage(page = 1) {
      this.getFriendList(Object.assign(this.isFilter ? this.query : {}, { page: page }));
    },

    changeFilter(query) {
      this.getFriendList(Object.assign(this.query, { page: 1 }, query));
      this.keyword = '';
    },

    sortingChanged(ctx) {
      this.query = Object.assign(this.isFilter ? this.query : { page: this.currentPage, keyword: this.keyword }, { sort_by: ctx.sortBy, sort_type: ctx.sortDesc ? 'DESC' : 'ASC' });
      this.getFriendList(this.query);
    },

    getFriendList(query) {
      this.currentPage = query.page;
      this.$store.dispatch('friend/getList', query).done(res => {
        this.isBusy = false;
        this.tableData = res.data;
        this.perPage = res.meta.per_page;
        this.totalRows = res.meta.total;
      }).fail(e => {
        this.isBusy = false;
      });
    },

    editTag(tags) {
      this.friendDetail.tags = tags;
    },

    fetchListFriend() {
      this.$store.dispatch('friend/fetchFriends').done(res => {
        if (res) {
          $('#modal-alert').modal('show');
        }
      }).fail(e => {
        window.toastr.success(e.responseJSON.message[0]);
      });
    },

    formatDateTime(time) {
      return moment(time).format('YYYY年MM月DD日 HH:mm:ss');
    },

    goToTalk(data) {
      window.location.href = process.env.MIX_ROOT_PATH + '/friends/' + data.id + '/detail';
    }
  }
};
</script>

<style lang="scss"  scoped>
  ::v-deep {

      .flex-column-x{
          display: flex;
      }
    @media (max-width: 375px) {
      .flex-column-x{
        display: inline-flex;
        flex-direction: column;
      }

      .btn-detail a, .btn-common02 a, .btn-submit {
       margin-top: 10px;
      }
    }

    .hdg3 {
      margin: 15px 0 !important;
    }

    .friend-name {
      display: flex;
      align-items: center;
    }
    .avatar-item {
      width: 45px;
      height: 45px;
      background: #9a9a9a;
      border-radius: 50%;
      display: inline-block;
      margin-right: 5px;
      img {
          width: 100%;
          height: 100%;
          object-fit: cover;
          border-radius: 50%;
      }
    }

    td,
    th {
      text-align: left!important;
    }

    .th-none-event {
      pointer-events: none!important;
    }

    .sr-only {
      display: none!important;
    }
  }

  .btn-more span:after{
    top: 0px!important;
  }

  .btn-more {
    background: white;
    span{
      color: black;
    }
  }

  .btn-more:hover {
    span{
      color: #fff!important;
    }
  }
  .text-center{
    text-align: center !important;
  }

.fetch-friends {
  background: #00B900;
  margin-right: auto;
  color: white;
}
</style>
