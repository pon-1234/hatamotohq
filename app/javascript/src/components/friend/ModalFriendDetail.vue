<template>
  <div class="modal fade modal-common01" id="modal-detail-friend" tabindex="-1" role="dialog" aria-labelledby="myModalLabel" aria-hidden="true">
    <div class="modal-dialog" role="document">
      <div class="modal-content p-0">
        <div class="modal-header flex-shrink-0">
          <button type="button" class="close" data-dismiss="modal" aria-label="Close"><span
            aria-hidden="true">&times;</span></button>
        </div>
        <div class="modal-body" v-if="friendDetail">
          <div class="center" style="text-align: center">
            <img
              :src="friendDetail.line_customer.line_picture_url ? friendDetail.line_customer.line_picture_url : '/img/no-image-profile.png'"
              style="width: 150px;height: 150px;object-fit: cover;border-radius: 150px;"
            />
          </div>

          <table class="tbl-linebot01" id="table-friend" v-if="!isShowTags" style="width: 100%; margin: 0; max-width: initial;">
            <tbody>
              <tr>
                <th>名前</th>
                <td>{{ friendDetail.line_customer.line_name }}</td>
              </tr>
              <tr>
                <th>表示名</th>
                <td>
                  <span class="x-fix-name" style="max-width: 200px">{{displayName}}</span>
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
                    <div v-if="friendDetail.tags" class="content-list-tag">
                      <div v-for="tag in friendDetail.tags" :key="tag.id">
                        <span class="tag1 selected tag-selected">{{tag.name}}</span>
                      </div>
                    </div>
                    <button class="edit btn-edit-tag btn-more" @click="showListTag()">編集</button>
                  </div>
                </td>
              </tr>
            </tbody>
          </table>
          <div v-if="isShowTags" class="select-tags-user">
            <input-tag :tags="friendDetail.tags" @input="selectTags" :allTags="true"/>
          </div>
        </div>
        <div class="modal-footer flex center">
          <button
            type="button"
            class="btn btn-common01"
            v-if="!isShowTags"
            @click="viewProfile()"
          >プロフィールを見る</button>
          <div
            v-if="isShowTags"
            class="btn btn-common01"
            @click="editTag"
          >更新</div>
        </div>
      </div>
    </div>
  </div>
</template>

<script>
import moment from 'moment';

export default {
  props: ['data', 'talk'],
  data() {
    return {
      tags: [],
      isShowTags: false,
      isEnter: true,
      isShowDisplayName: true,
      friendDetail: null,
      displayName: null
    };
  },

  watch: {
    data: {
      handler(val) {
        if (this.data) {
          // eslint-disable-next-line no-undef
          this.friendDetail = _.cloneDeep(this.data);
          this.tags = this.data.tags;
          this.displayName = this.friendDetail.line_customer.display_name ? this.friendDetail.line_customer.display_name : this.friendDetail.line_customer.line_name;
          this.isShowDisplayName = true;
        }
      },
      deep: true
    }
  },
  methods: {
    showListTag() {
      if (!this.isShowTags) {
      }
      this.isShowTags = !this.isShowTags;
    },

    viewProfile() {
      location.href = '/friends/' + this.friendDetail.id + '/detail';
    },

    editTag() {
      this.isShowTags = !this.isShowTags;
      var data = [];
      this.tags.forEach((tag, index) => {
        data.push({ id: tag.id });
      });

      this.$store.dispatch('friend/editTag', {
        id: this.friendDetail.id,
        tags: data
      }).done(res => {
        console.log(res);
        this.$emit('editTag', this.tags);
      })
        .fail(e => {
        });
    },

    selectTags(tags) {
      this.tags = tags;
      this.friendDetail.tags = tags;
    },

    formatDateTime(time) {
      return moment(time).format('YYYY年MM月DD日 HH:mm:ss');
    },

    editDisplayName() {
      this.isShowDisplayName = !this.isShowDisplayName;
    },

    submitChangeName() {
      if (this.$refs.displayName.value !== this.displayName && this.$refs.displayName.value) {
        this.displayName = this.$refs.displayName.value;
        this.$store.dispatch('friend/editLineInfo', {
          id: this.friendDetail.id,
          display_name: this.$refs.displayName.value
        }).done(res => {
          console.log(res);
          if (!this.talk) {
            this.data.line_customer.display_name = this.displayName;
          } else {
            this.$emit('changeTilteChannel', this.displayName);
          }
          this.isShowDisplayName = true;
        })
          .fail(e => {
          });
      }
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
    }
  }
};
</script>
<style lang="scss" scoped>
::v-deep {
  .modal-footer{
    display: flex !important;
    flex-direction: row !important;
  }
  .content-list-tag {
    display: flex;
    flex-wrap: wrap;
  }

  .selected {
    color: #00B900;
    border: 1px solid #00B900;
  }

  .select-tags-user{
    margin-top: 10px;
    margin-bottom: 20vh;
  }

  .tbl-linebot01 td .tag1 {
    border-radius: 5px;
    padding: 10px;
    display: inline-block;
    font-size: 75%;
    line-height: 1;
    margin: 5px 5px 2.5px 0px;
  }

  #table-friend {
    margin: auto 50px;
  }

  #table-friend tr th {
    padding: 10px 0px;
  }

  #table-friend tr > td {
    width: 80%;
  }

  .btn-more {
    background: white;
    span{
      color: black;
    }
  }

  .btn-more:hover {
    span{
      color: #fff!important;
    }
  }
  .btn-more {
    margin: 5px 5px 2.5px 0px;
  }
}

</style>
