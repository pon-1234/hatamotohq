<template>
  <div>
    <table class="table table-centered">
      <thead class="thead-light">
        <tr>
          <th>名前</th>
          <th>回答数</th>
          <th></th>
        </tr>
      </thead>
      <tbody>
        <tr v-for="(user, index) in users" :key="index">
          <td class="mw-200 text-truncate table-user">
            <img v-lazy="user.avatar_url || '/img/no-image-profile.png'" class="mr-2 rounded-circle" />
            {{ user.display_name }}
          </td>
          <td class="mw-400">{{ user.responses_count }}</td>
          <td>
            <a class="btn btn-sm btn-secondary" :href="`${rootPath}/user/surveys/${survey_id}/${user.id}/responses`"
              >回答表示</a
            >
          </td>
        </tr>
      </tbody>
    </table>
    <div class="text-center">
      <div>
        <base-pagination
          v-if="totalRows > perPage"
          v-model="currentPage"
          :total-rows="totalRows"
          :per-page="perPage"
          @change="loadUsers"
          aria-controls="my-table"
        ></base-pagination>
      </div>
    </div>
  </div>
</template>

<script>
import { mapActions, mapState } from 'vuex';

export default {
  props: ['survey_id'],
  data() {
    return {
      rootPath: import.meta.env.VITE_ROOT_PATH,
      loading: true,
      contentKey: 0,
      currentPage: 1
    };
  },

  async beforeMount() {
    await this.getAnsweredUsers(this.queryParams);
  },

  computed: {
    ...mapState('survey', {
      users: state => state.users,
      totalRows: state => state.usersTotalRows,
      perPage: state => state.usersPerPage
    }),

    queryParams() {
      return { id: this.survey_id, page: this.currentPage };
    }
  },

  methods: {
    ...mapActions('survey', ['getAnsweredUsers']),

    loadUsers() {
      this.$nextTick(async() => {
        this.loading = true;
        this.getAnsweredUsers(this.queryParams);
        this.loading = false;
      });
    }
  }
};
</script>

<style>
</style>