<template>
  <div>Testaaaaa</div>
</template>
<script>
import liff from '@line/liff';

export default {
  props: ['code', 'friendship_status_changed', 'added_friend_before'],
  data() {
    return {
      contentKey: 0
    };
  },

  mounted() {
    if (this.added_friend_before === 'true') return;
    liff.init({ liffId: '1657161444-0K6jEMn1' })
      .then(() => {
        if (!liff.isLoggedIn()) {
          liff.login({ bot_prompt: 'normal', redirectUri: `https://4c1b-58-187-180-50.ngrok.io/stream_route/${this.code}` });
        } else {
          liff.getFriendship().then((data) => {
            // in case added officer account as friend
            if (data.friendFlag) {
              const userId = liff.getContext().userId;
              if (this.friendship_status_changed === 'true') {
                alert('first add time');
                // for first time officer account is added as friend
                window.location.href = `https://4c1b-58-187-180-50.ngrok.io/stream_route/${this.code}/?line_user_id=${userId}&friendship_status_changed=true&added_friend_before=true`;
              } else {
                alert('added friend before');
                // nexttime when stream route link is accessed
                // Only available when chose アクションの実行 -> いつでも
                // need to add added_friend_before param to avoid infinite loop
                window.location.href = `https://4c1b-58-187-180-50.ngrok.io/stream_route/${this.code}/?line_user_id=${userId}&added_friend_before=true`;
              }
            } else {
              // if have not add officer account as friend yet then logout and back to login screen
              // Maybe need create a popup to explain and guide for users
              liff.logout();
              liff.login({ bot_prompt: 'normal', redirectUri: `https://4c1b-58-187-180-50.ngrok.io/stream_route/${this.code}` });
            }
          });
        }
      })
      .catch((err) => {
        console.log(err);
      });
  },

  computed: {
  },

  methods: {
  }
};
</script>