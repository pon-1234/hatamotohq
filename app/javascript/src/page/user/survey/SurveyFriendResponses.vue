<template>
  <div>
    <div class="card">
      <div class="card-body">
        <!-- profile image -->
        <div class="text-center">
          <img v-lazy="avatarImgObj" class="rounded-circle avatar-lg img-thumbnail" alt="profile-image" />
        </div>
        <!-- line user name -->
        <h3 class="profile-username text-center">{{ friend.line_name }}</h3>
      </div>
    </div>
    <div class="card">
      <div class="card-header border-bottom border-primary">
        <h4>
          回答一覧<span class="font-16 font-weight-normal">（全{{ responses.length }}回）</span>
        </h4>
      </div>
      <div class="card-body">
        <div v-for="(response, index) in responses" :key="index">
          <survey-response :response="response"></survey-response>
        </div>
      </div>

      <loading-indicator :loading="loading"></loading-indicator>
    </div>
  </div>
</template>

<script>
import { mapActions } from 'vuex';

export default {
  props: ['survey_id', 'friend', 'avatar_url'],
  data() {
    return {
      rootPath: import.meta.env.VITE_ROOT_PATH,
      loading: true,
      contentKey: 0,
      responses: [],
      avatarImgObj: {
        src: this.avatar_url,
        error: '/img/no-image-profile.png',
        loading: '/images/loading.gif'
      }
    };
  },

  async beforeMount() {
    this.responses = await this.getFriendResponses({ survey_id: this.survey_id, friend_id: this.friend.id });
    this.loading = false;
  },

  methods: {
    ...mapActions('survey', ['getFriendResponses'])
  }
};
</script>