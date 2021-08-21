<template>
  <div>
    <div class="row-ttl01 flex ai_center mb40 flex-wrap justify-content-between">
      <h3 class="hdg3">プロフィール</h3>
    </div>
    <div class="profile-detail row" v-if="isRendering && friendDetail">
      <div class="col-lg-4">
        <div class="card card-success card-outline">
          <div class="card-body box-profile">
            <!-- profile image -->
            <div class="text-center">
              <img class="profile-user-img img-fluid img-circle" :src="friendDetail.line_picture_url ? friendDetail.line_picture_url : '/img/no-image-profile.png'" alt="User profile picture">
            </div>
            <!-- line user name -->
            <h3 class="profile-username text-center">{{ friendDetail.line_name }}</h3>
            <ul class="list-group list-group-unbordered mb-3">
              <!-- status (active/block) -->
              <li class="list-group-item">
                <b>ステータス</b> <span class="float-right"><friend-status :status='friendDetail.status'></friend-status></span>
              </li>
              <!-- go to chat button -->
              <li class="list-group-item">
                <b>トーク</b><a class="float-right" :href="`/talks/to/${friendDetail.channel.alias}`"><i class="fas fa-comment-dots"></i> メッセージ</a>
              </li>
              <!-- friend addition time -->
              <li class="list-group-item">
                <b>登録日</b><span class="float-right">{{ friendDetail.created_at }}</span>
              </li>
            </ul>
          </div>
          <!-- /.card-body -->
        </div>
        <!-- /.card -->
      </div>
      <div class="col-lg-8">
        <div class="card card-success">
          <div class="card-header">
            <h3 class="card-title">詳細情報</h3>
          </div>
          <div class="card-body">
            <strong><i class="fas fa-book mr-1"></i> 表示名</strong>
            <p class="text-muted mt-2">
              <input type="text" placeholder="表示名" class="form-control" v-model="friendDetail.display_name" ref="displayName">
            </p>
            <hr>

            <strong><i class="far fa-file-alt mr-1"></i> メモ欄</strong>
            <p class="text-muted mt-2">
              <textarea rows="2" class="form-control" placeholder="メモ欄" v-model="friendDetail.note"></textarea>
            </p>
            <hr>

            <strong><i class="fas fa-tag mr-1"></i> タグ</strong>
            <p class="text-muted mt-2">
              <input-tag :data="friendDetail.tags" @input="selectTags" :allTags="true"/>
            </p>
            <hr>

            <div class="btn btn-block btn-success" @click="saveInfo()">更新</div>
          </div>
          <!-- /.card-body -->
        </div>
        <!-- /.card -->
      </div>
      <div class="col-lg-12">
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
                <tr v-for="(profile, index) in  friendDetail.survey_profile" :key="index">
                  <th>{{profile.field_name}}</th>
                  <td>
                    <div v-if="profile.content !== null">
                      <!--render-->
                      <div v-if="profile.content.type === 'file'">
                        <img style="width: 150px; margin-bottom: 10px; height: 150px; object-fit: contain"
                          :src="`${MIX_SERVEY_MEDIA_FLEXA_URL}/${profile.content.content.alias}`"
                          v-if="profile.content.content.mine_type!=null && profile.content.content.mine_type.includes('image/')">
                        <div style="width: 150px; font-size: 60px" v-else><i class="fa fa-file"></i></div>
                        <div>
                          <input type="hidden" v-model="friendDetail.survey_profile[index].content.content.alias">
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
                          v-model="friendDetail.survey_profile[index].content.content"
                          :input-class="{'form-control': true}">
                        </datetime>
                      </div>
                      <div v-else style="input-group newgroup-inputs">
                        <input type="text" placeholder="" class="form-control"
                          @click.stop
                          v-model="friendDetail.survey_profile[index].content.content"
                        >
                      </div>

                    </div>
                  </td>
                </tr>
              </tbody>
            </table>
            <div class="text-center mt-5" v-if="friendDetail.survey_profile && friendDetail.survey_profile.length === 0">データがありません。</div>
          </div>
          <div v-if="currentTab === '回答一覧'" class="tbl-admin01 table-responsive fz14 text-center" style="overflow-x: scroll">
            <friend-survey-answer :friendId="friendId"></friend-survey-answer>
          </div>
        </div>
      </div>
    </div>
  </div>
</template>

<script>
import moment from 'moment';
import { mapActions } from 'vuex';
import ModalUploadFile from './ModalUploadFile.vue';

