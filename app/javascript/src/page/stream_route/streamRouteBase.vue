<template>
  <div>Testaaaaa</div>
</template>
<script>
import liff from '@line/liff';

export default {
  props: [],

  data() {
    return {
      contentKey: 0
    };
  },

  mounted() {
    liff
      .init({
        liffId: '1657142924-AyEOw4R3'
      })
      .then(() => {
        if (!liff.isLoggedIn()) {
          alert('login')
          // TODO 
          // Need to change new redirect url
          liff.login({ bot_prompt: 'normal', hoangtestaaaaaaaaaaa: 'let_starttttttt', redirectUri: "https://fbc8-123-25-30-176.ngrok.io/stream_route/facebook?a=1&b=2&c=3" });
        } else {
          alert('Ok roi')
          const userId = liff.getContext().userId;
          // TODO 
          // Need redirect to new url to save friend data
          alert(userId);
        }
      })
      .catch((err) => {
        console.log(err);
      });
  },

  computed: {
    // primaryLabel() {
    //   return this.type === 'scenario' ? 'シナリオ' : '一斉配信';
    // }
  },

  methods: {
    // forceRerender() {
    //   this.contentKey++;
    // },
  }
};
</script>