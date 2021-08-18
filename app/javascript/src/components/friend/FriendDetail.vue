<template>
  <section>
    <div v-if="friendDetail !== null">
      <div class="row-ttl01 flex ai_center mb40 flex-wrap justify-content-between">
        <h3 class="hdg3">プロフィール</h3>
      </div>
      <div class="profile-detail" v-if="isRendering">
        <div class="center" style="text-align: center; width: 150px">
          <img
            :src="friendDetail.line_customer.line_picture_url ? friendDetail.line_customer.line_picture_url : '/img/no-image-profile.png'"
            style="width: 100%; height: auto; object-fit: cover;border-radius: 50%;"
          />
        </div>

        <table class="tbl-linebot01" id="table-friend"
               style="width: 100%; max-width: initial;">
          <tbody>
          <tr>
            <th>ステータス：</th>
            <td style="display: inline-flex;">
              <div class="current-status">
                <span v-if="friendDetail.status === 'active' && friendDetail.status_from_bot === 'active'" class="status complete">
                  正常
                </span>
                <span v-if="friendDetail.status === 'active' && friendDetail.status_from_bot === 'hide'" class="status" style="color: #eb5213">
                  非表示
                </span>
                <span v-if="friendDetail.status === 'active' && friendDetail.status_from_bot === 'block'" class="status complete" style="color: #dc3545">
                  ブロック中
                </span>
                <span v-else-if="friendDetail.status === 'block' && friendDetail.status_from_bot === 'active'" class="status draft">
                  友達からブロック
                </span>
                <span v-else-if="friendDetail.status === 'block' && friendDetail.status_from_bot === 'hide'" class="status draft multiple">
                  友達からブロック<br> <span style="color: #eb5213">非表示</span>
                </span>
                <span v-else-if="friendDetail.status === 'block' && friendDetail.status_from_bot === 'block'" class="status draft multiple">
                  友達からブロック<br> <span style="color: #dc3545">ブロック中</span>
                </span>
              </div>
              <div class="change-status">
                <span class="btn hide-btn" @click="openConfirmChangeStatusModal('hide')" :class="friendDetail.status_from_bot == 'hide' ? 'current-btn' : ''">{{friendDetail.status_from_bot == 'hide' ? '非表示解除' : '非表示'}}</span><span class="btn block-btn" @click="openConfirmChangeStatusModal('block')" :class="friendDetail.status_from_bot == 'block' ? 'current-btn' : ''">{{friendDetail.status_from_bot == 'block' ? 'ブロック解除' : 'ブロック'}}</span>
              </div>

              <div
                class="modal fade modal-delete modal-common01"
                id="modal-change-status"
                tabindex="-1"
                role="dialog"
                aria-labelledby="myModalLabel"
                aria-hidden="true"
              >
                <div class="modal-dialog" role="document">
                  <div class="modal-content">
                    <div class="modal-body">
                      <button
                        type="button"
                        class="close"
                        data-dismiss="modal"
                        aria-label="Close"
                      >
                        <span aria-hidden="true">&times;</span>
                      </button>
                      <p class="mb10 fz14">
                        {{confirmedText}}
                      </p>
                    </div>
                    <div class="modal-footer flex center">
                      <button
                        type="button"
                        class="btn btn-modal-delete"
                        data-dismiss="modal"
                        @click="updateStatusFromBot"
                      >
                        {{buttonText}}
                      </button>
                      <button
                        type="button"
                        class="btn btn-modal-cancel"
                        data-dismiss="modal"
                      >
                        キャンセル
                      </button>
                    </div>
                  </div>
                </div>
              </div>
            </td>
          </tr>
          <tr>
            <th>トーク</th>
            <td><a :href="`/talks/to/${friendDetail.channel.alias}`"><i class="fas fa-comment-dots"></i> メッセージ</a></td>
          </tr>
          <tr>
            <th>アカウント名</th>
            <td>{{ friendDetail.line_customer.line_name }}</td>
          </tr>
          <tr>
            <th>名前</th>
            <td>
              <div class="input-group newgroup-inputs">
                <input type="text" placeholder="" class="form-control"
                       @click.stop
                       v-model="friendDetail.line_customer.display_name"
                       ref="displayName"
                >
                <!--<span class="input-group-btn">-->
                <!--<button type="button" class="btn btn-default" @click="submitChangeName" ref="buttonChangeName"-->
                <!--data-dismiss="modal">-->
                <!--決定-->
                <!--</button>-->
                <!--</span>-->
              </div>
            </td>
          </tr>
          <tr>
            <th>メモ欄</th>
            <td>
              <div >
                <textarea placeholder="" class="form-control" style="width: 100%;"
                       @click.stop
                       v-model="friendDetail.line_customer.note"
                ></textarea>
              </div>
            </td>
          </tr>
          <tr>
            <th>登録日</th>
            <td>{{ formatDateTime(friendDetail.created_at) }}</td>
          </tr>
          <tr>
            <th>タグ</th>
            <td>
              <div class="content-list-tag">
                <input-tag :data="friendDetail.tags" @input="selectTags" :allTags="true"/>
              </div>
            </td>
          </tr>
          </tbody>
        </table>
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
                <tr v-for="(profile, index) in  friendDetail.line_customer.survey_profile" :key="index">
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
                          <input type="hidden" v-model="friendDetail.line_customer.survey_profile[index].content.content.alias">
                          <button type="button" class="btn btn-secondary"
                            @click="openAddFileModal(index)">
                            <i class="fa fa-upload"></i> ファイルをアップロード
                          </button>
                        </div>
                        <div v-if="profile.content.content.name">
                          <a style="color: #ea5516"
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
                                v-model="friendDetail.line_customer.survey_profile[index].content.content"
                                :input-class="{'form-control': true}">
                        </datetime>
                      </div>
                      <div v-else style="input-group newgroup-inputs">
                          <input type="text" placeholder="" class="form-control"
                                @click.stop
                                v-model="friendDetail.line_customer.survey_profile[index].content.content"
                          >
                      </div>

                    </div>
                  </td>
                </tr>
              </tbody>
            </table>
          </div>
          <div v-if="currentTab === '回答一覧'" class="tbl-admin01 table-responsive fz14 text-center" style="overflow-x: scroll">
            <friend-survey-answer :friendId="friendId"></friend-survey-answer>
          </div>
        </div>
        <div style="50px; margin-left: 0;" class="btn btn-common01" @click="saveInfo()">更新</div>
      </div>
  </div>
    <modal-upload-file :data="{type: 'friend_file'}" @input="changeFile"/>

  </section>
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
  methods: {
    ...mapActions('tag', [
      'getTags'
    ]),
    ...mapActions('friend', [
      'getDetailFriend',
      'editLineInfo'
    ]),

    getDetail() {
      this.getDetailFriend({ id: this.friendId }, false).then((res) => {
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

    submitChangeName() {
      // if (this.$refs.displayName.value !== this.displayName && this.$refs.displayName.value) {
      //   this.friendDetail.displayName = this.$refs.displayName.value;
      //   this.$store.dispatch('friend/editLineInfo', {
      //     id: this.friendDetail.id,
      //     display_name: this.$refs.displayName.value
      //   }).done(res => {
      //     console.log(res);
      //     if (!this.talk) {
      //       this.data.line_customer.display_name = this.friendDetail.displayName;
      //     } else {
      //       this.$emit('changeTilteChannel', this.friendDetail.displayName);
      //     }
      //     this.isShowDisplayName = true;
      //   })
      //     .fail(e => {
      //     });
      // }

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
        this.$toastr.s('友だち情報の更新が成功しました。');
      }).catch(() => {
        this.$toastr.e('友だち情報の更新が失敗しました。');
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
    openConfirmChangeStatusModal(value) {
      if (value === 'hide') {
        if (this.friendDetail.status_from_bot === value) {
          this.buttonText = '非表示解除';
          this.destinationStatusFromBot = 'active';
        } else {
          this.buttonText = '非表示';
          this.destinationStatusFromBot = 'hide';
        }
      } else if (value === 'block') {
        if (this.friendDetail.status_from_bot === value) {
          this.buttonText = 'ブロック解除';
          this.destinationStatusFromBot = 'active';
        } else {
          this.buttonText = 'ブロック';
          this.destinationStatusFromBot = 'block';
        }
      }
      this.confirmedText = '友だちを' + this.buttonText + 'します。よろしいですか？';
      $('#modal-change-status').modal('show');
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
      this.friendDetail.line_customer.survey_profile[this.field_index].content.content.alias = file.alias;
      this.friendDetail.line_customer.survey_profile[this.field_index].content.content.mine_type = file.type;
      this.friendDetail.line_customer.survey_profile[this.field_index].content.content.name = file.name;
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
      margin-top: 50px;
    }
    .profile-detail .tabs>div{
      cursor: pointer;
      padding: 10px 20px;
      color: grey;
      border: 2px;
      border-bottom: 2px solid #ea5516;
    }
    .profile-detail .tabs>div:hover{
      color: #ea5516;
    }
    .profile-detail .tabs>div.active
    {
      color: #ea5516;
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