export default {
  components: { ModalUploadFile },
  props: ['friendId'],
  data() {
    return {
      MIX_SERVEY_MEDIA_FLEXA_URL: process.env.MIX_SERVEY_MEDIA_FLEXA_URL,
      isRendering: true,
      isShowDisplayName: false,
      friendDetail: null,
      confirmedText: '',
      destinationStatusFromBot: '',
      buttonText: '',
      field_index: null,
      currentTab: '友だち情報名'
    };
  },

  async created() {
    await this.getTags();
    this.getDetail();
  },
  mounted() {
  },
  methods: {
    ...mapActions('tag', [
      'getTags'
    ]),
    ...mapActions('friend', [
      'getFriendDetail',
      'editLineInfo'
    ]),

    getDetail() {
      this.getFriendDetail({ id: this.friendId }, false).then((res) => {
        // eslint-disable-next-line no-undef
        this.friendDetail = _.cloneDeep(res);
        this.reRender();
      }).catch(() => {
        history.back();
      });
    },

    reRender() {
      this.isRendering = false;
      this.$nextTick(() => { this.isRendering = true; });
    },

    selectTags(tags) {
      this.friendDetail.tags = tags;
    },

    formatDateTime(time) {
      return moment(time).format('YYYY年MM月DD日 HH:mm:ss');
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

    saveInfo() {
      this.editLineInfo(this.friendDetail).then((res) => {
        window.toastr.success('友だち情報の更新が成功しました。');
      }).catch(() => {
        window.toastr.error('友だち情報の更新が失敗しました。');
        this.getDetail();
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
        id: this.friendDetail.id,
        status_from_bot: this.destinationStatusFromBot
      }).done(res => {
        this.friendDetail.status_from_bot = this.destinationStatusFromBot;
      })
        .fail(e => {
        });
    },

    openAddFileModal(index) {
      this.field_index = index;
      $('#imageModalCenter').modal('show');
    },

    changeFile(file) {
      this.friendDetail.survey_profile[this.field_index].content.content.alias = file.alias;
      this.friendDetail.survey_profile[this.field_index].content.content.mine_type = file.type;
      this.friendDetail.survey_profile[this.field_index].content.content.name = file.name;
    }
  }
};
</script>
<style lang="scss" scoped>
  ::v-deep {
    .current-status {
      width: 150px;
      .multiple {
        line-height: 4px;
      }
    }
    .change-status {
      span {
        width: 120px;
        margin-top: -5px;
        background-color: #00B900;
        color: #ffffff;

        &.hide-btn {
          margin-right:5px;
        }

        &.current-btn {
          background-color: #5c5c5c;
        }
      }
    }

    .btn-modal-delete {
        background: #00B900;
        color: #ffffff;
        width: 150px;
    }

    .btn-modal-cancel {
        background: #e5e5e5;
        color: #5c5c5c;
        width: 150px;
    }

    .btn-common01 {
      max-width: 120px;
      background: #00B900;
    }
    .profile-detail {
      display: flex;
      flex-wrap: wrap;
    }

    a {
      cursor: pointer;
    }

    table.tbl-linebot01 {
      display: flex;
      margin: 0;

      tbody {
        padding: 0 20px;
        width: 100%;
      }
      th {
        padding-top: 10px;
        vertical-align: text-top;
        max-width: 150px;
        min-width: 150px;
        word-break: break-word;
      }
      tr td {
        padding: 10px 0;
        height: 45px;
        width: 100%;
      }

      tr td span{
        vertical-align: text-top;
      }
    }

    .profile-detail .tabs{
      display: flex;
      width: 100%;
    }
    .profile-detail .tabs>div{
      cursor: pointer;
      padding: 10px 20px;
      color: grey;
      border: 2px;
      border-bottom: 2px solid #28a745;
    }
    .profile-detail .tabs>div:hover{
      color: #28a745;
    }
    .profile-detail .tabs>div.active
    {
      color: #28a745;
      border-top-left-radius: 10px;
      border-top-right-radius: 10px;
      border-bottom: 0px;
      border-top: 2px solid;
      border-left: 2px solid;
      border-right: 2px solid;
      /*border-bottom-color: ;*/
    }
    .tab-content{
      padding-top: 10px;
      width: 100%;
    }

    @media only screen and (max-width: 911px) {
      .profile-detail {
        flex-direction: column;
        align-items: center;
      }

      th {
        max-width: 100px !important;
        min-width: 100px !important;
      }

      tbody {
        padding: 20px 0px !important;
      }
    }

  }
</style>
