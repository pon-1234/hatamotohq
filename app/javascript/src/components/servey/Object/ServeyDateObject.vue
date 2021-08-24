<template>
    <section class="form-common01">
        <div class="form-group clearfix" >
            <label class="col-sm-3">質問名 <required-mark/></label>
            <div class="col-sm-9">
                <input v-model.trim="value.text"
                       type="text"
                       :name="name+'-text'"
                       class="form-control"
                       maxlength="140"
                       placeholder="" v-validate="'required'">
                <span v-if="errors.first(name+'-text')" class="is-validate-label">質問名は必須です</span>
            </div>
        </div>
        <div class="form-group clearfix">
            <label class="col-sm-3">質問補足</label>
            <div class="col-sm-9">
                <input v-model.trim="value.sub_text"
                       :name="name+'-subtext'"
                       type="text"
                       class="form-control"
                       placeholder="">
                <span v-if="errors.first(name+'-subtext')" class="is-validate-label">質問補足は必須です</span>
            </div>
        </div>

        <div class="form-group clearfix">
            <label class="col-sm-3">回答の情報登録</label>
            <div class="col-sm-9">
                <select @change="changeProfileInformation" class="form-control" style="max-width: 220px"
                      v-model="friendInformationSelected">
                  <option v-for="(friendInformation, index) in friendInformations" :value="friendInformation"
                          :key="index">{{friendInformation.name}}
                  </option>
                </select>
                <div v-if="value.profile" style="margin-top: 10px;">
                  <survey-profile-action v-if="value.profile.id === 3" type="date" :field="value.survey_profile_template? value.survey_profile_template.field_name: null" :name="name+'-infomation'" @input="value.survey_profile_template = $event"></survey-profile-action>
                </div>
            </div>
        </div>
    </section>
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
        survey_profile_template: {
          field_name: null,
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
        .form-group{
            padding: 5px 0;
        }

    }
</style>
