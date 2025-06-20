<template>
  <div class="mxw-1200">
    <div class="card">
      <div class="card-body">
        <div class="form-group d-flex align-items-center">
          <label class="fw-300">フォルダー</label>
          <div class="flex-grow-1">
            <select v-model="variableData.folder_id" class="form-control fw-300">
              <option v-for="(folder, index) in folders" :key="index" :value="folder.id">
                {{ folder.name }}
              </option>
            </select>
          </div>
        </div>
        <div class="form-group d-flex">
          <label class="fw-300 mb-auto">友だち情報欄名<required-mark /></label>
          <div class="fw-300">
            <input
              type="text"
              class="form-control"
              name="variable_name"
              placeholder="友だち情報欄名を入力してください"
              v-model.trim="variableData.name"
              v-validate="'required|max:255'"
              maxlength="256"
              data-vv-as="友だち情報欄名"
            />
            <error-message :message="errors.first('variable_name')"></error-message>
          </div>
        </div>
        <div class="form-group d-flex">
          <label class="fw-300">種別</label>
          <div class="fw-300">
            <select class="form-control w-100" v-model="variableData.type">
              <option v-for="(option, index) in dataTypes" :key="index" :value="option.type">
                {{ option.name }}
              </option>
            </select>
          </div>
        </div>
        <div class="form-group d-flex" v-if="isSupportDefaultValue">
          <label class="fw-300">既定値</label>
          <div class="grow-flex-1 d-flex">
            <div class="fw-300">
              <input
                type="text"
                class="form-control"
                name="variable_default"
                placeholder="友だち情報欄名を入力してください"
                v-model.trim="variableData.default"
                v-validate="'max:255'"
                maxlength="256"
                data-vv-as="既定値"
              />
              <error-message :message="errors.first('variable_default')"></error-message>
            </div>
            <div class="btn btn-light ml-1 mb-auto" @click="variableData.default = '{name}'">{name}を使用</div>
          </div>
        </div>
      </div>
      <loading-indicator :loading="loading"></loading-indicator>
      <div class="card-footer">
        <button class="btn btn-success text-nowrap" @click="submit()" :disabled="invalid">
          {{ variable_id ? "友だち情報欄変更" : "友だち情報欄登録" }}
        </button>
      </div>
    </div>
  </div>
</template>
<script>
import { mapActions, mapState } from 'vuex';
import Util from '@/core/util';
import ViewHelper from '@/core/view_helper';

export default {
  props: ['variable_id'],
  data() {
    return {
      userRootUrl: import.meta.env.VITE_ROOT_PATH,
      loading: true,
      contentKey: 0,
      variableData: {
        folder_id: null,
        name: null,
        type: 'text',
        default: null
      },
      dataTypes: [
        {
          name: 'テキスト',
          type: 'text'
        },
        {
          name: '画像',
          type: 'image'
        },
        {
          name: 'PDF',
          type: 'pdf'
        },
        {
          name: '日付',
          type: 'date'
        },
        {
          name: '時刻',
          type: 'time'
        },
        {
          name: '日付・時刻',
          type: 'datetime'
        }
      ]
    };
  },

  async created() {
    this.variableData.folder_id = Util.getParamFromUrl('folder_id');
    if (this.variable_id) {
      this.variableData.id = this.variable_id;
    }
    await this.fetchData();
    this.loading = false;
  },

  computed: {
    ...mapState('variable', {
      folders: state => state.folders
    }),

    isSupportDefaultValue() {
      return this.variableData.type === 'text';
    }
  },

  methods: {
    ...mapActions('variable', ['createVariable', 'updateVariable', 'getVariable', 'getFolders']),

    async fetchData() {
      await this.getFolders();
      if (this.variable_id) {
        const variable = await this.getVariable(this.variable_id);
        Object.assign(this.variableData, variable);
      }
    },

    async submit() {
      if (this.loading) return;
      this.loading = true;
      const result = await this.$validator.validateAll();
      if (!result) {
        this.loading = false;
        return this.scrollToRequiredField();
      }

      const payload = this.variableData;
      if (!this.variable_id) {
        const reminderId = await this.createVariable(payload);
        this.onReceiveCreateVariable(!!reminderId);
      } else {
        const reminderId = await this.updateVariable(payload);
        this.onReceiveUpdateVariable(!!reminderId);
      }
    },

    scrollToRequiredField() {
      return ViewHelper.scrollToRequiredField(false);
    },

    // Handle broadcast creation response
    onReceiveCreateVariable(success) {
      if (success) {
        Util.showSuccessThenRedirect(
          '友だち情報欄の保存は完了しました。',
          `${import.meta.env.VITE_ROOT_PATH}/user/variables?folder_id=${this.variableData.folder_id}`
        );
      } else {
        this.loading = false;
        window.toastr.error('友だち情報欄の保存は失敗しました。');
      }
    },
    onReceiveUpdateVariable(success) {
      if (success) {
        Util.showSuccessThenRedirect(
          '友だち情報欄の更新は完了しました。',
          `${import.meta.env.VITE_ROOT_PATH}/user/variables?folder_id=${this.variableData.folder_id}`
        );
      } else {
        this.loading = false;
        window.toastr.error('友だち情報欄の更新は失敗しました。');
      }
    }
  }
};
</script>