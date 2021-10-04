<template>
  <div class="profile-detail row" v-if="friendData">
    <div class="col-lg-4 d-flex">
      <div class="card card-success card-outline w-100">
        <div class="card-body box-profile">
          <!-- profile image -->
          <div class="text-center">
            <img :src="friendData.line_picture_url ? friendData.line_picture_url : '/img/no-image-profile.png'" class="rounded-circle avatar-lg img-thumbnail" alt="profile-image">
          </div>
          <!-- line user name -->
          <h3 class="profile-username text-center">{{ friendData.line_name }}</h3>
          <ul class="list-group list-group-unbordered mb-3">
            <!-- locked -->
            <li class="list-group-item">
              <b>ステータス</b> <span class="float-right d-flex flex-row">
                <friend-toggle-visible :id="friendData.id" :visible="friendData.visible" class="ml-auto mr-1"></friend-toggle-visible>
                <friend-toggle-locked :id="friendData.id" :locked="friendData.locked" class="mr-auto"></friend-toggle-locked>
              </span>
            </li>

            <!-- go to chat -->
            <li class="list-group-item">
              <b>トーク</b><a class="float-right" :href="`/user/channels/${channel_id}`" data-turbolinks="false"><i class="uil-comment-alt-dots"></i> メッセージ</a>
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
    <div class="col-lg-8">
      <div class="card card-success card-outline">
        <div class="card-header d-flex align-items-center">
          <h4>詳細情報</h4>
        </div>
        <div class="card-body">
          <p class="mb-1"><strong>表示名</strong></p>
          <p class="text-muted mt-2">
            <input type="text" placeholder="表示名" class="form-control" v-model="friendData.display_name" name="display_name" ref="displayName" :disabled="!editing" v-validate="'required|max:255'" data-vv-as="表示名">
            <error-message :message="errors.first('display_name')"></error-message>
          </p>
          <hr>

          <p class="mt-3 mb-1"><strong>メモ欄</strong></p>
          <p class="text-muted mt-2">
            <textarea rows="2" class="form-control" v-model="friendData.note" name="note" :disabled="!editing" v-validate="'max:2000'" data-vv-as="メモ欄"></textarea>
            <error-message :message="errors.first('note')"></error-message>
          </p>
          <hr>

          <p class="mt-3 mb-1"><strong>タグ</strong></p>
          <p class="text-muted mt-2">
            <friend-tag :tags="friendData.tags" v-if="!editing"></friend-tag>
            <input-tag :tags="friendData.tags" @input="selectTags" :allTags="true" v-if="editing"/>
          </p>
          <hr>
          <div v-if="!editing" @click="editing = true" class="btn btn-success fw-120">編集</div>
          <div class="btn btn-success fw-120" @click="onSave()" v-show="editing">更新</div>
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
        status: 'enabled',
        line_name: '',
        line_picture_url: '',
        display_name: '',
        note: ''
      },
      friendIndexPath: `${process.env.MIX_ROOT_PATH}/user/friends`,
      MIX_SERVEY_MEDIA_FLEXA_URL: process.env.MIX_SERVEY_MEDIA_FLEXA_URL,
      isShowDisplayName: false,
      confirmedText: '',
      destinationStatusFromBot: '',
      buttonText: '',
      field_index: null,
      currentTab: '友だち情報名',
      loading: true,
      editing: false
    };
  },

  async beforeMount() {
    const response = await this.getFriend(this.friend_id);
    this.friendData = _.cloneDeep(response);
    this.loading = false;
  },

  methods: {
    ...mapActions('friend', [
      'getFriend',
      'updateFriend'
    ]),

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
      $('#modalSelectMedia').modal('show');
    },

    changeFile(file) {
      this.friendData.survey_profile[this.field_index].content.content.alias = file.alias;
      this.friendData.survey_profile[this.field_index].content.content.mine_type = file.type;
      this.friendData.survey_profile[this.field_index].content.content.name = file.name;
    }
  }
};
</script>
