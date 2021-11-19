<template>
  <div
    class="modal fade"
    :id="id ? id : 'modalSelectSurvey'"
    tabindex="-1"
    role="dialog"
    aria-labelledby="myModalLabel"
    aria-hidden="true"
  >
    <div class="modal-dialog modal-xl modal-dialog-scrollable" role="document">
      <div class="modal-content">
        <div class="modal-header">
          <h4 class="modal-title">回答フォームを選択してください</h4>
          <button type="button" class="close" data-dismiss="modal" aria-label="Close">
            <span aria-hidden="true">×</span>
          </button>
        </div>
        <div class="modal-body">
          <div class="d-flex" v-if="folders && folders.length">
            <folder-left
              type="survey"
              :isPerview="true"
              :data="folders"
              :isPc="isPc"
              :selectedFolder="selectedFolder"
              @changeSelectedFolder="selectedFolder = $event"
            ></folder-left>
            <div class="flex-grow-1" :key="contentKey">
              <div class="table-responsive">
                <table class="table table-hover">
                  <thead class="thead-light">
                    <tr>
                      <th>
                        <span v-if="curFolder">{{ curFolder.name }}</span>
                      </th>
                    </tr>
                  </thead>
                  <tbody v-if="curFolder.surveys && curFolder.surveys.length">
                    <tr v-for="(item, index) in curFolder.surveys" :key="index" class="folder-item">
                      <td class="d-flex w-100">
                        <div class="item-name mr-3">{{ item.name }}</div>
                        <div
                          class="btn btn-info btn-sm ml-auto mw-80 my-auto"
                          @click="selectSurvey(item)"
                          data-dismiss="modal"
                        >
                          選択
                        </div>
                      </td>
                    </tr>
                  </tbody>
                  <tbody v-else>
                    <tr>
                      <td class="text-center pt40">データーがありません</td>
                    </tr>
                  </tbody>
                </table>
              </div>
            </div>
          </div>
        </div>
      </div>
    </div>
  </div>
</template>

<script>
import { mapActions, mapState } from 'vuex';
export default {
  props: ['id'],
  data() {
    return {
      contentKey: 0,
      selectedFolder: 0
    };
  },

  async beforeMount() {
    await this.getSurveys();
  },

  computed: {
    ...mapState('survey', {
      folders: state => state.folders
    }),

    curFolder() {
      return this.folders ? this.folders[this.selectedFolder] : null;
    }
  },

  methods: {
    ...mapActions('survey', ['getSurveys']),

    forceRerender() {
      this.contentKey++;
    },

    selectSurvey(survey) {
      console.log(survey, 'survey');
      // eslint-disable-next-line no-undef
      const data = _.cloneDeep(survey);
      this.$emit('selectSurvey', data);
    }
  }
};
</script>
