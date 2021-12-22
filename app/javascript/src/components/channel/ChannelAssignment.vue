<template>
  <div>
    <multiselect
      v-model="assignee"
      :allow-empty="true"
      :options="agents"
      :option-height="60"
      :show-labels="false"
      placeholder="未割り当て"
      label="name"
      track-by="id"
      :multiple="false"
      :showNoResults="false"
      @select="assignAgent"
      @remove="assignAgent(null)"
    >
      <template slot="singleLabel" slot-scope="props">
        <div class="d-flex align-items-center">
          <img class="option-image" :src="props.option.avatar_url || '/img/no-image-profile.png'" alt="Staff avatar" />
          <span class="ml-2">{{ props.option.name | truncate(15) }}</span>
        </div>
      </template>
      <template slot="option" slot-scope="props">
        <div class="d-flex align-items-center">
          <img class="option-image" :src="props.option.avatar_url || '/img/no-image-profile.png'" alt="Staff avatar" />
          <span class="ml-2">{{ props.option.name | truncate(15) }}</span>
        </div>
      </template>
      <span slot="noResult">担当者が見つかりません</span>
    </multiselect>
  </div>
</template>

<script>
import { mapActions } from 'vuex';
export default {
  props: ['channel'],

  data() {
    return {
      assignee: null,
      agents: []
    };
  },

  async beforeMount() {
    const response = await this.getStaffs();
    if (!response) return;
    this.agents = response.data;
    if (this.channel.assignee_id) {
      this.assignee = this.agents.find(_ => _.id === this.channel.assignee_id);
    }
  },

  methods: {
    ...mapActions('staff', ['getStaffs']),
    ...mapActions('channel', ['assign', 'unassign']),

    async assignAgent(agent) {
      const payload = {
        channel_id: this.channel.id,
        assignee_id: agent ? agent.id : null
      };
      const response = this.assign(payload);
      if (response) {
        window.toastr.success('担当者が変更されました。');
      } else {
        window.toastr.error('失敗しました。');
      }
    }
  }
};
</script>
 <style lang="scss" scoped>
  ::v-deep {
    .option-image {
      width: 32px;
      height: 32px;
      border-radius: 50%;
      background-size: cover;
    }
  }
</style>