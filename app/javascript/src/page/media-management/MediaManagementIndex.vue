<template>
  <div>
    <div class="ai_center mb40">
      <div class="col-l">
        <h3 class="hdg3">登録メディア一覧</h3>
        <p>登録した画像や動画などの一覧を管理することが出来ます。(※旧メディア一覧)</p>
      </div>
      <div class="media-content">
        <div class="media-pull">
          <a  href="#" class="btn btn-info" data-toggle="modal" data-target="#imageModalCenter" @click="showDialog('image')" style="margin-bottom: 0.5em;">
            画像アップロード
          </a>
          <a href="#" class="btn btn-info" data-toggle="modal" data-target="#imageModalCenter"  @click="showDialog('audio')" style="margin-bottom: 0.5em;">
            音声アップロード
          </a>
          <a href="#" class="btn btn-info" data-toggle="modal" data-target="#imageModalCenter"  @click="showDialog('video')" style="margin-bottom: 0.5em;">
            動画アップロード
          </a>
          <a href="#" class="btn btn-info" data-toggle="modal" data-target="#imageModalCenter"  @click="showDialog('richmenu')" style="margin-bottom: 0.5em;">
            メニュー画像アップロード
          </a>
          <a href="#" class="btn btn-info" data-toggle="modal" data-target="#imageModalCenter"  @click="showDialog('pdf')" style="margin-bottom: 0.5em;">
            PDFアップロード
          </a>
        </div>
        <div class="pull">
          <filter-checkbox @input="changefilter"/>
        </div>
      </div>
    </div>
    <div class="media">
      <div class="media-list form-common01">
        <div class="media-child" v-for="media in this.medias" :key="media.id">
          <div style="display: block;">
            <div class="panel panel-default panel-media panel-media-image">
              <div class="panel-body text-center">
                <div class="gallery-item">
                  <expandable-image v-if="media.mine_type.includes('image')"
                    class="image"
                    :src="urlmedia + '/' + media.alias"
                  />
                  <a class="video" v-else-if="media.mine_type.includes('video')" :href="urlmedia + '/' + media.alias" target="_blank">
                    <img :src="urlmedia + '/' + media.alias + '/preview'"  border="0" align="center"/>
                  </a>

                  <a class="file" v-else-if="media.mine_type.includes('pdf')||media.mine_type.includes('audio')" :href="urlmedia + '/' + media.alias" target="_blank">
                    <img :src="urlmedia + '/' + media.alias + '/preview'"  border="0" align="center"/>
                  </a>

                </div>
              </div>
              <div class="panel-footer">
                <input class="memberchecks pull-right panel-media-check"  type="checkbox" :value="media"
                       v-model="selectedMedias" />
                <p>
                  <b>{{media.mine_type}}</b>
                </p>
                <p>
                  登録：<b>{{showTime(media.created_at)}}</b>
                </p>
                <a :href="urlDownload(media.alias)"  class="panel-download" @click.prevent="downloadItem(media)" >ダウンロード</a>
              </div>
            </div>
          </div>
        </div>
      </div>
    </div>
    <div class="media-content">
      <div class="">
        <b-pagination
          v-model="currentPage"
          :total-rows="totalRows"
          :per-page="perPage"
          @change="getMedias"
          aria-controls="my-table"
        ></b-pagination>
      </div>
      <div class="pull">
        <label for="membercheck_all">
          <input id="membercheck_all" type="checkbox" value="1" v-model="isCheckAll" @change="checkAll()">
          全てのメディアをチェック
        </label>
        <button class="btn btn-danger btn-sm" :disabled="!(selectedMedias.length > 0)" data-toggle="modal"
                data-target="#modal-delete">チェックしたメディアをリストから削除する</button>
      </div>
    </div>

    <modal-confirm title="削除しまか？" id='modal-delete' type='delete' @input="deleteMedia"/>
    <media-management-modal v-bind:data="data" @input="uploadMedia"></media-management-modal>
  </div>
</template>
<script>
import { mapState } from 'vuex';
import moment from 'moment';

