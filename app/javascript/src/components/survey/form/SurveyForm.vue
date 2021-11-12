<template>
  <ValidationObserver ref="observer" v-slot="{ validate }">
    <form
      ref="form"
      @submit.prevent="validate().then(onSubmit)"
      :action="formAction"
      method="post"
      enctype="multipart/form-data"
    >
      <input type="hidden" name="authenticity_token" :value="csrfToken" />
      <div class="card" v-if="survey">
        <div class="card-body">
          <survey-form-content :survey="survey" :preview="false"></survey-form-content>
        </div>
        <div class="card-footer">
          <div class="btn btn-success fw-120">送信</div>
        </div>
        <loading-indicator :loading="loading"></loading-indicator>
      </div>
      <div class="alert alert-warning" role="alert" v-if="!survey && !loading">
        <h4 class="alert-heading">エラー</h4>
        <p>アクセスが拒否されました。</p>
      </div>
    </form>
  </ValidationObserver>
</template>

<script>
import { mapActions } from 'vuex';
import Util from '@/core/util.js';

export default {
  props: {
    code: {
      type: Number
    },
    friend_id: {
      type: String
    }
  },

  data() {
    return {
      userRootUrl: process.env.MIX_ROOT_PATH,
      csrfToken: Util.getCsrfToken(),
      loading: true,
      survey: null
    };
  },

  async beforeMount() {
    this.survey = await this.getSurveyByCode(this.code);
    this.loading = false;
  },

  computed: {
    formAction() {
      return `${this.userRootUrl}/surveys/${this.code}/${this.friend_id}`;
    }
  },

  methods: {
    ...mapActions('survey', ['getSurveyByCode', 'postAnswer']),

    async onSubmit(e) {
      console.log('======');
      this.$refs.form.submit();
    }
    // async submit() {
    //   const valid = await this.$validator.validateAll();
    //   if (!valid) return;
    //   const payload = _.pick(this.survey, ['questions']);
    //   payload.code = this.code;
    //   payload.friend_id = this.friend_id;
    //   const response = await this.postAnswer(payload);
    //   console.log('------response------', response);
    // }
  }
};
</script>

<style>
</style>