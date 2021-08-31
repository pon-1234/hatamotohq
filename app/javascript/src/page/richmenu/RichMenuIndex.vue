<template>
    <div>
        <div class="row-ttl01 flex ai_center mb40 flex-wrap justify-content-between">
            <div class="col-l flex">
                <h3 class="hdg3">リッチメニュー一覧</h3>
            </div>
        </div>
        <div>
          <folder-left
            type="rich_menu"
            :data="richMenus"
            :isPc="isPc"
            :selectedFolder="selectedFolder"
            @changeSelectedFolder="changeSelectedFolder"
            @submitUpdateFolder="submitUpdateFolder"
            @submitCreateFolder="submitCreateFolder"
            />

          <div :class="getClassRightTag()">
            <div class="tag-header">
              <div class="col-r">
                <div class="btn-common02 fz14">
                  <a :href="getUrlCreateNewRichMenu()"><span>新規作成</span></a>
                </div>
              </div>
            </div>
            <div class="tag-content">
              <!--<table class="table table-tags-header">-->
                <!--<thead>-->
                <!--<tr>-->
                  <!--<th class="w5" style="height: 42px"><i class="fas fa-arrow-left item-sm" @click="backToFolder"></i></th>-->
                  <!--<th v-if="richMenus[selectedFolder]">{{richMenus[selectedFolder].name}}</th>-->
                <!--</tr>-->
                <!--</thead>-->
              <!--</table>-->

                <div class="x-tag-header">
                    <div class="x-btn-back">
                        <i style="margin: auto" class="fas fa-arrow-left item-sm" @click="backToFolder"></i></div>
                    <div class="x-title"
                         v-if="richMenus[selectedFolder]">{{richMenus[selectedFolder].name}}
                    </div>
                </div>

              <div class="tag-scroll">
                <div class="tbl-admin01 tbl-linebot01 table-responsive fz14 text-center">
                  <table class="table table-hover table-message-content">
                    <thead>
                      <tr>
                        <th class="w10">No.</th>
                        <th class="w15">タイトル</th>
                        <th class="w30">表示期間</th>
                        <th class="w15">ステータス</th>
                        <th class="w30"></th>
                      </tr>
                    </thead>
                    <tbody  v-if="richMenus[selectedFolder]" >
                      <tr  v-for="(item, index) in richMenus[selectedFolder].rich_menus" v-bind:key="index">
                        <td class="">{{index+1}}</td>
                        <td class="text-left">{{item.title}}</td>
                        <td class="">{{formatDateTime(item.start_date)}} ～ {{formatDateTime(item.end_date)}}</td>
                        <td class="">
                          <span v-if="item.status === 'DONE'"><span  class="status complete"  v-if="item.selected">予約済み</span><span v-else class="status reserve" >停止中</span></span>
                          <span class="status draft" v-else-if="item.status === 'PENDING'">処理中</span>
                          <span class="status error" v-else-if="item.status === 'ERROR'">エラー</span>
                          <span class="status sending" v-else-if="item.status === 'ACTIVE'">設定中</span>
                          <span class="status complete" v-else-if="item.status === 'EXPIRED'">期限切れ</span>
                          <span class="status reserve" v-else>X</span>
                        </td>
                        <td class=" row-btn text-right">
                          <div class="btn-copy01" data-toggle="tooltip" title="複製">
                            <a :href="MIX_ROOT_PATH + '/richmenus/'+item.id" class="btn-more btn-more-linebot btn-block" data-toggle="tooltip" title="編集" >
                            <i class="fas fa-edit"></i>
                            </a>
                          </div>
                          <div class="btn-delete01" data-toggle="tooltip" title="削除">
                            <button class="btn-more btn-more-linebot btn-block" data-toggle="modal" data-target="#modal-delete"  @click="currentRichMenu = item">
                            <i class="fas fa-trash-alt"></i>
                            </button>
                          </div>
                        </td>
                      </tr>
                    </tbody>
                    <tbody  v-else>
                      <tr>
                        <td colspan="4">Loading...</td>
                      </tr>
                    </tbody>
                  </table>
                </div>
              </div>
            </div>
          </div>
        </div>
        <!-- モーダル -->
        <div class="modal fade modal-delete modal-common01" id="modal-delete" tabindex="-1" role="dialog"
             aria-labelledby="myModalLabel" aria-hidden="true">
            <div class="modal-dialog" role="document">
                <div class="modal-content">
                    <div class="modal-body">
                        <button type="button" class="close" data-dismiss="modal" aria-label="Close"><span
                                aria-hidden="true">&times;</span></button>
                        <p class="mb10 fz14">以下のリッチメニューを削除します。よろしいですか？</p>
                        <dl class="flex group-modal01 no-mgn flex-wrap justify-content-between">
                            <dt>タイトル</dt>
                            <dd>{{currentRichMenu.title}}</dd>
                            <dt>表示期間</dt>
                            <dd>{{formatDateTime(currentRichMenu.start_date)}} ～ {{ formatDateTime(currentRichMenu.end_date)}}</dd>
                        </dl>
                    </div>
                    <div class="modal-footer flex center">
                        <button type="button" class="btn btn-common01 btn-modal-delete" @click="deleteRichMenu" data-dismiss="modal">削除</button>
                        <button type="button" class="btn btn-common01 btn-modal-cancel" data-dismiss="modal">キャンセル
                        </button>
                    </div>
                </div>
            </div>
        </div>
        <modal-confirm title="このフォルダを削除します。よろしいですか？" id='modal-confirm-delete-folder' type='delete' @input="submitDeleteFolder"/>
    </div>
