<template>
  <div v-if="broadcast.type === 'all'">全て</div>
  <div v-else-if="broadcast.type === 'condition'">
    <div v-if="broadcast.tags && broadcast.tags.length > 0" class="d-flex align-items-center flex-wrap">
      <span class="text-sm mr-2">タグ</span>
      <span v-for="(tag, index) in broadcast.tags" :key="index" class="badge badge-outline-info badge-pill pt-1">{{tag.name}}</span>
      <divider></divider>
    </div>
    <div v-if="broadcast.conditions && broadcast.conditions.type === 'specific'" class="d-flex align-items-center flex-wrap">
      <span class="text-sm mr-2">友だち登録日</span>
      <span class="font-weight-bold">{{ friendAddCondition.start_date }} ~ {{ friendAddCondition.end_date }}</span>
    </div>
  </div>
</template>

<script>
export default {
  props: ['broadcast'],
  data() {
    return {
      friendAddCondition: this.broadcast.conditions ? this.broadcast.conditions.add_friend_date : null
    };
  }
};
</script>

<style lang="scss" scoped>
  .text-sm {
    font-size: 0.7rem !important;
  }
</style>