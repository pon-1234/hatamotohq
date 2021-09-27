<template>
  <div>
    <div class="row">
      <div class="col-12">
        <div class="card">
          <div class="card-header d-flex align-items-center">
            <a :href="`${rootUrl}/admin/announcements/new`" class="btn btn-info fw-120 mr-2">
              <i class="fa fa-plus"></i> 新規登録
            </a>
          </div>
          <div class="card-body">
            <div class="table-responsive">
              <table class="table table-bordered mb-0">
                  <thead class="thead-light">
                    <tr>
                      <th width="5%" class="fw-50 text-center">ID</th>
                      <th width="20%" class="fw-150">日時</th>
                      <th width="40%" class="fw-200">タイトル</th>
                      <th width="20%" class="fw-150">変更日時</th>
                      <th width="15%" class="fw-100">操作</th>
                    </tr>
                  </thead>
                  <tbody v-for="announcement in announcements" :key="announcement.id">
                      <tr>
                        <td class="text-center">{{ announcement.id }}</td>
                        <td>{{ moment(announcement.announced_at) }}</td>
                        <td>{{ announcement.title }}</td>
                        <td>{{ moment(announcement.updated_at) }}</td>
                        <td>
                          <div class="btn-group">
                            <button type="button" class="btn btn-light btn-sm dropdown-toggle" id="dropdownMenuAnnouncement" data-toggle="dropdown" aria-haspopup="true" aria-expanded="false">操作 <span class="caret"></span></button>
                            <div class="dropdown-menu" role="menu" aria-labelledby="dropdownMenuAnnouncement">
                              <a :href="`${rootUrl}/admin/announcements/${announcement.id}/edit`" class="dropdown-item">編集</a>
                              <a class="dropdown-item" data-toggle="modal" data-target="#announcementDetail" @click="onShowModal(announcement.id)" >
                                プレビュー
                              </a>
                              <a :href="`${rootUrl}/admin/announcements/${announcement.id}/delete_confirm`" class="dropdown-item" data-remote="true" data-type="json">
                                削除
                              </a>
                            </div>
                          </div>
                        </td>
                      </tr>
                  </tbody>
              </table>
            </div>
            <div class="d-flex justify-content-center" v-if="totalRows && totalRows/10 > 1">
              <b-pagination
                v-model="currentPage"
                :total-rows="totalRows"
                :per-page="10"
                aria-controls="my-table"
                first-number
                last-number
                @change="changePage"
              ></b-pagination>
            </div>
            <div v-if="announcements.length == 0">
              <b>データはありません。</b>
            </div>
          </div>
        </div>
      </div>
    </div>

    <div id='confirmDelContent'></div>

    <modal-announcement-show ref="modalAnnouncementDetail" :announcements=announcements :status="`admin`"></modal-announcement-show>
  </div>
</template>
<script>
import { mapActions, mapMutations, mapState } from 'vuex';
import moment from 'moment-timezone';
export default {
  data() {
    return {
      rootUrl: process.env.MIX_ROOT_PATH,
      currentPage: 1,
      loading: true
    };
  },
  async beforeMount() {
    await this.getAnnouncements();
    this.loading = false;
  },
  computed: {
    ...mapState('announcement', {
      announcements: (state) => state.announcements,
      totalRows: (state) => state.totalRows,
      perPage: (state) => state.perPage
    }),
  },
  methods: {
    ...mapMutations('announcement', [
      'setCurPage'
    ]),
    ...mapActions('announcement', [
      'getAnnouncements'
    ]),
    moment(date) {
      return moment(date).tz('Asia/Tokyo').format('YYYY.MM.DD. HH:mm');
    },
    onShowModal(id) {
      this.$refs.modalAnnouncementDetail.shownModal(id);
    },
    async changePage(page) {
      this.$nextTick(async() => {
        this.loading = true;
        this.setCurPage(this.currentPage);
        await this.getAnnouncements();
        this.loading = false;
      });
    }
  }
};
</script>
<style lang="scss" scoped>

</style>