</template>

<script>
import moment from 'moment';

export default {
  props: [],
  data() {
    return {
      MIX_ROOT_PATH: process.env.MIX_ROOT_PATH,
      currentRichMenu: {
        title: '',
        start_date: '',
        end_date: ''
      },
      isBusy: true,
      richMenus: [],
      richMenusContent: [],
      isPc: true,
      selectedFolder: 0
    };
  },

  beforeMount() {
    this.getList();
  },

  methods: {
    getList(page = 1) {
      const query = {
        page: page
      };
      this.isBusy = true;
      this.$store.dispatch('richmenu/getList', query)
        .done((res) => {
          this.richMenus = res;
        }).always(() => {
          this.isBusy = false;
        });
    },

    async deleteRichMenu() {
      await this.$store.dispatch('richmenu/destroyRichmenu', {
        richMenuId: this.currentRichMenu.id
      });

      this.richMenus[this.selectedFolder].rich_menus.deleteWhere(item => item.id === this.currentRichMenu.id);
    },

    async changeSelectedFolder(index) {
      this.selectedFolder = index;
      this.isPc = true;
      this.richMenusContent = this.richMenus[this.selectedFolder].rich_menus;
    },

    async submitUpdateFolder(value) {
      this.$store
        .dispatch('global/editFolder', value)
        .done(res => {
          this.richMenus[this.selectedFolder].name = res.name;
        }).fail(e => {
        });
    },

    async submitCreateFolder(value) {
      this.$store
        .dispatch('global/createFolder', value)
        .done(res => {
          const data = res;
          data.rich_menus = [];
          this.richMenus.push(data);
        }).fail(e => {
        });
    },

    backToFolder() {
      this.isPc = false;
    },

    getClassRightTag() {
      let className = 'col-md-8 tag-content-right';

      if (!this.isPc) {
        className += ' item-pc';
      }

      return className;
    },

    submitDeleteFolder() {
      this.$store
        .dispatch('global/deleteFolder', { id: this.richMenus[this.selectedFolder].id, type: 'scenario' })
        .done(res => {
          this.richMenus.splice(this.selectedFolder, 1);
        }).fail(e => {
        });
    },

    getUrlCreateNewRichMenu() {
      if (this.richMenus[this.selectedFolder]) {
        return process.env.MIX_ROOT_PATH + '/richmenus/create?folder_id=' + this.richMenus[this.selectedFolder].id;
      }
    },

    formatDateTime(time) {
      return moment(time).tz(moment.tz.guess()).format('YYYY年MM月DD日 HH:mm');
    }

  }
};
</script>

<style scoped lang="scss">
  ::v-deep{
    @media(min-width: 768px) and (max-width: 1199px) {
        .table-responsive > .table > tbody > tr > td, .table-responsive > .table > tbody > tr > th, .table-responsive > .table > tfoot > tr > td, .table-responsive > .table > tfoot > tr > th, .table-responsive > .table > thead > tr > td, .table-responsive > .table > thead > tr > th {
            white-space: nowrap !important;
        }
    }

    .form-control[disabled], .form-control[readonly], fieldset[disabled] .form-control{
      background: white;
    }
  }

  .tag-header {
  height: 40px;
  color: white;
  .col-r {
    display: inline-flex;
    float: right;
  }
  button {
    color: black!important;
  }
}

.tag-content {
  height: 85vh;
  background-color: #f0f0f0;
  margin-top: 10px;
  overflow: hidden;
  display: flex;
  flex-direction: column;
  .tag-scroll {
    height: 100%;
    overflow: hidden;
    margin: 0 0;
    display: flex;
    flex-direction: column;
  }
}

.table-tags-header {
  margin-bottom: 0px!important;
}

.item-sm {
  display: none;
}

@media (max-width: 991px) {
  .item-pc {
    display: none!important;
  }

  .item-sm {
    display: inline-block!important;
  }

  .fa-arrow-left {
    margin-right: 10px;
    cursor: pointer;
  }

  .tag-content-right {
    .tag-scroll {
       overflow: hidden;
    }
  }

  .tag-scroll {
    overflow: hidden;
  }
}

.table-message-content {
  min-width: 800px;
}

.table-responsive {
  overflow: auto;
  height: 100%;
  margin-bottom: 0px!important;
  thead {
    border-bottom: none!important;
    th {
      height: 49px;
      border-bottom: none!important;
      position: sticky; top: 0;
      background:#e0e0e0;
      border-radius: 0px!important;
    }
  }
}

</style>
