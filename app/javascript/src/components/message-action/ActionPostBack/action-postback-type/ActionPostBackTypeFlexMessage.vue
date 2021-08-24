<template>
  <div>
    <label class="w-100 mt20">
      コンテンツ
      <required-mark/>
    </label>

    <div class="btn-template mb20 fz14">
      <a data-toggle="modal" :data-target="'#'+name" class="btn-block" v-if="currentTemplate.flex_message_id">
        <span >{{currentTemplate.title}}</span>
        </a>
      <a data-toggle="modal" :data-target="'#'+name" class="btn-block" v-else>Flexメッセージから作成</a>
      <input type="hidden" v-model="currentTemplate.flex_message_id"  :name="name+'_flex_message_id'" v-validate="'required'" />
      <span  v-if="errors.first(name+'_flex_message_id')"  class="is-validate-label">Flexメッセージは必須です</span>
    </div>

    <modal-select-flex-message-template :name="name" @input="selectTemplate"/>
  </div>
</template>
<script>
export default {
  props: {
    value: {
      type: Object,
      default: () => {
        return {
          flex_message_id: null,
          title: 'Flexメッセージから作成'
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
        flex_message_id: null,
        title: null
      }
    };
  },

  created() {
    this.$validator = this.parentValidator;

    if (this.value.flex_message_id) {
      this.currentTemplate = {
        flex_message_id: this.value.flex_message_id,
        title: this.value.title
      };
    }
  },

  watch: {
    currentTemplate: {
      handler(val) {
        if (this.value.flex_message_id) {
          this.$emit('input', {
            title: val.title,
            flex_message_id: this.value.flex_message_id
          });
        }
      },
      deep: true
    }
  },

  methods: {
    selectTemplate(flexMessage) {
      const json = JSON.parse(flexMessage.json_message);
      json.id = flexMessage.id;
      this.currentTemplate = { flex_message_id: json.id, ...json, title: flexMessage.name };
      this.$emit('input', {
        title: flexMessage.name,
        flex_message_id: flexMessage.id
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
