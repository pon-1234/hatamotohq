<template>
  <div v-show="added_friend_before == 'true'">
    <div class="alert alert-success" role="alert">
      <h4 class="alert-heading">友だち追加完了</h4>
      <p class="py-2">
        ありがとうございました！
      </p>
      <hr>
      <p class="mb-0">上部✖︎ボタンを押して終了してください</p>
    </div>
  </div>
</template>
<script>
import liff from '@line/liff';

export default {
  props: ['stream_route_code', 'friendship_status_changed', 'added_friend_before'],
  data() {
    return {
      rootPath: process.env.MIX_ROOT_PATH
    };
  },

  created() {
    // When populate stream_route_code into redirectUri of liff.login,
    // redundant callback request is generated from liff lead to not expect errors happen
    // So use localStorage to save stream_route_code for using to another requests later
    if (this.stream_route_code) localStorage.setItem('currentStreamRouteCode', this.stream_route_code);
  },

  mounted() {
    if (this.added_friend_before === 'true') {
      liff.closeWindow();
      return;
    }
    liff.init({ liffId: process.env.LIFF_ID })
      .then(() => {
        if (!liff.isLoggedIn()) {
          liff.login({ bot_prompt: 'aggressive' });
        } else {
          liff.getFriendship().then((data) => {
            // in case added officer account as friend
            if (data.friendFlag) {
              const userId = liff.getContext().userId;
              if (this.friendship_status_changed === 'true') {
                // for first time officer account is added as friend
                const currentStreamRouteCode = localStorage.getItem('currentStreamRouteCode');
                localStorage.removeItem('currentStreamRouteCode');
                window.location.href = `${this.rootPath}/stream_route_detail/${currentStreamRouteCode}?line_user_id=${userId}&friendship_status_changed=true&added_friend_before=true`;
              } else {
                // nexttime when stream route link is accessed
                // Only available when chose アクションの実行 -> いつでも
                // need to add added_friend_before param to avoid infinite loop
                const currentStreamRouteCode = localStorage.getItem('currentStreamRouteCode');
                localStorage.removeItem('currentStreamRouteCode');
                window.location.href = `${this.rootPath}/stream_route_detail/${currentStreamRouteCode}?line_user_id=${userId}&added_friend_before=true`;
              }
            } else {
              // if have not add officer account as friend yet then logout
              // User need remove app connection from line app before add officer account from stream route link one more time
              // Maybe need create a popup to explain and guide for users
              localStorage.removeItem('currentStreamRouteCode');
              liff.logout();
            }
          });
        }
      })
      .catch((err) => {
        console.log(err);
      });
  }
};
</script>
