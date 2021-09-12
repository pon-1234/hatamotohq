<template>
  <section>
    <div>
      <input-tag
        :allTags="true"
        :tags="value"
        @input="onTagsChanged">
      </input-tag>
      <input type="hidden" v-model="value" :name="name+'_postback_tags'" />
    </div>
  </section>

</template>
<script>
import { mapState } from 'vuex';
export default {
  props: {
    value: {
      type: Array,
      default: () => []
    },
    name: {
      type: String,
      default: 'postback_action'
    }
  },

  computed: {
    ...mapState('global', {
      tags: state => state.tags
    })
  },

  methods: {
    onTagsChanged(tags) {
      this.$emit('input', tags);
    }
  }
};
</script>

<style scoped>

</style>
