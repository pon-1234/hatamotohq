<template>
  <section>
    <label class="w-100 mt20">
      コンテンツ
      <required-mark/>
    </label>

    <div class="btn-template mb20 fz14">
      <a data-toggle="modal" :data-target="'#'+ name" class="btn-block" v-if="currentTemplate.template_id">
        <view-message-content :data="currentTemplate.content" v-if="currentTemplate.content" />
        <span v-else>{{currentTemplate.title}}</span>
        </a>
      <a data-toggle="modal" :data-target="'#'+ name" class="btn-block" v-else>テンプレートから作成</a>
      <input type="hidden" v-model="currentTemplate.template_id"  :name="name+'_template_id'" v-validate="'required'" />
      <span  v-if="errors.first(name+'_template_id')"  class="is-validate-label">テンプレートは必須です</span>
    </div>

    <modal-select-message-template @setTemplate="selectTemplate" :id="name"/>
  </section>
</template>
<script>
export default {
  props: {
    value: {
      type: Object,
      default: () => {
        return {
          template_id: null,
          title: 'テンプレートから作成'
        };
      }
    },
    name: {
      type: String,
      default: 'postback_action'
    }
  },
  inject: ['parentValidator'],

  data() {
    return {
      currentTemplate: {
        template_id: null,
        title: null
      }
    };
  },

  created() {
    this.$validator = this.parentValidator;

    if (this.value.template_id) {
      this.currentTemplate = {
        template_id: this.value.template_id,
        title: this.value.title
      };
    }
  },

  watch: {
    currentTemplate: {
      handler(val) {
        if (this.value.template_id) {
          this.$emit('input', {
            title: val.title,
            template_id: this.value.template_id
          });
        }
      },
      deep: true
    }
  },

  methods: {
    selectTemplate(template) {
      this.currentTemplate = { template_id: template.id, ...template };
      this.$emit('input', {
        title: template.title,
        template_id: template.id
      });
    }
  }
};
</script>

<style scoped>
  .btn-block {
    cursor: pointer;
  }
</style>
