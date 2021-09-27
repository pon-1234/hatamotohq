<template>
  <div class="mxw-1200" >
    <div class="card">
      <!-- <div class="card-header d-flex align-items-center"></div> -->
      <ValidationObserver ref="observer" v-slot="{ validate }">
        <div class="card-body">
          <div class="form-group row">
            <label class="col-12">日時<required-mark/></label>
            <div class="col-12">
              <ValidationProvider name="日時" rules="required" v-slot="{ errors }">
                <datetime
                  v-model="announcementData.announced_at"
                  input-class="form-control"
                  type="datetime"
                  :phrases="{ok: '確定', cancel: '閉じる'}"
                  placeholder="日付を選択してください"
                  :min-datetime="currentDate"
                  value-zone="Asia/Tokyo"
                  zone="Asia/Tokyo"
                ></datetime>
                <error-message :message="errors[0]"></error-message>
              </ValidationProvider>
            </div>
          </div>
          <div class="form-group row">
            <label class="col-12">タイトル<required-mark/></label>
            <div class="col-12">
              <ValidationProvider name="タイトル" rules="required|max:512" v-slot="{ errors }">
                <input type="text" class="form-control" name="announcement[title]" placeholder="入力してください" v-model="announcementData.title">
                <error-message :message="errors[0]"></error-message>
              </ValidationProvider>
            </div>
          </div>
          <div class="form-group row">
            <label class="col-12">本文<required-mark/></label>
            <div class="col-12">
              <rich-text-input :value.sync="announcementData.body"></rich-text-input>
              <ValidationProvider name="本文" rules="required" v-slot="{ errors }">
                <input type="hidden" v-model="announcementData.body" name="announcement[body]"/>
                <error-message :message="errors[0]"></error-message>
              </ValidationProvider>
            </div>
          </div>
        </div>
        <div class="card-footer row-form-btn d-flex">
          <div role="button" class="btn btn-info fw-120 mr-2" @click="onSubmit('published')">登録</div>
          <div role="button" class="btn btn-outline-info fw-120" @click="onSubmit('draft')">下書き保存</div>
        </div>
      </ValidationObserver>
    </div>
  </div>
</template>
<script>
import moment from 'moment-timezone';
import { Datetime } from 'vue-datetime';
import { mapActions } from 'vuex';
import Util from '@/core/util';

export default {
  props: ['announcement'],
  components: {
    Datetime
  },
  data() {
    return {
      rootUrl: process.env.MIX_ROOT_PATH,
      announcementData: {
        id: null,
        announced_at: moment().tz('Asia/Tokyo').format(),
        title: null,
        body: null,
        status: null
      },
      currentDate: moment().tz('Asia/Tokyo').format()
    };
  },
  created() {
    Object.assign(this.announcementData, this.announcement);
  },
  methods: {
    ...mapActions('announcement', [
      'createAnnouncement', 'updateAnnouncement'
    ]),

    async onSubmit(status) {
      // Validate if status is published
      if (status === 'published') {
        const isValid = await this.$refs.observer.validate();
        if (!isValid) {
          return;
        }
      }

      this.announcementData.status = status;
      let response = null;
      if (this.announcementData.id) {
        response = await this.updateAnnouncement(this.announcementData);
        if (response) return Util.showSuccessThenRedirect('お知らせの変更は完了しました。', `${this.rootUrl}/admin/announcements`);
      } else {
        const formData = _.omit(this.announcementData, ['id']);
        response = await this.createAnnouncement(formData);
        if (response) return Util.showSuccessThenRedirect('お知らせの作成は完了しました。', `${this.rootUrl}/admin/announcements`);
      }
      if (!response) {
        window.toastr.error('お知らせの保存は失敗しました。');
      }
    }
  }
};
</script>
<style lang="scss" scoped>
::v-deep {
  .vdatetime-overlay {
    z-index: 1049;
  }
  .vdatetime-popup {
    z-index: 1050;
  }
}
</style>