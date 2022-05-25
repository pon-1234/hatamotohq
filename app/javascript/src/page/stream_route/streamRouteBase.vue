<template>
  <div v-show="added_friend_before == 'true'">
    <div class="alert alert-success" role="alert">
      <h4 class="alert-heading">友だち追加完了</h4>
      <p class="py-2">
        お答えありがとうございました！
      </p>
      <hr>
      <p class="mb-0">上部✖︎ボタンを押して終了してください</p>
    </div>
  </div>
</template>
<script>
import liff from '@line/liff';

export default {
  props: ['code', 'friendship_status_changed', 'added_friend_before'],
  data() {
    return {
      rootPath: process.env.MIX_ROOT_PATH,
      contentKey: 0
    };
  },

  mounted() {
    if (this.added_friend_before === 'true') {
      liff.closeWindow();
      return;
    }
    liff.init({ liffId: process.env.LIFF_ID })
      .then(() => {
        if (!liff.isLoggedIn()) {
          liff.login({ bot_prompt: 'normal', redirectUri: `${this.rootPath}/stream_route/${this.code}` });
        } else {
          liff.getFriendship().then((data) => {
            // in case added officer account as friend
            if (data.friendFlag) {
              const userId = liff.getContext().userId;
              if (this.friendship_status_changed === 'true') {
                // for first time officer account is added as friend
                window.location.href = `${this.rootPath}/stream_route/${this.code}/?line_user_id=${userId}&friendship_status_changed=true&added_friend_before=true`;
              } else {
                // nexttime when stream route link is accessed
                // Only available when chose アクションの実行 -> いつでも
                // need to add added_friend_before param to avoid infinite loop
                window.location.href = `${this.rootPath}/stream_route/${this.code}/?line_user_id=${userId}&added_friend_before=true`;
              }
            } else {
              // if have not add officer account as friend yet then logout and back to login screen
              // Maybe need create a popup to explain and guide for users
              liff.logout();
              liff.login({ bot_prompt: 'normal', redirectUri: `${this.rootPath}/stream_route/${this.code}` });
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