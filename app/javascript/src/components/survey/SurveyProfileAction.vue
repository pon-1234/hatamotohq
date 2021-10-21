<template>
  <div>
    <div class="btn-template fz14" data-toggle="modal" :data-target="`#${name}-modal-survey-profile-template`">
      {{this.field_name || '選択'}}
    </div>
    <modal-select-survey-profile-template :type="type" :id="`${name}-modal-survey-profile-template`"
                                          @selectTemplate="pick($event)"></modal-select-survey-profile-template>
  </div>

</template>
<script>
export default {
  props: {
    name: {
      default: '',
      type: String
    },
    field: {
      default: null,
      type: String
    },
    type: {
      default: null,
      type: String
    }
  },
  data() {
    return {
      field_name: this.field
    };
  },
  methods: {
    pick(data) {
      this.field_name = data.field_name;
      this.$emit('input', {
        id: data.id,
        field_name: data.field_name
      });
    }
  }
};
</script>
<style lang="scss" scoped>
  ::v-deep {
    .btn-template {
      max-width: 200px;
      width: 100%;
      padding: 8px;
      text-align: center;
      background: #d2d2d2;
      border-radius: 4px;
      cursor: pointer;
    }
  }

</style>
