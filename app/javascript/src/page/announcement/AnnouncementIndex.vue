<template>
  <div>
    <div class="row">
      <div class="col-12">
        <div class="card">
          <div class="card-header d-flex align-items-center">
            <a :href="`${rootUrl}/admin/announcements/new`" class="btn btn-info fw-120 mr-2">
              <i class="uil-plus"></i> 新規登録
            </a>
          </div>
          <div class="card-body">
            <div class="table-responsive">
              <table class="table table-bordered mb-0">
                  <thead class="thead-light">
                    <tr>
                      <th>日時</th>
                      <th>タイトル</th>
                      <th>変更日時</th>
                      <th>状況</th>
                      <th class="fw-300">操作</th>
                    </tr>
                  </thead>
                  <tbody v-for="(announcement, index) in announcements" :key="announcement.id">
                      <tr>
                        <td>{{ formattedDatetime(announcement.announced_at) }}</td>
                        <td>{{ announcement.title }}</td>
                        <td>{{ formattedDatetime(announcement.updated_at) }}</td>
                        <td>
                          <announcement-status :announcement="announcement"></announcement-status>
                        </td>
                        <td>
                          <div class="btn-group">
                            <button type="button" class="btn btn-light btn-sm dropdown-toggle" data-toggle="dropdown" aria-expanded="false"> 操作 <span class="caret"></span> </button>
                            <div class="dropdown-menu">
                              <a :href="`${rootUrl}/admin/announcements/${announcement.id}/edit`" role="button" class="dropdown-item">お知らせを編集</a>
                              <a v-if="announcement.status && announcement.status !== 'draft'" role="button" class="dropdown-item" data-toggle="modal" data-target="#modalToggleStatusAnnouncement" @click="curAnnouncementIndex = index">
                                <span v-if="announcement.status === 'unpublished'">公開にする</span>
                                <span v-else>未公開にする</span>
                              </a>
                              <a role="button" class="dropdown-item" data-toggle="modal" data-target="#modalDeleteAnnouncement" @click="curAnnouncementIndex = index">お知らせを削除</a>
                            </div>
                          </div>
                          <div class="btn btn-light btn-sm" data-toggle="modal" data-target="#modalAnnouncementDetail" @click="curAnnouncementIndex = index">プレビュー</div>
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
                @change="loadPage"
              ></b-pagination>
            </div>
            <div class="text-center mt-4" v-if="announcements.length == 0">
              <b>データはありません。</b>
            </div>
          </div>
        </div>
      </div>
    </div>

    <!-- START: Delete announcement modal -->
    <modal-confirm title="このお知らせを削除もよろしいですか？" id='modalDeleteAnnouncement' type='delete' @confirm="submitDeleteAnnouncement">
      <template v-slot:content>
        <div v-if="curAnnouncement">
          お知らせタイトル：<b>{{curAnnouncement.title}}</b>
        </div>
      </template>
    </modal-confirm>
    <!-- END: Delete announcement modal -->

    <!-- START: Toggle status (published/unpublished) -->
    <modal-confirm title="このお知らせの状況を変更してもよろしいですか？" id='modalToggleStatusAnnouncement' type='confirm' @confirm="submitToggleStatus">
      <template v-slot:content>
        <div v-if="curAnnouncement">
          <b>{{ curAnnouncement.status === 'published' ? '公開' : '未公開' }}</b> <i class="mdi mdi-arrow-right-bold"></i> <b>{{ curAnnouncement.status === 'published' ? '未公開' : '公開' }}</b>
        </div>
      </template>
    </modal-confirm>
    <!-- END: Toggle status (published/unpublished) -->

    <modal-announcement-detail :announcement="curAnnouncement"></modal-announcement-detail>
  </div>
</template>
<script>
import { mapActions, mapMutations, mapState } from 'vuex';
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
      'deleteAnnouncement',
      'updateAnnouncement'
    ]),

    forceRerender() {
      this.contentKey++;
    },

    async loadPage(page) {
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
        Util.showSuccessThenRedirect('お知らせの削除は完了しました。', `${this.rootUrl}/admin/announcements`);
      } else {
        window.toastr.error('お知らせの削除は失敗しました。');
      }
    },

    async submitToggleStatus() {
      const data = {
        id: this.curAnnouncement.id,
        status: (this.curAnnouncement.status === 'unpublished') ? 'published' : 'unpublished'
      };
      const response = await this.updateAnnouncement(data);
      if (response) Util.showSuccessThenRedirect('お知らせ状況の変更は完了しました。', `${this.rootUrl}/admin/announcements`);
      else window.toastr.error('お知らせ状況の変更は失敗しました。');
    }
  }
};
</script>