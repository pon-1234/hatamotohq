<template>
  <div class="mxw-1200" >
    <div class="card">
      <!-- <div class="card-header d-flex align-items-center"></div> -->
      <ValidationObserver ref="observer" v-slot="{ validate, invalid }">
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
                <span class="error-explanation">{{ errors[0] }}</span>
              </ValidationProvider>
            </div>
          </div>
          <div class="form-group row">
            <label class="col-12">タイトル<required-mark/></label>
            <div class="col-12">
              <ValidationProvider name="タイトル" rules="required|max:512" v-slot="{ errors }">
                <input type="text" class="form-control" name="announcement[title]" placeholder="入力してください" v-model="announcementData.title">
                <span class="error-explanation">{{ errors[0] }}</span>
              </ValidationProvider>
            </div>
          </div>
          <div class="form-group row">
            <label class="col-12">body<required-mark/></label>
            <div class="col-12">
              <rich-text-input :value.sync="announcementData.body"></rich-text-input>
              <ValidationProvider name="body" rules="required" v-slot="{ errors }">
                <input type="hidden" v-model="announcementData.body" name="announcement[body]"/>
                <span class="error-explanation">{{ errors[0] }}</span>
              </ValidationProvider>
            </div>
          </div>
        </div>
        <div class="card-footer row-form-btn d-flex">
          <button type="submit" class="btn btn-info fw-120" :disabled="invalid" @click="validate().then(onSubmit('published'))">登録</button>
          <button type="submit" class="btn btn-outline-info fw-120" :disabled="invalid" @click="validate().then(onSubmit('draft'))">下書き保存</button>
        </div>
      </ValidationObserver>
    </div>
  </div>
</template>
<script>
import moment from 'moment-timezone';
import { Datetime } from 'vue-datetime';
import { mapActions } from 'vuex';

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
    ...mapActions('announcement', ['createAnnouncement', 'updateAnnouncement']),

    onSubmit(status) {
      this.announcementData.status = status;
      if (this.announcementData.id) {
        this.updateAnnouncement(this.announcementData).then((response) => {
          this.onReceiveCreateUserResponse(response.id, null);
        }).catch((error) => {
          this.onReceiveCreateUserResponse(null, error.responseJSON.message);
        });
      } else {
        const formData = _.omit(this.announcementData, ['id']);
        this.createAnnouncement(formData).then((response) => {
          this.onReceiveCreateUserResponse(response.id, null);
        }).catch((error) => {
          this.onReceiveCreateUserResponse(null, error.responseJSON.message);
        });
      }
    },
    onReceiveCreateUserResponse(id, errorMessage) {
      if (id) {
        if (this.announcementData.id) {
          window.toastr.success('success update');
        } else {
          window.toastr.success('success create');
        }
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
::v-deep {
  .vdatetime-overlay {
    z-index: 1049;
  }
  .vdatetime-popup {
    z-index: 1050;
  }
}
</style>