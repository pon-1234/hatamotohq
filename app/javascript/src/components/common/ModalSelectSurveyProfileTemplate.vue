<template>
  <div class="modal fade modal-template modal-common01" :id="id? id:'modal-template'" tabindex="-1" role="dialog" aria-labelledby="myModalLabel" aria-hidden="true">
    <div class="modal-dialog" role="document">
      <div class="modal-content">
        <div class="modal-body overflow-hidden">
          <button type="button" class="close" data-dismiss="modal" aria-label="Close"><span
            aria-hidden="true">&times;</span></button>
          <label class="mb15">テンプレートを選択してください</label>
          <div class=" template-list-content" v-if="surveys && surveys.length">
            <folder-left
              type="survey_profile"
              :isPerview="true"
              :data="surveys"
              :isPc="isPc"
              :selectedFolder="selectedFolder"
              @changeSelectedFolder="changeSelectedFolder"
            ></folder-left>
            <div :class="getClassRightTag()">
              <div class="tag-content">
                <div class="x-tag-header">
                  <div class="x-btn-back">
                    <i style="margin: auto" class="fas fa-arrow-left item-sm" @click="backToFolder"></i></div>
                  <div class="x-title"
                       v-if="surveys[selectedFolder]">{{surveys[selectedFolder].name}}
                  </div>
                </div>

                <div class="tag-scroll" v-if="!isBlink">
                  <div class="tbl-admin01 tbl-linebot01 table-responsive fz14 text-center" style="overflow: auto; height: 460px">
                    <table class="table table-hover table-scenario" style="    min-width: 100%;">
                      <thead>
                      <tr>
                        <th style="width: 60%;">名称</th>
                        <th style="width: 40%;"></th>
                        <th style="width: 100%;"></th>
                      </tr>
                      </thead>
                      <tbody v-if="surveyContents && surveyContents.length">
                      <tr v-for="(survey, index) in surveyContents" v-bind:key="index">
                        <td style="text-align: left;">{{survey.field_name}}</td>
                        <td style="text-align: left;">{{survey.type}}</td>
                        <td class="row-btn" style="text-align: left; display: flex; width: 100%">
                          <div class="btn-edit01">
                            <a  @click="selectTemplate(survey)" class="btn-more btn-more-linebot btn-block"  data-dismiss="modal">
                              選択
                            </a>
                          </div>
                        </td>
                      </tr>
                      </tbody>
                      <tbody v-else>
                      <tr>
                        <td colspan="3">
                          データなし
                        </td>
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
    </div>
  </div>
</template>

<script>
export default {
  props: ['plan', 'id', 'type'],
  data() {
    return {
      isBlink: false,
      surveys: [],
      surveysData: [],
      selectedFolder: 0,
      scenarioIndex: 0,
      surveyContents: 0,
      isPc: true,
      survey: null,
      textSearch: null
    };
  },

  computed: {
  },

  beforeMount() {
    this.getSurveyProfiles();
  },

  methods: {
    blink() {
      this.isBlink = true;
      this.$nextTick(() => {
        this.isBlink = false;
      });
    },
    getSurveyProfiles() {
      this.$store.dispatch('survey/getSurveyProfiles', { status: 'publish', type: this.type }).done((res) => {
        console.log(res);
        this.surveys = res;
        this.surveyData = JSON.parse(JSON.stringify(res));
        if (this.surveys.length > this.selectedFolder) {
          this.surveyContents = this.surveys[this.selectedFolder].survey_profile_templates;
        }
      }).fail(() => {
      });
    },
    getClassRightTag() {
      let className = 'col-md-8 tag-content-right';

      if (!this.isPc) {
        className += ' item-pc';
      }

      return className;
    },

    backToFolder() {
      this.isPc = false;
    },

    changeSelectedFolder(index) {
      this.selectedFolder = index;
      this.isPc = true;
      this.surveyContents = this.surveys[index].survey_profile_templates;
      this.blink();
    },

    selectTemplate(survey) {
      console.log(survey, 'survey');
      // eslint-disable-next-line no-undef
      const data = _.cloneDeep(survey);
      this.$emit('selectTemplate', data);
    }

  }
};
</script>
<style lang="scss" scoped>
  .modal-template {
    .item-sm {
      display: none;
    }

    @media (max-width: 991px) {
      .item-pc {
        display: none !important;
      }

      .item-sm {
        display: inline-block !important;
      }

      .fa-arrow-left {
        margin-right: 10px;
        cursor: pointer;
      }
    }
    .message-title {
      width: 150px !important;
    }

    .modal-dialog {
      max-width: 800px;
      .table-tags-header {
        margin-bottom: 0px !important;
        max-width: none !important;
      }

      .template-list-content {
        background-color: #f0f0f0;

        .folder-item {
          cursor: pointer;
        }

        .folder-item:hover {
          background: #f0ad4e;
        }

        .list-content {
          height: 100%;
          max-height: 500px;
          overflow: hidden;
          display: flex;
          flex-direction: column;
          .list-scroll {
            height: 100%;
            overflow-x: hidden;
            overflow-y: auto;
            margin: 0 0;
            display: flex;
            flex-direction: column;
          }
        }
      }
    }

    .table-messages-template {
      max-width: none;
      margin-top: 0px;
      tr {
        td {
          vertical-align: middle !important;
        }
      }
    }
  }

  ::v-deep {
    .carousel-content {
      width: 130px !important;
      .carousel-thumb {
        height: 70px !important;
        line-height: 70px !important;
      }
    }

    .buttons-content,
    .imagemap,
    .location-content,
    .chat-item-voice,
    .thumbnail-item,
    .confirm-content {
      width: 150px;
      max-width: 150px;
    }

    .thumbnail-item {
      max-height: 100px;
      height: 100px;
    }

    .sticker-static {
      max-width: 110px !important;
      max-height: 100px !important;
    }
  }
</style>
