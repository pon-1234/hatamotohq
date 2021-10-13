<template>
  <div>
    <div class="form-group clearfix d-flex">
      <span class="fw-200">項目名<required-mark /></span>
      <div class="flex-grow-1">
        <input
          v-model.trim="value.text"
          type="text"
          :name="name + '-text'"
          class="form-control"
          maxlength="256"
          placeholder="項目名を入力してください"
          v-validate="'required|max:255'"
          data-vv-as="項目名"
        />
        <error-message :message="errors.first(name + '-text')"></error-message>
      </div>
    </div>
    <div class="form-group clearfix d-flex">
      <div class="fw-200 d-flex align-items-center">
        <span>補足文</span>
        <div v-b-tooltip.hover title="回答入力欄の下に表示されます" class="ml-2">
          <i class="text-md far fa-question-circle"></i>
        </div>
      </div>
      <div class="flex-grow-1">
        <input
          v-model.trim="value.sub_text"
          :name="name + '-subtext'"
          type="text"
          class="form-control"
          placeholder="補足文を入力してください"
          v-validate="'max:255'"
          data-vv-as="補足文"
        />
        <error-message :message="errors.first(name + '-subtext')"></error-message>
      </div>
    </div>
    <div class="form-group clearfix d-flex">
      <span class="fw-200">回答の情報登録</span>
      <div class="flex-grow-1">
        <select @change="changeProfileInformation" class="form-control" v-model="friendInformationSelected">
          <option v-for="(friendInformation, index) in friendInformations" :value="friendInformation" :key="index">
            {{ friendInformation.name }}
          </option>
        </select>
        <div v-if="value.profile" style="margin-top: 10px">
          <survey-profile-action
            v-if="value.profile.id === 3"
            type="text"
            :field="value.survey_profile_template ? value.survey_profile_template.field_name : null"
            :name="name + '-infomation'"
            @input="value.survey_profile_template = $event"
          ></survey-profile-action>
        </div>
      </div>
    </div>
  </div>
</template>

<script>
export default {
  props: ['content', 'name'],
  data() {
    return {
      friendInformations: [
        { id: 0, name: '選択なし', type: 'none' },
        { id: 1, name: '表示名', type: 'display_name' },
        { id: 2, name: 'メモ欄', type: 'note' },
        { id: 3, name: '友だち情報名', type: 'survey_profile' }
      ],
      friendInformationSelected: { id: 0, name: '選択なし', type: 'none' },
      value: this.content || {
        name: this.name,
        text: null,
        sub_text: null,
        survey_profile_template: {
          field_name: null,
          id: null
        }
      }
    };
  },
  inject: ['parentValidator'],

  created() {
    this.$validator = this.parentValidator;
    this.value.name = this.name;
    if (this.value.profile) {
      this.friendInformationSelected = this.value.profile;
    }
    this.syncObj();
  },
  watch: {
    content(val) {
      this.value = val || {
        name: this.name,
        text: null,
        sub_text: null
      };
    }
  },
  methods: {
    changeProfileInformation() {
      // eslint-disable-next-line no-undef
      this.value.profile = _.cloneDeep(this.friendInformationSelected);
      if (this.value.profile.id !== 3) {
        this.value.survey_profile_template = {
          field_name: null,
          id: null
        };
      }
    },
    syncObj() {
      this.$emit('input', this.value);
    }
  }
};
</script>
<style lang="scss" scoped>
  ::v-deep {
    .form-group {
      padding: 5px 0;
    }
  }
</style>
