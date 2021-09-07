<template>
  <div class="modal fade" id="confirmSwitch" tabindex="-1" role="dialog" aria-hidden="true" ref="vuemodal">
    <div class="modal-dialog modal-lg" role="document">
      <div class="modal-content p-2">
        <div class="modal-header">
          <label class="modal-title" id="exampleModalLongTitle" v-if="user && user.status === 'blocked'">Are you sure you want to unblock this user?</label>
          <label class="modal-title" id="exampleModalLongTitle" v-if="user && user.status === 'actived'">Are you sure you want to block this user?</label>
          <button type="button" class="close" data-dismiss="modal" aria-label="Close">
            <span aria-hidden="true">&times;</span>
          </button>
        </div>
        <div class="modal-body">
          <table class="table table-bordered table-striped">
            <thead>
              <th class="mw-150">管理者ID</th>
              <th class="mw-150">管理者メール</th>
              <th class="mw-150">管理者名</th>
            </thead>
            <tbody>
              <tr>
                <td v-if="user">{{ user.id }}</td>
                <td v-if="user">{{ user.email }}</td>
                <td v-if="user">{{ user.name }}</td>
              </tr>
            </tbody>
          </table>
        </div>
        <div class="modal-footer d-flex justify-content-center">
          <a class="btn btn-info" data-dismiss="modal" @click="onSubmit()">
            <span v-if="user && user.status === 'actived'">ブロックする</span>
            <span v-else>ブロックを解除する</span>
          </a>
        </div>
      </div>
    </div>
  </div>
</template>
<script>
import { mapActions } from 'vuex';
export default {
  props: ['users'],
  data() {
    return {
      user: null
    };
  },

  mounted() {
    $(this.$refs.vuemodal).on('show.bs.modal', this.shownModal);
  },

  methods: {
    ...mapActions('user', ['updateUser']),
    shownModal() {
      if ($('#inputValue').val()) {
        const currUserId = $('#inputValue').val();
        this.user = this.users.find(e => Number(e.id) === Number(currUserId));
      }
    },

    async onSubmit() {
      const data = {
        id: this.user.id,
        status: (this.user.status === 'blocked') ? 'actived' : 'blocked'
      };
      await this.updateUser(data);
      window.toastr.success('status changed');
      setTimeout(() => {
        location.reload();
      }, 750);
    }
  }
};
</script>

<style lang="scss" scoped>
</style>