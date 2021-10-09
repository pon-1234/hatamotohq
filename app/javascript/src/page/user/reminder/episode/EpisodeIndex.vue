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
          <table class="table table-centered mb-0">
            <thead class="thead-light">
              <tr>
                <th>配信日時</th>
                <th>アクション</th>
                <th>メッセージ</th>
                <th class="fw-150"></th>
              </tr>
            </thead>
            <tbody>
              <tr>
                <td>開始時</td>
                <td>
                  <div>テキストを送信する</div>
                  <divider></divider>
                  <div>テンプレートを送信する</div>
                </td>
                <td>開始時</td>
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
                      <a role="button" class="dropdown-item">配信タイミングを編集する</a>
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
      curBroadcastIndex: 0,
      queryParams: null
    };
  },

  async beforeMount() {
    await this.getEpisodes(this.reminder_id);
    this.loading = false;
  },

  methods: {
    ...mapActions('reminder', [
      'getEpisodes'
    ])
  }
};
</script>