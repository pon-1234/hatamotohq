<template>
  <div class="menu-nav">
     <div class="item-nav active main-menu"  id="navChatbox">
        <i class="fa fa-list-ul" @click="onClickMenuBar"></i>
    </div>
     <a class="item-nav active" :href="`${MIX_ROOT_PATH}/talks`">
        <i class="fas fa-comment-dots"></i>
    </a>
     <a class="item-nav active" :href="`${MIX_ROOT_PATH}/streams`">
      <i class="fa fa-paper-plane"></i>
    </a>
  </div>
</template>
<script>
export default {
  data() {
    return {
      MIX_ROOT_PATH: process.env.MIX_ROOT_PATH
    };
  },
  methods: {
    onClickMenuBar() {
      this.$emit('input');
    }
  }
};
</script>
<style lang="scss" scoped>

.item-nav {
  i {
    color: #fff;
  }
}
@media (min-width: 768px) {
  .main-menu {
    display: none!important;
  }
}
</style>
