<template>
  <div>
    <template v-if="visible">
      <div class="btn btn-sm btn-warning" data-toggle="modal" data-target="#modalConfirmToggleVisible">未表示</div>
    </template>
    <template v-else>
      <div class="btn btn-sm btn-warning" data-toggle="modal" data-target="#modalConfirmToggleVisible">表示</div>
    </template>

    <modal-confirm id="modalConfirmToggleVisible" title="友達表示状況の変更してもよろしいですか？" type="confirm" @confirm="toggle()">
      <template v-slot:content>
        <b>{{ visible ? '表示' : '未表示' }}</b> <i class="mdi mdi-arrow-right-bold"></i> <b>{{ visible ? '未表示' : '表示' }}</b>
      </template>
    </modal-confirm>
  </div>
</template>

<script>
import { mapActions } from 'vuex';
export default {
  props: {
    id: {
      type: Number
    },
    visible: {
      type: Boolean
    }
  },

  methods: {
    ...mapActions('friend', [
      'toggleVisible'
    ]),

    async toggle() {
      await this.toggleVisible(this.id);
      location.reload();
    }
  }
};
</script>
