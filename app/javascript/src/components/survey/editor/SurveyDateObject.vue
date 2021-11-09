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
          maxlength="140"
          placeholder=""
          v-validate="'required'"
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
          placeholder=""
          data-vv-as="補足文"
        />
        <error-message :message="errors.first(name + '-subtext')"></error-message>
      </div>
    </div>
    <div class="form-group clearfix d-flex">
      <span class="fw-200">回答の情報登録</span>
      <div class="flex-grow-1">
        <survey-profile-action
          type="text"
          :field="value.variable ? value.variable.name : null"
          :name="name + '-infomation'"
          @input="value.variable = $event"
        ></survey-profile-action>
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
        { id: 3, name: '友だち情報名', type: 'survey_profile' }
      ],
      friendInformationSelected: { id: 0, name: '選択なし', type: 'none' },
      value: this.content || {
        variable: {
          name: null,
          id: null
        },
        name: this.name,
        text: null,
        sub_text: null
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
        this.value.variable = {
          name: null,
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
