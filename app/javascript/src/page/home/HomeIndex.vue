<template>
  <div class="" v-if=" admin_status == 'active' ">
    <div class="card">
      <div class="card-header">
        <h3 class="card-title">最新メッセージ</h3>
      </div>
      <div class="card-body">
        <div class="list-news list-news01">
          <ul class="list-unstyled fz14">
            <li v-for="(talk, index) in newTalks" :key="index">
              <a :href="MIX_ROOT_PATH + '/talks/to/'+(talk.channel.alias || '')">
                <dl>
                  <dt>{{lineTimestampToDate(talk.timestamp) }}<span>@{{talk.customer.line_name}}</span></dt>
                  <dd>
                    <message-content-view :data="talk.line_content" ></message-content-view>
                  </dd>
                </dl>
              </a>
            </li>
            <li v-if="isTalkLoading">
            ローディング...
            </li>
          </ul>
        </div>
      </div>
    </div>
    <div class="card" hidden>
      <div class="card-header">
        <h3 class="card-title">お知らせ</h3>
      </div>
      <div class="card-body">
        <div class="list-news list-news02" v-if="notices.length > 0">
          <ul class="list-unstyled fz14">
            <li v-for="(notice, index) in notices" :key="index" @click="viewNotice(notice)" class="cursor-pointer">
              <dl>
                <dt>{{formatDateTime(notice.created_at)}}</dt>
                <dd><a class="underline important"></a>{{notice.title}}</dd>
              </dl>
            </li>
          </ul>
        </div>
        <span v-else>お知らせがありません。</span>
      </div>
    </div>

    <div class="modal fade modal-common01" id="modal-detail-notice" tabindex="-1" role="dialog" aria-hidden="true">
      <div class="modal-dialog" role="document" v-if="noticeCurrent != null">
        <div class="modal-content p-0">
          <div class="modal-header flex-shrink-0">
            <label>{{ noticeCurrent.title }}</label>
            <button type="button" class="close" data-dismiss="modal" aria-label="Close"><span
              aria-hidden="true">&times;</span></button>
          </div>
          <div class="modal-body">
            <table class="tbl-linebot01" id="table-friend">
              <tbody>
              <tr>
                <th>内容</th>
                <td>{{ noticeCurrent.content }}</td>
              </tr>
              <tr>
                <th>タグ</th>
                <td>
                  <div v-if="noticeCurrent.tags" class="content-list-tag">
                      <div v-for="tag in noticeCurrent.tags" :key="tag" class="tag1 selected tag-selected">
                        {{tag}}
                      </div>
                  </div>
                </td>
              </tr>
              <tr>
                <th>登録日</th>
                <td>{{ formatDateTime(noticeCurrent.created_at) }}</td>
              </tr>
              </tbody>
            </table>
          </div>
        </div>
      </div>
    </div>
  </div>
  <div class="row" v-else>
    <div class="col-xs-12 text-center">
      <h3>このアカウントは現在使用できません。</h3>
    </div>
    <div class="col-lg-4 col-lg-offset-4 col-xs-8 col-xs-offset-2 btn-common02">
      <a class="btn">サポートへお問い合わせはこちら</a>
    </div>

  </div>

</template>

<script>
import moment from 'moment';

export default {
  props: ['admin_status', 'notices'],
  data() {
    return {
      MIX_ROOT_PATH: process.env.MIX_ROOT_PATH,
      newTalks: [],
      noticeCurrent: null,
      isNoticeLoading: false,
      isTalkLoading: false
    };
  },

  provide() {
    return { parentValidator: this.$validator };
  },

  mounted() {
    this.getLatestMessages();
    // this.getNotice();
  },

  methods: {

    lineTimestampToDate(lineTimestamp) {
      return moment(new Date(parseInt(lineTimestamp))).format('YYYY年MM月DD日');
    },

    formatDateTime(time) {
      return moment(time).format('YYYY年MM月DD日 HH:mm:ss');
    },

    getTags(tags) {
      if (tags) {
        const tagArr = (tags + '').split(',');
        let tagStr = '';
        tagArr.forEach((tag) => {
          if (tagStr.length > 0) {
            tagStr += '・';
          }
          tagStr += tag;
        });
        return '【 ' + tagStr + ' 】';
      }

      return '';
    },

    getLatestMessages(page = 0) {
      this.isTalkLoading = true;
      this.$store.dispatch('home/latestMessages', { page: page }).then((res) => {
        this.isTalkLoading = false;
        this.newTalks = res.data;

        console.log(res);
      }).catch((err) => {
        console.log(err);
      });
    },

    viewNotice(notice) {
      this.noticeCurrent = notice;
      console.log(notice);
      if (notice.tags) {
        this.noticeCurrent.tags = (notice.tags + '').split(',');
      } else {
        this.noticeCurrent.tags = null;
      }
      $('#modal-detail-notice').modal('show');
    },

    getNotice(page = 0) {
      // this.isNoticeLoading = true;
      // this.$store.dispatch('home/notices', { page: page }).then((res) => {
      //   this.notices = res.data;
      //   console.log(this.notices);
      //   this.isNoticeLoading = false;
      // }).catch((err) => {
      //   console.log(err);
      // });
    }
  }
};
</script>

<style lang="scss" scoped>
  ::v-deep{
    .tag1{
      background: #ededed;
      border-radius: 6px;
      padding: 5px 7px;
      margin: 5px;
      display: inline-block;
    }

    .chat-item-text {
      text-align: left!important;
      cursor: pointer !important;
    }
  }
</style>
