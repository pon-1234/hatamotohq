<template>
  <div class="card">
    <div class="card-header d-flex align-items-center">
      <a :href="friendIndexPath" class="text-info">
        <i class="fa fa-arrow-left"></i> 友達一覧
      </a>
    </div>
    <div class="card-body">
      <div class="profile-detail row" v-if="isRendering && friendData">
        <div class="col-lg-4">
          <div class="card card-success card-outline">
            <div class="card-body box-profile">
              <!-- profile image -->
              <div class="text-center">
                <img class="profile-user-img img-fluid img-circle" :src="friendData.line_picture_url ? friendData.line_picture_url : '/img/no-image-profile.png'" alt="User profile picture">
              </div>
              <!-- line user name -->
              <h3 class="profile-username text-center">{{ friendData.line_name }}</h3>
              <ul class="list-group list-group-unbordered mb-3">
                <!-- status (active/block) -->
                <li class="list-group-item">
                  <b>ステータス</b> <span class="float-right"><friend-status :status='friendData.status'></friend-status></span>
                </li>
                <!-- go to chat button -->
                <li class="list-group-item">
                  <b>トーク</b><a class="float-right" :href="`/user/channels/${channel_id}`"><i class="fas fa-comment-dots"></i> メッセージ</a>
                </li>
                <!-- friend addition time -->
                <li class="list-group-item">
                  <b>登録日</b><span class="float-right">{{ formatDateTime(friendData.created_at) }}</span>
                </li>
              </ul>
            </div>
            <!-- /.card-body -->
          </div>
          <!-- /.card -->
        </div>
        <div class="col-lg-8">
          <div class="card card-success card-outline">
            <div class="card-header d-flex align-items-center">
              <h3 class="card-title">詳細情報</h3>
              <div v-if="!editing" @click="editing = true" class="btn btn-sm btn-outline-success ml-auto">編集</div>
            </div>
            <div class="card-body">
              <strong><i class="fas fa-book mr-1"></i> 表示名</strong>
              <p class="text-muted mt-2">
                <input type="text" placeholder="表示名" class="form-control" v-model="friendData.display_name" ref="displayName" :disabled="!editing">
              </p>
              <hr>

              <strong><i class="far fa-file-alt mr-1"></i> メモ欄</strong>
              <p class="text-muted mt-2">
                <textarea rows="2" class="form-control" placeholder="メモ欄" v-model="friendData.note" :disabled="!editing"></textarea>
              </p>
              <hr>

              <strong><i class="fas fa-tag mr-1"></i> タグ</strong>
              <p class="text-muted mt-2">
                <input-tag :tags="friendData.tags" @input="selectTags" :allTags="true" :disabled="!editing"/>
              </p>
              <hr>

              <div class="btn btn-block btn-success" @click="onSave()" v-show="editing">更新</div>
            </div>
            <loading-indicator :loading="loading"></loading-indicator>
          </div>
        </div>
        <!-- <div class="col-lg-12">
          <div class="tabs">
            <div @click="currentTab = '友だち情報名'" :class="{'active': currentTab === '友だち情報名'}">友だち情報名</div>
            <div @click="currentTab = '回答一覧'" :class="{'active': currentTab === '回答一覧'}">回答一覧</div>
            <div style="flex: 1"></div>
          </div>
          <div class="tab-content">
            <div v-if="currentTab === '友だち情報名'">
              <table class="tbl-linebot01" id="table-friend"
                  style="width: 100%; max-width: initial;">
                <tbody>
                  <tr v-for="(profile, index) in  friend.survey_profile" :key="index">
                    <th>{{profile.field_name}}</th>
                    <td>
                      <div v-if="profile.content !== null">
                        <div v-if="profile.content.type === 'file'">
                          <img style="width: 150px; margin-bottom: 10px; height: 150px; object-fit: contain"
                            :src="`${MIX_SERVEY_MEDIA_FLEXA_URL}/${profile.content.content.alias}`"
                            v-if="profile.content.content.mine_type!=null && profile.content.content.mine_type.includes('image/')">
                          <div style="width: 150px; font-size: 60px" v-else><i class="fa fa-file"></i></div>
                          <div>
                            <input type="hidden" v-model="friend.survey_profile[index].content.content.alias">
                            <button type="button" class="btn btn-secondary"
                              @click="openAddFileModal(index)">
                              <i class="fa fa-upload"></i> ファイルをアップロード
                            </button>
                          </div>
                          <div v-if="profile.content.content.name">
                            <a style="color: #28a745"
                              :href="`${MIX_SERVEY_MEDIA_FLEXA_URL}/${profile.content.content.alias}`"
                              target="_blank">
                              <i
                                class="fa fa-download"></i><span>{{trimMidString(profile.content.content.name, 25, 10)}}</span>
                            </a>
                          </div>
                        </div>
                        <div v-else-if="profile.content.type === 'date'" class="input-group newgroup-inputs">
                          <datetime
                            type="date"
                            v-model="friend.survey_profile[index].content.content"
                            :input-class="{'form-control': true}">
                          </datetime>
                        </div>
                        <div v-else style="input-group newgroup-inputs">
                          <input type="text" placeholder="" class="form-control"
                            @click.stop
                            v-model="friend.survey_profile[index].content.content"
                          >
                        </div>

                      </div>
                    </td>
                  </tr>
                </tbody>
              </table>
              <div class="text-center mt-5" v-if="friend.survey_profile && friend.survey_profile.length === 0">データがありません。</div>
            </div>
            <div v-if="currentTab === '回答一覧'" class="tbl-admin01 table-responsive fz14 text-center" style="overflow-x: scroll">
              <friend-survey-answer :friendId="friendId"></friend-survey-answer>
            </div>
          </div>
        </div> -->
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
      friendData: null,
      friendIndexPath: `${process.env.MIX_ROOT_PATH}/user/friends`,
      MIX_SERVEY_MEDIA_FLEXA_URL: process.env.MIX_SERVEY_MEDIA_FLEXA_URL,
      isRendering: true,
      isShowDisplayName: false,
      confirmedText: '',
      destinationStatusFromBot: '',
      buttonText: '',
      field_index: null,
      currentTab: '友だち情報名',
      loading: false,
      editing: false
    };
  },

  async beforeMount() {
    this.loading = true;
    const response = await this.getFriend(this.friend_id);
    this.friendData = _.cloneDeep(response);
    await this.getTags();
    this.loading = false;
  },

  methods: {
    ...mapActions('tag', [
      'getTags'
    ]),
    ...mapActions('friend', [
      'getFriend',
      'editLineInfo'
    ]),

    reRender() {
      this.isRendering = false;
      this.$nextTick(() => { this.isRendering = true; });
    },

    selectTags(tags) {
      this.friendData.tags = tags;
    },

    formatDateTime(time) {
      return moment(time).format('YYYY.MM.DD HH:mm');
    },

    editDisplayName() {
      this.isShowDisplayName = !this.isShowDisplayName;
    },

    enterSubmitName(e) {
      if (!this.isEnter) {
        this.isEnter = true;
        return;
      }
      this.$refs.buttonChangeName.click();
    },

    compositionend() {
      this.isEnter = false;
    },

    compositionstart() {
      this.isEnter = true;
    },

    onSave() {
      this.loading = true;
      const formData = {
        id: this.friendData.id,
        display_name: this.friendData.display_name,
        note: this.friendData.note,
        tag_ids: this.friendData.tags ? this.friendData.tags.map(_ => _.id) : []
      };
      this.editLineInfo(formData).then((res) => {
        window.toastr.success('友だち情報の更新が成功しました。');
      }).catch(() => {
        window.toastr.error('友だち情報の更新が失敗しました。');
      }).finally(() => {
        this.editing = false;
        this.loading = false;
      });
    },

    trimMidString(originStr, maxChars, trailingCharCount) {
      let shrinkedStr = originStr;
      const shrinkedLength = maxChars - trailingCharCount - 3;
      if (originStr.length > shrinkedLength) {
        const front = originStr.substr(0, shrinkedLength);
        const mid = '...';
        const end = originStr.substr(-trailingCharCount);
        shrinkedStr = front + mid + end;
      }
      return shrinkedStr;
    },
    autoText(data) {
      if (Array.isArray(data)) {
        let str = '';
        data.forEach((text, index) => {
          if (index > 0) {
            str += ', ';
          }
          str += text;
        });

        return str;
      }
      return data;
    },

    async updateStatusFromBot() {
      await this.$store.dispatch('friend/updateStatusFromBot', {
        id: this.friendData.id,
        status_from_bot: this.destinationStatusFromBot
      }).done(res => {
        this.friendData.status_from_bot = this.destinationStatusFromBot;
      })
        .fail(e => {
        });
    },

    openAddFileModal(index) {
      this.field_index = index;
      $('#imageModalCenter').modal('show');
    },

    changeFile(file) {
      this.friendData.survey_profile[this.field_index].content.content.alias = file.alias;
      this.friendData.survey_profile[this.field_index].content.content.mine_type = file.type;
      this.friendData.survey_profile[this.field_index].content.content.name = file.name;
    }
  }
};
</script>
