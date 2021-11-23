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
                          :href="`${this.rootPath}/user/reminders/${reminder_id}/episodes/${episode.id}/edit`"
                          >配信タイミングを編集する</a
                        >
                        <a role="button" class="dropdown-item" data-toggle="modal" data-target="#modelDeleteEpisode"
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
  </div>
</template>

<script>
import { mapActions } from 'vuex';

export default {
  props: ['reminder_id'],
  data() {
    return {
      rootPath: process.env.MIX_ROOT_PATH,
      loading: false,
      contentKey: 0,
      episodes: []
    };
  },

  async beforeMount() {
    const episodes = await this.getEpisodes(this.reminder_id);
    if (episodes) {
      this.episodes = episodes;
    }
    this.loading = false;
  },

  methods: {
    ...mapActions('reminder', ['getEpisodes'])
  }
};
</script>