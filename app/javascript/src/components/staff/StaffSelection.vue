<template>
  <div>
    <multiselect
      v-model="selectedStaff"
      :allow-empty="true"
      :options="agents"
      :option-height="60"
      :show-labels="false"
      placeholder="未割り当て"
      noOptions="データはありません"
      label="name"
      track-by="id"
      :multiple="false"
      :showNoResults="false"
      @select="onSelected"
      @remove="onSelected(null)"
    >
      <template slot="singleLabel" slot-scope="props">
        <div class="d-flex align-items-center">
          <img class="option-image" :src="props.option.avatar_url || '/img/no-image-profile.png'" alt="Staff avatar" />
          <span class="ml-2">{{ props.option.name | truncate(12) }}</span>
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
  props: {
    selected: {
      type: Number,
      required: false
    }
  },
  data() {
    return {
      selectedStaff: null,
      agents: []
    };
  },

  async beforeMount() {
    const response = await this.getAllStaffs();
    if (!response) return;
    this.agents = response;
    if (this.selected) this.findStaff(this.selected);
  },

  methods: {
    ...mapActions('staff', ['getAllStaffs']),
    ...mapActions('channel', ['assign', 'unassign']),

    async onSelected(agent) {
      this.$emit('select', agent ? agent.id : null);
    },

    findStaff(staffId) {
      this.selectedStaff = this.agents.find(_ => _.id === staffId);
    }
  }
};
</script>
 <style lang="scss" scoped>
  ::v-deep {
    .option-image {
      width: 25px;
      height: 25px;
      border-radius: 50%;
      background-size: cover;
    }
    .multiselect__tags {
      height: 40px !important;
    }
  }
</style>