<template>
  <div>
    <staff-selection :selected="channel.assignee_id" @select="assignAgent" @open="openStaffSelect" @close="$emit('close')"></staff-selection>
  </div>
</template>

<script>
import { mapActions } from 'vuex';
export default {
  props: ['channel'],
  methods: {
    ...mapActions('channel', ['assign', 'unassign']),

    async assignAgent(agentId) {
      const payload = {
        channel_id: this.channel.id,
        assignee_id: agentId || null
      };
      const response = this.assign(payload);
      if (response) {
        window.toastr.success('担当者が変更されました。');
      } else {
        window.toastr.error('失敗しました。');
      }
    },
    openStaffSelect(staffCount) {
      this.$emit('open', staffCount);
    }
  }
};
</script>
