<template>
  <div class="profile-detail row" v-if="friendData">
    <div class="col-xl-4 d-flex">
      <div class="card card-success card-outline w-100">
        <div class="card-body box-profile">
          <!-- profile image -->
          <div class="text-center">
            <img
              :src="friendData.line_picture_url ? friendData.line_picture_url : '/img/no-image-profile.png'"
              class="rounded-circle avatar-lg img-thumbnail"
              alt="profile-image"
            />
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
              ><a class="float-right" :href="`/user/channels/${channel_id}`" data-turbolinks="false"
                ><i class="uil-comment-alt-dots"></i> メッセージ</a
              >
            </li>

            <!-- friend addition time -->
            <li class="list-group-item">
              <b>登録日</b><span class="float-right">{{ formatDateTime(friendData.created_at) }}</span>
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
              v-model="friendData.display_name"
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
      <ul class="nav nav-tabs mb-3">
        <li class="nav-item">
          <a href="#reminder" data-toggle="tab" aria-expanded="true" class="nav-link active">
            <i class="mdi mdi-home-variant d-md-none d-block"></i>
            <span class="d-none d-md-block">リマインダ</span>
          </a>
        </li>
        <li class="nav-item">
          <a href="#scenario" data-toggle="tab" aria-expanded="false" class="nav-link">
            <i class="mdi mdi-account-circle d-md-none d-block"></i>
            <span class="d-none d-md-block">シナリオ</span>
          </a>
        </li>
      </ul>

      <div class="tab-content">
        <div class="tab-pane show active" id="reminder">
          <div>
            <div class="row">
              <label class="col-xl-3">リマインダ</label>
              <label class="col-xl-9">ゴール日時</label>
            </div>
            <friend-assign-reminder :friend_id="friend_id"></friend-assign-reminder>
          </div>

          <div class="card mt-2">
            <div class="card-header"><h5>リマインダ履歴</h5></div>
            <div class="card-body">
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
                    <td>{{ reminder.created_at }}</td>
                    <td>{{ reminder.goal }}</td>
                  </tr>
                </tbody>
              </table>
            </div>
          </div>
        </div>
        <div class="tab-pane" id="scenario">
          <p>...</p>
        </div>
      </div>
    </div>
  </div>
</template>

<script>
import moment from 'moment';
import { mapActions } from 'vuex';

export default {
  props: {
    friend_id: Number,
    channel_id: Number
  },
  data() {
    return {
      friendData: {
        status: 'active',
        locked: null,
        visible: null,
        line_name: '',
        line_picture_url: '',
        display_name: '',
        note: ''
      },
      reminders: [],
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
    this.reminders = await this.getReminders(this.friend_id);
    this.loading = false;
  },

  methods: {
    ...mapActions('friend', [
      'getFriend',
      'updateFriend',
      'getReminders'
    ]),

    selectTags(tags) {
      this.friendData.tags = tags;
    },

    formatDateTime(time) {
      return moment(time).format('YYYY.MM.DD HH:mm');
    },

    compositionend() {
      this.isEnter = false;
    },

    compositionstart() {
      this.isEnter = true;
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
