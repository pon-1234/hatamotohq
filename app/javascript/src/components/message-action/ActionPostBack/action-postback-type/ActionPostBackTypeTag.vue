<template>
  <section>

    <div class="w-100">
      <input-tag
              v-if="refreshTag"
        :allTags="true"
        :data="list_tag"
        class="w-100" @input="changeListTag">
      </input-tag>
      <input type="hidden" v-model="list_tag" :name="name+'_postback_tags'" />
    </div>
  </section>

</template>
<script>
import { mapState } from 'vuex';
export default {
  props: {
    value: {
      type: [Array, Object],
      default: () => []
    },
    name: {
      type: String,
      default: 'postback_action'
    }
  },

  data() {
    return {
      list_tag: null,
      refreshTag: true
    };
  },

  created() {
    this.list_tag = Array.isArray(this.value.tag_ids) ? this.value.tag_ids : [];
  },

  watch: {
    value(val) {
      this.refreshTag = false;
      this.$nextTick(() => {
        this.list_tag = Array.isArray(val.tag_ids) ? val.tag_ids : [];

        this.refreshTag = true;
      });
    }
  },

  computed: {
    ...mapState('global', {
      tags: state => state.tags
    })
    // list_tag() {
    //     console.log(JSON.stringify(this.value.tag_ids), 'XZXX');
    //   return Array.isArray(this.value.tag_ids) ? this.value.tag_ids : [];
    // }
  },

  methods: {
    changeListTag(tags) {
      // this.list_tag = tags;
      this.$emit('input', {
        tag_ids: tags
      });
    }
  }
};
</script>

<style scoped>

</style>
