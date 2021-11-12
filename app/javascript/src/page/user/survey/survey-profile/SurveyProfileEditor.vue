<template>
  <section>
    <div
      class="modal fade modal-template modal-common01"
      :id="id ? id : 'modal-template'"
      tabindex="-1"
      role="dialog"
      aria-labelledby="myModalLabel"
      aria-hidden="true"
    >
      <div class="modal-dialog" role="document">
        <div class="modal-content">
          <div class="modal-body overflow-hidden">
            <div class="row-ttl01 flex ai_center mb40 flex-wrap justify-content-between">
              <h3 class="hdg3">フォルダー <span v-if="model">(Edit)</span><span v-else>(Create)</span></h3>
            </div>

            <div style="display: contents">
              <label class="w-100 mt20">
                友だち情報名
                <required-mark />
              </label>
              <div class="w-100">
                <input
                  name="label"
                  placeholder="ラベルを入力してください"
                  type="text"
                  maxlength="12"
                  v-model="data.name"
                  class="w-100 form-control"
                  v-validate="'required'"
                />
                <span v-if="errors.has('label')" class="invalid-box-label">友だち情報名は必須です</span>
              </div>
              <label style="margin-top: 20px"> 形式 </label>
              <div class="w-100">
                <select v-model="data.type" v-validate="'required'" name="selectBox">
                  <option v-for="(item, key) of types" :key="key" :value="key">
                    {{ item }}
                  </option>
                </select>
                <span v-if="errors.has('selectBox')" class="invalid-box-label">形式は必須です</span>
              </div>
              <div class="d-flex justify-content-center" style="margin-top: 40px">
                <div class="btn btn-submit btn-block" @click="submitForm()">保存</div>
              </div>
            </div>
          </div>
        </div>
      </div>
    </div>
  </section>
</template>

<script>
import { mapActions } from 'vuex';

export default {
  props: ['id', 'folderId', 'model'],
  data() {
    return {
      data: this.model || {
        name: null,
        type: null,
        description: null
      },

      types: {
        text: 'テキスト',
        file: 'ファイル添付',
        date: '日付'
      }
    };
  },
  created() {},

  watch: {
    model: {
      deep: true,
      handler(val) {
        // eslint-disable-next-line no-undef
        this.data = _.cloneDeep(
          val || {
            name: null,
            type: null,
            description: null
          }
        );
        // console.log(val);
      }
    }
  },
  methods: {
    ...mapActions('survey', ['addSurveyProfile', 'updateSurveyProfile']),

    async submitForm() {
      const passed = await this.$validator.validateAll();
      if (!passed) {
        return;
      }

      if (this.model && this.model.id) {
        // edit
        this.updateSurveyProfile(this.data).then(e => {
          this.$emit('submited', e);
        });
      } else {
        this.addSurveyProfile(
          Object.assign(this.data, {
            folder_id: this.folderId
          })
        ).then(e => {
          this.$emit('submited', e);
        });
      }
    }
  }
};
</script>
