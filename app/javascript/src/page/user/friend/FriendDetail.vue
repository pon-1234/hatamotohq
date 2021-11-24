<template>
  <div class="profile-detail row" v-if="friendData">
    <div class="col-xl-4 d-flex">
      <div class="card card-success card-outline w-100">
        <div class="card-body box-profile">
          <!-- profile image -->
          <div class="text-center">
            <img v-lazy="avatarImgObj" class="rounded-circle avatar-lg img-thumbnail" alt="profile-image" />
          </div>
          <!-- line user name -->
          <h3 class="profile-username text-center">{{ friendData.line_name }}</h3>

          <span class="d-flex flex-row w-100">
            <friend-toggle-visible
              :id="friendData.id"
              :visible="friendData.visible"
              class="ml-auto mr-1"
            ></friend-toggle-visible>
            <friend-toggle-locked
              :id="friendData.id"
              :locked="friendData.locked"
              class="mr-auto"
            ></friend-toggle-locked>
          </span>

          <ul class="list-group list-group-unbordered my-3">
            <!-- locked -->
            <li class="list-group-item">
              <b>ステータス</b>
              <span class="float-right"
                ><friend-status
                  :status="friendData.status"
                  :locked="friendData.locked"
                  :visible="friendData.visible"
                ></friend-status
              ></span>
            </li>

            <!-- go to chat -->
            <li class="list-group-item">
              <b>トーク</b
              ><a class="float-right" :href="`/user/channels/${channel_id}`"
                ><i class="uil-comment-alt-dots"></i> メッセージ</a
              >
            </li>

            <!-- friend addition time -->
            <li class="list-group-item">
              <b>登録日</b><span class="float-right">{{ friendData.created_at | formatted_time }}</span>
            </li>
          </ul>
        </div>
        <!-- /.card-body -->
        <loading-indicator :loading="loading"></loading-indicator>
      </div>
      <!-- /.card -->
    </div>
    <div class="col-xl-8">
      <div class="card card-success card-outline">
        <div class="card-header d-flex align-items-center">
          <h4>詳細情報</h4>
        </div>
        <div class="card-body">
          <p class="mb-1"><strong>表示名</strong></p>
          <p class="text-muted mt-2">
            <input
              type="text"
              placeholder="表示名"
              class="form-control"
              v-model.trim="friendData.display_name"
              name="display_name"
              ref="displayName"
              :disabled="!editing"
              v-validate="'max:255'"
              data-vv-as="表示名"
            />
            <error-message :message="errors.first('display_name')"></error-message>
          </p>
          <hr />

          <p class="mt-3 mb-1"><strong>メモ欄</strong></p>
          <p class="text-muted mt-2">
            <textarea
              rows="2"
              class="form-control"
              v-model="friendData.note"
              name="note"
              :disabled="!editing"
              v-validate="'max:2000'"
              data-vv-as="メモ欄"
            ></textarea>
            <error-message :message="errors.first('note')"></error-message>
          </p>
          <hr />

          <p class="mt-3 mb-1"><strong>タグ</strong></p>
          <p class="text-muted mt-2">
            <friend-tag :tags="friendData.tags" v-if="!editing"></friend-tag>
            <input-tag :tags="friendData.tags" @input="selectTags" :allTags="true" v-if="editing" />
          </p>
          <hr />
          <div v-if="!editing" @click="editing = true" class="btn btn-success fw-120">編集</div>
          <div class="btn btn-success fw-120" @click="onSave()" v-show="editing">更新</div>
        </div>
        <loading-indicator :loading="loading"></loading-indicator>
      </div>
    </div>

    <div class="col-xl-12">
      <ul class="nav nav-tabs">
        <li class="nav-item">
          <a href="#customInfo" data-toggle="tab" aria-expanded="true" class="nav-link active">
            <i class="mdi mdi-home-variant d-md-none d-block"></i>
            <span class="d-none d-md-block">友達情報</span>
          </a>
        </li>
        <li class="nav-item">
          <a href="#reminder" data-toggle="tab" aria-expanded="true" class="nav-link">
            <i class="mdi mdi-home-variant d-md-none d-block"></i>
            <span class="d-none d-md-block">リマインダ</span>
          </a>
        </li>
      </ul>

      <div class="tab-content">
        <!-- 友達情報 -->
        <div class="tab-pane show active border border-light" id="customInfo">
          <div class="card m-0 p-0">
            <div class="card-body p-0">
              <table class="table table-striped table-centered">
                <tbody>
                  <tr v-for="(variable, index) in variables" :key="index">
                    <th>{{ variable.name }}</th>
                    <td v-if="variable.type === 'image' && variable.value">
                      <div v-lazy:background-image="variable.value" class="fw-120 fh-81 background-cover"></div>
                    </td>
                    <td v-else-if="variable.type === 'pdf' && variable.value">
                      <img :src="`${rootPath}/images/messages/pdf.png`" class="fw-120 fh-120 background-cover" />
                      <a class="btn btn-sm btn-light" :href="variable.value" download="lineinsight.pdf">ダウンロード</a>
                    </td>
                    <td v-else>{{ variable.value || "未設定" }}</td>
                  </tr>
                </tbody>
              </table>
            </div>
          </div>
        </div>

        <!-- リマインダー -->
        <div class="tab-pane show border border-light" id="reminder">
          <div class="card">
            <div class="card-body">
              <div class="row">
                <label class="col-lg-3">リマインダ</label>
                <label class="col-lg-9">ゴール日時</label>
              </div>
              <friend-assign-reminder :friend_id="friend_id"></friend-assign-reminder>
            </div>
          </div>

          <div class="card mt-2">
            <div class="card-header"><h5>最新リマインダ</h5></div>
            <div class="card-body py-0">
              <table class="table">
                <thead class="thead-light">
                  <tr>
                    <th>リマインダ名</th>
                    <th>登録日時</th>
                    <th>ゴール</th>
                  </tr>
                </thead>
                <tbody>
                  <tr v-for="(reminder, index) in reminders" :key="index">
                    <td>{{ reminder.name }}</td>
                    <td>{{ reminder.created_at | formatted_time }}</td>
                    <td>{{ reminder.goal | formatted_time }}</td>
                  </tr>
                </tbody>
              </table>

              <div v-if="reminders.length === 0" class="text-center my-3">リマインダがありません。</div>
            </div>
          </div>
        </div>
      </div>
    </div>
  </div>
