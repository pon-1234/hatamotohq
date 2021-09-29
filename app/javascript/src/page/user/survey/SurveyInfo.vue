<script src="../../state/module/flexMessage.js"></script>
<template>
  <section>
    <div class="row-ttl01 flex ai_center mb40 flex-wrap justify-content-between">
      <h3 class="hdg3">アンケート詳細</h3>
    </div>
    <div style="display: flex;flex-direction: column; margin-bottom: 20px">
      <div style="margin-bottom: 20px">
        {{survey.name}}
      </div>
      <div style="margin-bottom: 20px">
        {{survey.title}}
      </div>
      <div style="margin-bottom: 20px">
        <span>
          回答数
        </span>
        <span>
          {{survey.customers_count}}
        </span>
      </div>
    </div>

    <div class="tabs">
      <div @click="currentTab = '回答者一覧'" :class="{'active': currentTab === '回答者一覧'}">回答者一覧</div>
      <div @click="currentTab = '回答一覧'" :class="{'active': currentTab === '回答一覧'}">回答一覧</div>
      <div style="flex: 1">
      </div>
    </div>
    <div class="tab-content">
      <div v-if="currentTab === '回答者一覧'">
        <survey-response-list :data="survey.id"></survey-response-list>
      </div>
      <div v-if="currentTab === '回答一覧'">
        <survey-answer-of-customer :data="survey.id"></survey-answer-of-customer>
      </div>
    </div>
  </section>
</template>

<script>
  export default {
    props: ['data', 'route', 'plan'],

    data() {
      return {
        currentTab: '回答者一覧',
        survey: this.data,
      };
    },
    beforeMount(){
      if(!this.plan || this.plan.level!=='3'){
        window.location.href = '/';
      }
    },
    methods: {}
  }
</script>

<style lang="scss" scoped>
  ::v-deep {
    .tabs{
      display: flex;
    }
    .tabs>div{
      cursor: pointer;
      padding: 10px 20px;
      color: grey;
      border: 2px;

      border-bottom: 2px solid #00B900;
    }

    .tabs>div:hover{
      color: #00B900;

    }
    .tabs>div.active
    {

      color: #00B900;

      border-top-left-radius: 10px;
      border-top-right-radius: 10px;

      border-bottom: 0px;
      border-top: 2px solid;
      border-left: 2px solid;
      border-right: 2px solid;

      /*border-bottom-color: ;*/

    }

    .tab-content{
      padding-top: 10px;
    }

    .modal-dialog{
      margin: auto !important;
    }

  }
</style>
