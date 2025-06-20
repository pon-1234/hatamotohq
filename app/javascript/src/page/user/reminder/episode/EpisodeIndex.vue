<template>
  <div class="row">
    <div class="col-12">
      <div class="card">
        <div class="card-header d-flex align-items-center">
          <a class="btn btn-success fw-120" :href="`${rootPath}/user/reminders/${reminder_id}/episodes/new`"
            ><i class="uil-plus"></i> 新規作成</a
          >
        </div>
        <div class="card-body mvh-50">
          <div class="table-responsive">
            <table class="table table-centered mb-0">
              <thead class="thead-light">
                <tr>
                  <th class="fw-200">配信日時</th>
                  <th class="mw-300">アクション</th>
                  <th class="mw-300">メッセージ</th>
                  <th class="fw-150"></th>
                </tr>
              </thead>
              <tbody>
                <tr v-for="(episode, index) in episodes" :key="index">
                  <td><episode-time :episode="episode"></episode-time></td>
                  <td>
                    <episode-actions :episode="episode"></episode-actions>
                  </td>
                  <td>
                    <episode-messages :episode="episode"></episode-messages>
                  </td>
                  <td>
                    <div class="btn-group">
                      <button
                        type="button"
                        class="btn btn-light btn-sm dropdown-toggle"
                        data-toggle="dropdown"
                        aria-expanded="false"
                      >
                        操作 <span class="caret"></span>
                      </button>
                      <div class="dropdown-menu">
                        <a
                          role="button"
                          class="dropdown-item"
                          :href="`${rootPath}/user/reminders/${reminder_id}/episodes/${episode.id}/edit`"
                          >配信タイミングを編集する</a
                        >
                        <a
                          role="button"
                          class="dropdown-item"
                          data-toggle="modal"
                          data-target="#modalDeleteEpisode"
                          @click="curEpisodeIndex = index"
                          >配信タイミングを削除</a
                        >
                      </div>
                    </div>
                  </td>
                </tr>
              </tbody>
            </table>
          </div>
          <div class="mt-4 text-center" v-if="episodes.length === 0"><b>登録配信タイミングはありません。</b></div>
        </div>

        <loading-indicator :loading="loading"></loading-indicator>
      </div>
    </div>
    <!-- START: Delete episode -->
    <modal-confirm
      title="本当に削除してよろしですか?"
      id="modalDeleteEpisode"
      type="delete"
      @confirm="submitDeleteEpisode"
    >
      <template v-slot:content>
        <div v-if="curEpisode">
          配信タインミングID：: <b>{{ curEpisode.id }}</b>
        </div>
      </template>
    </modal-confirm>
    <!-- END: Delete episode -->
  </div>
</template>

<script>
import { mapActions } from 'vuex';
import Util from '@/core/util';

export default {
  props: ['reminder_id'],
  data() {
    return {
      rootPath: import.meta.env.VITE_ROOT_PATH,
      loading: false,
      contentKey: 0,
      episodes: [],
      curEpisodeIndex: 0
    };
  },

  async beforeMount() {
    this.loading = true;
    const episodes = await this.getEpisodes(this.reminder_id);
    if (episodes) {
      this.episodes = episodes;
    }
    this.loading = false;
  },

  computed: {
    curEpisode() {
      return this.episodes ? this.episodes[this.curEpisodeIndex] : null;
    }
  },

  methods: {
    ...mapActions('reminder', ['getEpisodes', 'deleteEpisode']),

    async submitDeleteEpisode() {
      const params = {
        reminder_id: this.reminder_id,
        id: this.curEpisode.id
      };
      const response = await this.deleteEpisode(params);
      if (response) {
        Util.showSuccessThenRedirect(
          '配信タインミングの削除は成功しました。',
          `${this.rootPath}/user/reminders/${this.reminder_id}/episodes`
        );
      } else window.toastr.error('配信タインミングの削除は失敗しました。');
    }
  }
};
</script>