</template>

<script>
import { mapActions, mapState } from 'vuex';

export default {
  props: {
    friend_id: Number,
    channel_id: Number
  },
  data() {
    return {
      rootPath: process.env.MIX_ROOT_PATH,
      friendData: {
        status: 'active',
        locked: null,
        visible: null,
        line_name: '',
        line_picture_url: '',
        display_name: '',
        note: ''
      },
      variables: [],
      avatarImgObj: {
        src: '',
        error: '/img/no-image-profile.png',
        loading: '/images/loading.gif'
      },
      friendIndexPath: `${process.env.MIX_ROOT_PATH}/user/friends`,
      isShowDisplayName: false,
      field_index: null,
      currentTab: '友だち情報名',
      loading: true,
      editing: false
    };
  },

  async beforeMount() {
    const response = await this.getFriend(this.friend_id);
    this.friendData = _.cloneDeep(response);
    this.variables = await this.getVariables(this.friend_id);
    await this.getReminders(this.friend_id);
    this.avatarImgObj.src = this.friendData.line_picture_url;
    this.loading = false;
  },

  computed: {
    ...mapState('friend', {
      reminders: state => state.reminders
    })
  },

  methods: {
    ...mapActions('friend', ['getFriend', 'updateFriend', 'getReminders', 'getVariables']),

    selectTags(tags) {
      this.friendData.tags = tags;
    },

    async onSave() {
      const valid = await this.$validator.validateAll();
      if (!valid) return;
      this.loading = true;
      const formData = {
        id: this.friendData.id,
        display_name: this.friendData.display_name,
        note: this.friendData.note,
        tag_ids: this.friendData.tags ? this.friendData.tags.map(_ => _.id) : []
      };
      const response = await this.updateFriend(formData);
      if (response) {
        window.toastr.success('友だち情報の更新が成功しました。');
      } else {
        window.toastr.error('友だち情報の更新が失敗しました。');
      }
      this.editing = false;
      this.loading = false;
    },

    onSelectReminder() {
      // TODO
    }
  }
};
</script>
