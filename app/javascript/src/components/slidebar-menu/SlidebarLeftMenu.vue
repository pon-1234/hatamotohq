<template>
  <div class="sidebar side-linebot">
    <div class="box-account mb30">
      <p class="name mb20">{{user.line_name}}
        <span>{{plan.title}}</span>
        <span>{{user.line_id}}</span>
        <span>配信数: {{messageDelivery}}</span>
      </p>

      <p class="flex"><span><i class="fa fa-users" aria-hidden="true"></i>友だち</span><span class="total-friend" v-if="totalFriend">{{totalFriend}}</span></p>
    </div>
    <ul class="list-unstyled nav-side nav-side-linebot">
      <li>
        <a :href="`${MIX_ROOT_PATH}/`" :class="checkActiveHomeMenu()"><i
            class="fa fa-home" aria-hidden="true"></i>ホーム</a>
      </li>
      <li>
        <a :href="`${MIX_ROOT_PATH}/friends`" class="nav-sub" :class="getClassName(appUrl + '/friends')"><i
            class="fa fa-users" aria-hidden="true"></i>友だちリスト</a>
      </li>
      <li>
        <a :href="`${MIX_ROOT_PATH}/talks`"  :class="getClassName(appUrl + '/talks')"><i
            class="fas fa-comment-dots"></i>トーク</a>
      </li>
      <li>
        <a :href="`${MIX_ROOT_PATH}/streams`"  :class="getClassName(appUrl + '/streams')">
          <i class="fa fa-paper-plane"></i>メッセージ配信
        </a>
      </li>
      <li>
        <a :href="`${MIX_ROOT_PATH}/scenarios`"  :class="getClassName(appUrl + '/scenarios')">
          <i class="fas fa-book"></i>ステップ配信
        </a>
      </li>
      <li>
        <a :href="`${MIX_ROOT_PATH}/bots`"  :class="getClassName(appUrl + '/bots')">
          <i class="fas fa-robot"></i>自動応答
        </a>
      </li>
      <li v-if="license.survey_form">
        <a :href="`${MIX_ROOT_PATH}/surveys`"  :class="getClassName(appUrl + '/surveys')" v-if="plan.level==='3'">
          <i class="fas fa-file"></i>入力フォーム
        </a>
      </li>
      <li>
        <a :href="`${MIX_ROOT_PATH}/friend-information`"  :class="getClassName(appUrl + '/friend-information')">
          <i class="fas fa-user"></i>友だち情報管理
        </a>
      </li>
      <li>
        <a :href="sp ? '#nav-template-sp' : '#nav-template-pc'"  :class="getClassName(appUrl +  '/template')" @click="activeTemplate"><i
            class="fas fa-clipboard-list"></i>テンプレート管理</a>
        <ul class="list-unstyled collapse"  :class="isDisplay ? 'open-list': 'close-list'">
          <!--<li>-->
            <!--<a :href="`${MIX_ROOT_PATH}/template/scenarios`" :class="getClassName(appUrl +  '/template/scenarios')">ステップ配信</a>-->
          <!--</li>-->
          <li>
            <a :href="`${MIX_ROOT_PATH}/template/streams`" :class="getClassName(appUrl +  '/template/streams')">メッセージ配信</a>
          </li>
          <li v-if="license.flex_message">
            <a :href="`${MIX_ROOT_PATH}/template/flex-messages/folders`" :class="getClassName(appUrl +  '/template/flex-messages')">Flexメッセージ</a>
          </li>
        </ul>
      </li>
      <li>
        <a :href="`${MIX_ROOT_PATH}/tags`"  :class="getClassName(appUrl +  '/tags')">
          <i class="fas fa-tag"></i>タグ管理
        </a>
      </li>
      <li>
        <a :href="`${MIX_ROOT_PATH}/richmenus`"  :class="getClassName(appUrl +  '/richmenus')">
          <i class="far fa-image"></i>リッチメニュー管理
        </a>
      </li>
      <li>
        <a :href="`${MIX_ROOT_PATH}/medias`" :class="getClassName(appUrl +  '/medias')"><i
            class="fas fa-images" aria-hidden="true"></i>メデイア管理</a>
      </li>
      <li>
        <a data-toggle="collapse" :href="sp ? '#nav-account-sp' : '#nav-account-pc'" :class="getClassName(appUrl + '/information', '/register')"><i
            class="fas fa-user-circle"></i>アカウント情報</a>
        <ul :id="sp ? 'nav-account-sp' : 'nav-account-pc'" class="list-unstyled collapse">
          <li>
            <a :href="`${MIX_ROOT_PATH}/information`"><span v-if="user && user.line_id">アカウント情報</span><span v-else>アカウント連携</span></a>
          </li>
          <li>
            <a :href="`${MIX_ACCOUNT_BAZIO_URL}/user/payments?uid=${user.uid}`">プラン情報</a>
          </li>
          <!--<li v-if="license && license.id">-->

            <!--<a :href="'/user/payments/licenses/'+ license.id +'/detail'" target="_blank">プラン変更</a>-->
          <!--</li>-->
        </ul>
      </li>
      <!-- <li>
        <a :href="`${MIX_ROOT_PATH}/setting`" :class="getClassName(appUrl + '/setting')"><i
            class="fas fa-cog"></i>設定</a>
      </li> -->
      <li v-if="isMobile()">
        <a :href="`${MIX_ROOT_PATH}/logout`" class="nav-sub"><i class="fas fa-sign-out-alt"></i>ログアウト</a>
      </li>
    </ul>
  </div>
</template>

<script>
import Util from '@/core/util';

export default {
  props: ['user', 'sp', 'messageDelivery', 'license', 'plan'],
  data() {
    return {
      MIX_ROOT_PATH: process.env.MIX_ROOT_PATH,
      MIX_ACCOUNT_BAZIO_URL: process.env.MIX_ACCOUNT_BAZIO_URL,
      totalFriend: 0,
      isClick: true,
      appUrl: process.env.MIX_APP_URL,
      isDisplay: false
    };
  },

  created() {
    if (this.user && this.user.line_id) {
      this.getTotalFriend();
    } else {
      this.isClick = false;
    }

    this.isDisplay = window.location.href.includes('template');
  },

  methods: {
    getClassName(param, subParams = null) {
      const url = window.location.href;
      let className = 'nav-sub ';
      if (subParams === '/register' && !this.isClick) {
        className += ' active';
      }

      if (url.includes(param)) {
        className += ' active';
      };

      if (!this.isClick && subParams !== '/register') {
        className += ' disable';
      }

      return className;
    },

    checkActiveHomeMenu() {
      let className = 'nav-sub ';
      if (!this.isClick) {
        className += ' disable';
      }

      if (window.location.href === this.appUrl + '/') {
        className += ' active';
      }

      return className;
    },

    getTotalFriend() {
      this.$store.dispatch('friend/getList', { page: 1 }).done(res => {
        if (res && res.meta) {
          this.totalFriend = res.meta.total;
        }
      }).fail(e => {
      });
    },

    isMobile() {
      return Util.isMobile();
    },

    activeTemplate() {
      this.isDisplay = !this.isDisplay;
    }
  }
};
</script>

<style lang="scss" scoped>
.total-friend {
  margin-left: auto;
}

.disable {
  pointer-events: none!important;
}

.open-list {
  display: block!important;

  .active {
    background: #D7D0D0;
  }
}

.close-list{
  display: none!important;
}
</style>
