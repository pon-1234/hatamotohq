<template>
  <div class="col-xl-12">
    <ul class="nav nav-tabs mb-3">
      <li class="nav-item">
        <a href="#users" data-toggle="tab" aria-expanded="true" class="nav-link active">
          <i class="mdi mdi-home-variant d-md-none d-block"></i>
          <span class="d-none d-md-block">回答者一覧</span>
        </a>
      </li>
      <li class="nav-item">
        <a href="#answers" data-toggle="tab" aria-expanded="false" class="nav-link">
          <i class="mdi mdi-account-circle d-md-none d-block"></i>
          <span class="d-none d-md-block">回答一覧</span>
        </a>
      </li>
    </ul>

    <div class="tab-content">
      <div class="tab-pane show active" id="users">
        <survey-friends :survey_id="id"></survey-friends>
      </div>
      <div class="tab-pane" id="answers">
        <survey-responses :survey_id="id"></survey-responses>
      </div>
    </div>
  </div>
</template>

<script>
export default {
  props: ['id'],

  data() {
    return {
      answered_users: [],
      responses: []
    };
  }
};
</script>

<style>
</style>