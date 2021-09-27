<template>
  <div class="modal fade" id="announcementConfirmSwitch" tabindex="-1" role="dialog" aria-hidden="true" ref="vuemodal">
    <div class="modal-dialog modal-lg" role="document">
      <div class="modal-content p-2">
        <div class="modal-header">
          <label class="modal-title" id="exampleModalLongTitle" v-if="announcement && announcement.status === 'unpublished'"> published?</label>
          <label class="modal-title" id="exampleModalLongTitle" v-if="announcement && announcement.status === 'published'">unpublished?</label>
          <button type="button" class="close" data-dismiss="modal" aria-label="Close">
            <span aria-hidden="true">&times;</span>
          </button>
        </div>
        <div class="modal-body">
          <table class="table table-bordered table-striped">
            <thead>
              <th class="mw-150">ユーザーID</th>
              <th class="mw-150">日時</th>
              <th class="mw-150">タイトル</th>
            </thead>
            <tbody>
              <tr>
                <td v-if="announcement">{{ announcement.id }}</td>
                <td v-if="announcement">{{ formattedDatetime(announcement.announced_at) }}</td>
                <td v-if="announcement">{{ announcement.title }}</td>
              </tr>
            </tbody>
          </table>
        </div>
        <div class="modal-footer d-flex justify-content-center">
          <a class="btn btn-info" data-dismiss="modal" @click="onSubmit()">
            <span v-if="announcement && announcement.status === 'published'">unpublished</span>
            <span v-else>published</span>
          </a>
        </div>
      </div>
    </div>
  </div>
</template>
<script>
import Util from '@/core/util';
import { mapActions } from 'vuex';
export default {
  props: ['announcements'],
  data() {
    return {
      rootUrl: process.env.MIX_ROOT_PATH,
      announcement: {}
    };
  },
  methods: {
    ...mapActions('announcement', ['updateAnnouncement']),
    shownModal(id) {
      this.announcement = this.announcements.find(e => e.id === Number(id));
    },
    formattedDatetime(time) {
      return Util.formattedDatetime(time);
    },
    onSubmit() {
      const data = {
        id: this.announcement.id,
        status: (this.announcement.status === 'unpublished') ? 'published' : 'unpublished'
      };
      this.updateAnnouncement(data).then((response) => {
        this.onReceiveCreateUserResponse(response.id, null);
      }).catch((error) => {
        this.onReceiveCreateUserResponse(null, error.responseJSON.message);
      });
    },
    onReceiveCreateUserResponse(id, errorMessage) {
      if (id) {
        window.toastr.success('success');
        setTimeout(() => {
          window.location.href = `${this.rootUrl}/admin/announcements`;
        }, 750);
      } else {
        window.toastr.error(errorMessage);
      }
    }
  }
};
</script>

<style lang="scss" scoped>
</style>