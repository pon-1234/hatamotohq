<template>
  <section>
    <div>
      <label class="w-100 mt-2"> タグ設定 </label>
      <div class="row m-0">
        <div class="col-md-6 d-flex-auto p-0">
          <span>タグを追加</span>
          <div>
            <input-tag :allTags="true" :tags="value[0].tags" @input="onAssignTagsDataChanged"> </input-tag>
            <input type="hidden" v-model.trim="value" :name="name + '_assign_tag'" />
          </div>
        </div>

        <div class="col-md-6 d-flex-auto">
          <span>タグをはずす</span>
          <div>
            <input-tag :allTags="true" :tags="value[1].tags" @input="onUnassignTagsDataChanged"> </input-tag>
            <input type="hidden" v-model.trim="value" :name="name + '_unassign_tag'" />
          </div>
        </div>
      </div>
    </div>
  </section>
</template>
<script>
export default {
  props: {
    value: {
      type: Array,
      default: () => {
        return [
          {
            type: 'assign',
            tags: []
          },
          {
            type: 'unassign',
            tags: []
          }
        ];
      }
    },
    name: {
      type: String,
      default: 'postback_action'
    }
  },

  methods: {
    onAssignTagsDataChanged(tags) {
      this.value[0].tags = tags;
      this.$emit('input', this.value);
    },

    onUnassignTagsDataChanged(tags) {
      this.value[1].tags = tags;
      this.$emit('input', this.value);
    }
  }
};
</script>