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

  created() {
    console.log('----------------------', this.value);
  },

  // data() {
  //   return {
  //     refreshTag: true
  //   };
  // },

  // watch: {
  //   value(val) {
  //     this.refreshTag = false;
  //     this.$nextTick(() => {
  //       this.tagIds = Array.isArray(val.tag_ids) ? val.tag_ids : [];

  //       this.refreshTag = true;
  //     });
  //   }
  // },

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