export default {
  name: 'media-manager',
  props: ['urlmedia', 'urlapi'],
  data() {
    return {
      medias: [],
      isCheckAll: 0,
      selectedMedias: [],
      filter: [],
      currentPage: 1,
      totalRows: 0,
      perPage: 0,
      data: {
        type: this.MessageType.image
      }
    };
  },
  beforeMount() {
    this.getMedias();
  },
  computed: {
    ...mapState('system', {
      success: state => state.success
    })
  },
  watch: {
    selectedMedias: {
      handler(val) {
        this.isCheckAll = val.length === this.medias.length && this.medias.length > 0;
      },
      deep: true
    }
  },
  methods: {
    showDialog(type) {
      this.data.type = type;
    },
    checkAll() {
      this.selectedMedias = this.isCheckAll === true ? this.medias : [];
    },
    changefilter(params) {
      this.filter = params;
      this.getMedias();
    },
    deleteMedia() {
      const query = {
        medias: this.selectedMedias.map(media => {
          return media.alias;
        })
      };
      this.$store
        .dispatch('media/mediasDelete', query)
        .done(res => {
          this.medias = this.medias.filter(function(media) {
            return !query.medias.includes(media.alias);
          });

          if (this.isCheckAll) {
            this.getMedias(1);
          }
          this.selectedMedias = [];
        }).fail(e => {
        });
    },
    getMedias(page = 1) {
      const query = {
        page: page,
        type: this.filter
      };
      this.$store
        .dispatch('media/getMedias', query)
        .done(res => {
          this.medias = res.data;
          this.perPage = res.meta.per_page;
          this.totalRows = res.meta.total;
        }).fail(e => {
        });
    },

    uploadMedia() {
      this.getMedias(this.currentPage);
    },

    downloadMedia(alias) {
      this.$store
        .dispatch('media/download', { alias: alias })
        .done(res => {
        }).fail(e => {
        });
    },

    urlDownload(alias) {
      return process.env.MIX_MEDIA_FLEXA_URL + '/' + alias + '/download';
    },

    replace(type) {
      let res = type.replace('image/', '');
      res = res.replace('audio/', '');
      return res.replace('video/', '');
    },

    showTime(time) {
      return moment(time).format('YYYY年MM月DD日');
    },

    downloadItem(media) {
      const url = this.urlDownload(media.alias);
      $.ajax({
        url: 'https://cors-anywhere.herokuapp.com/' + url,
        method: 'GET',
        xhrFields: {
          responseType: 'blob'
        },
        success: function(data) {
          var a = document.createElement('a');
          var url = window.URL.createObjectURL(data);
          a.href = url;
          a.download = 'media' + moment(media.created_at).unix();
          document.body.append(a);
          a.click();
          a.remove();
          window.URL.revokeObjectURL(url);
        }
      });
    }
  }
};
</script>
<style>
  .media-list {
    display: flex;
    margin: 0 -5px;
    flex-wrap: wrap;
  }
  .media-child {
    padding: 5px;
    flex: 0 0 16.66%;
    max-width: 16.66%;
  }

  .panel-download {
    color: #3097D1;
    text-decoration: underline;
    font-size: 10px;
  }

  .media-content {
    display: flex;
    align-items: center;
  }

  .media-content .pull {
    margin: 0px 0px 0px auto;
  }

  @media (min-width: 1350px) and (max-width: 1500px) {
    .media-child {
      padding: 5px;
      flex: 0 0 20%;
      max-width: 20%;
    }
  }

  @media (min-width: 868px) and (max-width: 1349px) {
    .media-child {
      padding: 5px;
      flex: 0 0 25%;
      max-width: 25%;
    }
    .media-content {
      display: block;
    }
  }

  @media(max-width: 868px) {
    .media-child {
      padding: 5px;
      flex: 0 0 33%;
      max-width: 33%;
    }
    .media-content {
      display: block;
    }
  }

  @media(max-width: 540px) {
    .media-child {
      padding: 5px;
      flex: 0 0 50%;
      max-width: 50%;
    }
    .media-content {
      display: block;
    }
  }

  @media(max-width: 340px) {
    .media-child {
      padding: 5px;
      flex: 0 0 100%;
      max-width: 100%;
    }
    .media-content {
      display: block;
    }
  }

  @media (max-width: 767px){
    .media-child {
      font-size: 1.9vw !important;
    }
  }

  .panel-footer > div, b{
    font-weight: 400;
  }

  p{margin: 0}

  .gallery-item img{
    width: 100% !important;
    height: 150px !important;
    object-fit: contain;
  }

  .btn-danger {
    border: none!important;
  }

</style>
