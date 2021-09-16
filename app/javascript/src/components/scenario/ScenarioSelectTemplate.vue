<template>
  <section>
    <div data-toggle="modal" data-target="#modalSelectTemplate" class="btn btn-primary mw-150">テンプレートを追加</div>
    <modal-select-template @selectTemplate="onSelectTemplate" id="modalSelectTemplate"></modal-select-template>
  </section>
</template>

<script>
import { mapActions } from 'vuex';
export default {
  props: {
    scenario_id: {
      type: Number,
      required: true
    }
  },

  methods: {
    ...mapActions('scenario', [
      'createMessagesFromTemplate'
    ]),

    async onSelectTemplate(template) {
      const payload = {
        scenario_id: this.scenario_id,
        template_id: template.id
      };
      await this.createMessagesFromTemplate(payload);
      location.reload();
    }
  }
};
</script>

<style>

</style>