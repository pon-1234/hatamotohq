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
                      <th width="20%" class="fw-150">日時</th>
                      <th width="40%" class="fw-200">タイトル</th>
                      <th width="20%" class="fw-150">変更日時</th>
                      <th width="20%" class="fw-150">状況</th>
                      <th width="15%" class="fw-300">操作</th>
                    </tr>
                  </thead>
                  <tbody v-for="(announcement, index) in announcements" :key="announcement.id">
                      <tr>
                        <td>{{ formattedDatetime(announcement.announced_at) }}</td>
                        <td>{{ announcement.title }}</td>
                        <td>{{ formattedDatetime(announcement.updated_at) }}</td>
                        <td>
                          <span v-if="announcement.status == 'draft'"><i class="mdi mdi-circle text-secondary"></i> 下書き </span>
                          <span v-if="announcement.status == 'published'"><i class="mdi mdi-circle text-success"></i> 作成 </span>
                          <span v-if="announcement.status == 'unpublished'"><i class="mdi mdi-circle text-primary"></i> unpublished </span>
                        </td>
                        <td>
                          <div class="btn-group">
                            <button type="button" class="btn btn-light btn-sm dropdown-toggle" id="dropdownMenuAnnouncement" data-toggle="dropdown" aria-haspopup="true" aria-expanded="false">操作 <span class="caret"></span></button>
                            <div class="dropdown-menu" role="menu" aria-labelledby="dropdownMenuAnnouncement">
                              <a :href="`${rootUrl}/admin/announcements/${announcement.id}/edit`" class="dropdown-item">編集</a>
                              <a v-if="announcement.status && announcement.status !== 'draft'" class="dropdown-item" data-toggle="modal" data-target="#announcementConfirmSwitch" @click="onShowModalConfirmSwitch(announcement.id)">
                                switch btn
                              </a>
                              <a role="button" class="dropdown-item" data-toggle="modal" data-target="#modalDeleteAnnouncement" @click="curAnnouncementIndex = index">
                                削除
                              </a>
                            </div>
                          </div>
                          <div class="btn btn-info btn-sm" data-toggle="modal" data-target="#announcementDetail" @click="onShowModal(announcement.id)">プレビュー</div>
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

    <!-- START: Delete announcement modal -->
    <modal-confirm title="delete announcement ?" id='modalDeleteAnnouncement' type='delete' @confirm="submitDeleteAnnouncement">
      <template v-slot:content>
        <div v-if="curAnnouncement">
          シナリオ名：<b>{{curAnnouncement.title}}</b>
        </div>
      </template>
    </modal-confirm>
    <!-- END: Delete announcement modal -->


    <modal-announcement-show ref="modalAnnouncementDetail" :announcements=announcements :status="`admin`"></modal-announcement-show>
    <modal-change-announcement-status ref="modalConfirmSwitch" :announcements=announcements></modal-change-announcement-status>
  </div>
</template>
<script>
import { mapActions, mapMutations, mapState } from 'vuex';
import moment from 'moment-timezone';
import Util from '@/core/util';

export default {
  data() {
    return {
      rootUrl: process.env.MIX_ROOT_PATH,
      currentPage: 1,
      contentKey: 0,
      loading: true,
      curAnnouncementIndex: 0
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
      perPage: (state) => state.perPage,
      curPage: (state) => state.curPage
    }),

    curAnnouncement() {
      return this.announcements[this.curAnnouncementIndex];
    }
  },
  methods: {
    ...mapMutations('announcement', [
      'setCurPage'
    ]),
    ...mapActions('announcement', [
      'getAnnouncements',
      'deleteAnnouncement'
    ]),
    onShowModal(id) {
      this.$refs.modalAnnouncementDetail.shownModal(id);
    },
    onShowModalConfirmSwitch(id) {
      this.$refs.modalConfirmSwitch.shownModal(id);
    },
    forceRerender() {
      this.contentKey++;
    },
    async changePage(page) {
      this.$nextTick(async() => {
        this.loading = true;
        this.setCurPage(this.currentPage);
        await this.getAnnouncements();
        this.forceRerender();
        this.loading = false;
      });
    },
    formattedDatetime(time) {
      return Util.formattedDatetime(time);
    },
    async submitDeleteAnnouncement() {
      const response = await this.deleteAnnouncement(this.curAnnouncement.id);
      if (response) {
        window.toastr.success('success');
      } else {
        window.toastr.error('error');
      }
      this.forceRerender();
    },
  }
};
</script>
<style lang="scss" scoped>

</style>