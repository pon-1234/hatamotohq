<template>
  <div>
    <div>
      <div>
        <div class="alert alert-warning">
          パネルタイトルの有無・画像の有無・ボタンの数は全てのパネルで同じ必要があります。
        </div>
        <!-- パネルメニュー -->
        <ul class="nav nav-tabs nav-bordered" role="tablist">
          <li
            role="presentation"
            v-for="(item, index) in messageData.columns"
            :key="index"
            @click="changeSelected(index)"
          >
            <a
              aria-controls="text"
              role="tab"
              data-toggle="tab"
              aria-expanded="true"
              :class="selected === index ? 'active' : ''"
            >
              パネル{{ index + 1 }}
              <span @click="removeColumn(index)" v-if="messageData.columns.length > 1">
                <i class="fa fa-times"></i>
              </span>
            </a>
          </li>
          <li class="d-flex justify-content-center p-1" @click="addMoreColumn">
            <span> <i class="uil-plus"></i>追加 </span>
          </li>
        </ul>

        <div v-for="(column, indexColumn) in messageData.columns" :key="indexColumn" v-show="indexColumn === selected">
          <div class="carousel-group-action row">
            <div class="col-sm-5 p-0">
              <div class="form-group">
                <label
                  >パネル{{ selected + 1 }}のタイトル <required-mark></required-mark>
                  <tool-tip
                    title="各カラムのアクションの数は同じにします。画像またはタイトルの有無も、各カラムで統一してください。"
                  ></tool-tip>
                </label>
                <input
                  type="text"
                  :name="'carousel-title' + indexColumn"
                  placeholder="タイトル"
                  class="form-control"
                  v-model.trim="column.title"
                  maxlength="40"
                  v-validate="{ required: requiredTitle }"
                  data-vv-as="タイトル"
                />
                <error-message :message="errors.first('carousel-title' + indexColumn)"></error-message>
              </div>
              <div class="form-group">
                <label>パネル{{ selected + 1 }}の本文<required-mark></required-mark></label>
                <textarea
                  :name="'carousel-text' + indexColumn"
                  placeholder="本文を入力してください"
                  class="form-control"
                  v-model="column.text"
                  maxlength="60"
                  v-validate="'required'"
                  data-vv-as="本文"
                >
                </textarea>
                <error-message :message="errors.first('carousel-text' + indexColumn)"></error-message>
              </div>
            </div>
            <div class="col-sm-7">
              <div class="form-group">
                <label
                  >画像
                  <tool-tip
                    title="画像のファイルメッセージの表示が遅延することを防ぐために、個々の画像ファイルサイズを小さくしてください（1MB以下推奨。"
                  ></tool-tip
                ></label>
                <div class="row">
                  <div class="col-sm-6">
                    <div class="group-button-thumb">
                      <div
                        class="btn btn-secondary btn-block btn-sm uploadfile-thumb"
                        data-toggle="modal"
                        :data-target="'#uploadImageModal' + indexParent"
                      >
                        <i class="glyphicon glyphicon-picture"></i>
                        画像選択
                      </div>

                      <div
                        class="btn btn-outline-danger btn-sm"
                        @click="removeCurrentThumb"
                        v-if="column.thumbnailImageUrl"
                      >
                        このパネルの画像を削除
                      </div>
                      <div class="btn btn-secondary btn-sm" @click="coppyAllThumb" v-if="column.thumbnailImageUrl">
                        全パネルにこの画像をコピー
                      </div>
                      <div
                        class="btn btn-outline-danger btn-sm"
                        @click="removeAllThumb"
                        v-if="column.thumbnailImageUrl"
                      >
                        全パネルの画像を削除
                      </div>
                    </div>
                  </div>
                  <div class="col-sm-6">
                    <img v-if="column.thumbnailImageUrl" :src="column.thumbnailImageUrl" class="image-carousel-thumb" />
                    <span v-if="errorMessageUploadFile" class="label error-message-upload">{{
                      errorMessageUploadFile
                    }}</span>
                  </div>
                </div>
              </div>
            </div>
            <div class="col-sm-12 p-0 row">
              <div class="col-sm-3">
                <ul class="nav nav-tabs nav-stacked nav-buttons d-block">
                  <li
                    v-for="(item, index) in column.actions"
                    :key="index"
                    :class="selectedAction == index ? 'active' : ''"
                    @click="changeActiveAction(index)"
                  >
                    <div
                      class="nav-button d-flex"
                      :class="
                        errors.items.find((item) => item.field.includes(indexParent + 'template_button_' + index))
                          ? 'invalid-box'
                          : ''
                      "
                    >
                      ボタン{{ index + 1 }}
                      <span
                        v-if="column.actions.length > 1"
                        @click.stop="removeCurrentAction(index)"
                        class="ml-auto mr-1"
                        ><i class="dripicons-trash"></i
                      ></span>
                    </div>
                  </li>
                  <li v-if="column.actions.length < 3">
                    <div class="nav-button btn btn-primary justify-content-center" @click="addMoreAction">
                      <i class="uil-plus"></i> 追加
                    </div>
                  </li>
                </ul>
              </div>
              <div class="col-sm-9">
                <div
                  v-for="(item, index) in column.actions"
                  :key="index"
                  v-show="selectedAction === index"
                  class="card card-light"
                >
                  <div class="card-header d-flex flex-start align-items-center">
                    <label>選択肢{{ index + 1 }}</label>
                    <div class="btn btn-light btn-sm ml-auto" @click.stop="copyCurrentAction(index)">
                      <i class="mdi mdi-content-copy"></i>
                    </div>
                  </div>
                  <div class="card-body">
                    <div class="col-sm-12">
                      <action-editor
                        :name="`template_carousel_${index}_column${indexColumn}`"
                        :value="item"
                        @input="changeActionColumn(indexColumn, index, ...arguments)"
                      />
                    </div>
                  </div>
                </div>
              </div>
            </div>
          </div>
        </div>
      </div>
    </div>
    <modal-select-media
      @select="uploadThumb"
      :types="['image']"
      :id="'uploadImageModal' + indexParent"
      :filterable="false"
    ></modal-select-media>
  </div>
</template>
<script>
import ErrorMessage from '../common/ErrorMessage.vue';
import RequiredMark from '../common/RequiredMark.vue';
import ToolTip from '../common/ToolTip.vue';

export default {
  components: { RequiredMark, ErrorMessage, ToolTip },
  props: ['data', 'indexParent'],
  inject: ['parentValidator'],
  data() {
    return {
      requiredTitle: true,
      selected: 0,
      selectedAction: 0,
      errorMessageUploadFile: '',
      isThumbnail: false,
      messageData: {
        type: this.TemplateMessageType.Carousel,
        columns: [
          {
            thumbnailImageUrl: '',
            title: '',
            text: '',
            actions: [this.ActionMessage.default]
          }
        ]
      }
    };
  },

  created() {
    this.$validator = this.parentValidator;
    if (this.data) {
      Object.assign(this.messageData, this.data);
      this.$emit('input', this.messageData);
    }
  },
  watch: {
    messageData: {
      handler(val) {
        const value = _.cloneDeep(val);
        this.isThumbnail = value.columns.find(item => item.thumbnailImageUrl !== '');
        if (!this.isThumbnail) {
          value.columns.forEach(item => {
            delete item.thumbnailImageUrl;
          });
        }
        // Have to set title for all column if one column have set title
        this.requiredTitle = !!val.columns.find(item => item.title);
        this.$emit('input', value);
      },
      deep: true
    }
  },
  methods: {
    addMoreColumn(index) {
      if (this.messageData.columns.length > 9) return;
      const option = {
        thumbnailImageUrl: '',
        title: '',
        text: '',
        actions: []
      };

      this.messageData.columns[0].actions.forEach(item => {
        option.actions.push({ ...this.ActionMessage.default, label: '' });
      });

      this.messageData.columns.push(option);
      this.selected = this.messageData.columns.length - 1;
      console.log('selected tab = ', this.selected);
    },

    removeColumn(index) {
      this.messageData.columns.splice(index, 1);

      if (this.selected === this.messageData.columns.length) {
        this.selected -= 1;
      }
    },

    copyColumn(index, column) {
      if (this.messageData.columns.length > 9) return;
      // eslint-disable-next-line no-undef
      this.messageData.columns.splice(index + 1, 0, _.cloneDeep(column));
    },

    moveRightColumn(index) {
      const option = this.messageData.columns[index];
      if (this.messageData.columns[index + 1]) {
        this.messageData.columns[index] = this.messageData.columns.splice(index + 1, 1, option)[0];
        if (this.selected === index) {
          this.selected += 1;
        }
      }
    },

    moveLeftColumn(index) {
      const option = this.messageData.columns[index];
      if (this.messageData.columns[index - 1]) {
        this.messageData.columns[index] = this.messageData.columns.splice(index - 1, 1, option)[0];

        if (this.selected === index) {
          this.selected -= 1;
        }
      }
    },

    changeSelected(index) {
      this.selected = index;
    },

    uploadThumb(value) {
      this.messageData.columns[this.selected].thumbnailImageUrl = value.url;
      this.$emit('input', this.messageData);

      this.isThumbnail = true;
    },

    removeCurrentThumb() {
      this.messageData.columns[this.selected].thumbnailImageUrl = '';
      console.log('this.selected', this.selected);
      this.$emit('input', this.messageData);
    },

    coppyAllThumb() {
      this.messageData.columns.forEach(item => {
        item.thumbnailImageUrl = this.messageData.columns[this.selected].thumbnailImageUrl;
      });
    },

    removeAllThumb() {
      this.messageData.columns.forEach(item => {
        item.thumbnailImageUrl = '';
      });
    },

    changeSelectedAction(index, value) {
      this.messageData.columns[this.selected].actions.splice(index, 1, value);
    },

    changeActionColumn(indexColumn, index, data) {
      this.messageData.columns[indexColumn].actions.splice(index, 1, data);
    },

    moveTopAction(index) {
      const option = this.messageData.columns[this.selected].actions[index];
      if (this.messageData.columns[this.selected].actions[index - 1]) {
        this.messageData.columns[this.selected].actions[index] = this.messageData.columns[this.selected].actions.splice(
          index - 1,
          1,
          option
        )[0];

        if (this.selectedAction === index) {
          this.selectedAction -= 1;
        }
      }
    },

    moveBottomAction(index) {
      const option = this.messageData.columns[this.selected].actions[index];
      if (this.messageData.columns[this.selected].actions[index + 1]) {
        this.messageData.columns[this.selected].actions[index] = this.messageData.columns[this.selected].actions.splice(
          index + 1,
          1,
          option
        )[0];
        if (this.selectedAction === index) {
          this.selectedAction += 1;
        }
      }
    },

    copyCurrentAction(index) {
      if (this.messageData.columns[this.selected].actions.length < 3) {
        this.messageData.columns.forEach(item => {
          // eslint-disable-next-line no-undef
          item.actions.splice(index + 1, 0, _.cloneDeep(item.actions[index]));
        });
      }
    },

    removeCurrentAction(index) {
      this.messageData.columns.forEach(item => {
        item.actions.splice(index, 1);
      });

      if (this.selectedAction === this.messageData.columns[this.selected].actions.length) {
        this.selectedAction -= 1;
      }
    },

    addMoreAction() {
      this.messageData.columns.forEach(item => {
        item.actions.push(this.ActionMessage.default);
      });
    },

    changeActiveAction(index) {
      this.selectedAction = index;
    }
  }
};
</script>
<style lang="scss" scoped>
  .nav-stacked > li {
    float: none;
    position: relative;
    display: block;
  }

  li {
    cursor: pointer;
    display: flex;
    align-items: center;
    justify-content: center;
    .nav-button {
      width: 100% !important;
      display: flex !important;
      height: 40px;
      align-items: center !important;
      border: 1px solid #e4e4e4;
      padding-left: 10px;
    }

    .action-tab-selector-remover {
      color: #212529;
      padding: 5px;
      cursor: pointer;
      line-height: 1;
      align-items: center;
      margin-left: auto;
      display: inline-flex;
    }
  }

  li.active {
    .nav-button {
      border-left: 3px solid #727cf5;
      color: #727cf5;
      font-weight: bold;
    }
  }

  .error-message-upload {
    color: #bf5329;
    white-space: pre-line;
  }

  .template-carousel {
    padding: 15px 0;
    margin: 0px !important;
  }

  .panel-heading {
    padding: 5px 10px;
    background-color: #ccc;
  }
  .panel-body {
    padding: 0px !important;
    .panel-tool {
      padding-left: 0px !important;
      max-width: 154px;
      float: right;
    }
  }

  .carousel-body {
    background: #f1f1f1;
    overflow-y: hidden;
    margin: 0 0px;
    position: relative;
    padding: 5px;
    margin-bottom: 15px;
  }

  .carousel-group-action {
    padding: 15px;
  }

  .list-carousel {
    overflow-x: auto;
    overflow-y: hidden;
    white-space: nowrap;
    margin: 0 0;
    padding-left: 5px;
    padding-right: 10px;
  }

  .carousel-add-btn {
    border-radius: 4px;
    margin: 0 1em;
    padding: 0.2em;
    width: 100px;
    text-align: center;
    color: #999;
    background-color: rgba(255, 255, 255, 0.8);
    cursor: pointer;
    display: flex;
    flex-direction: column;
    align-items: center;
    .count-carousel {
      font-size: 20px;
    }

    .glyphicon-plus-sign {
      font-size: 35px;
    }
  }

  .carousel-preview {
    margin: 5px;
    width: 278px;
    display: inline-block;
    .carousel-header {
      .carousel-header-title {
        font-size: 14px;
        line-height: 1.5em;

        color: #aaa;
        font-weight: bold;
      }
      .carousel-header-action {
        float: right;
        .action-item {
          margin-left: 0px;
          cursor: pointer;
          display: block;
          float: left;
          text-align: center;
          line-height: 1.2;
          width: 2em;
          border-left: 1px solid #ccc;
          .glyphicon {
            font-size: 14px;
          }
        }

        .action-item:first-child {
          border-left-color: transparent;
        }
      }
    }

    .carousel-content {
      border: 1px solid #aaa;
      border-radius: 4px;
      background-color: white;
      cursor: pointer;

      .carousel-heading {
        b {
          display: block;
          padding: 0 0.5em;
          line-height: 2.5em;
          word-wrap: break-word;
          min-height: 2em;
          white-space: nowrap;
          overflow: hidden;
          text-overflow: ellipsis;
        }

        p {
          display: block;
          padding: 0 0.5em;
          border-bottom: 1px solid #eee;
          word-wrap: break-word;
          white-space: pre-line;
          margin-bottom: 0;
          line-height: 2.5em;
          min-height: 2em;
        }
      }

      .carousel-thumb {
        height: 180px;
        line-height: 159px;
        background-size: cover;
        background-position: center center;
        color: #aaa;
        text-align: center;
      }

      .carousel-action {
        .carousel-action-label-default {
          color: #ccc;
        }
        .carousel-action-label {
          text-align: center;
          line-height: 2em;
          min-height: 2em;
          overflow: hidden;
          white-space: nowrap;
          text-overflow: ellipsis;
        }
      }
    }
  }

  .group-button-thumb {
    .btn {
      width: 100%;
      margin-bottom: 20px;
    }
  }
  .btn-info {
    color: white;
    white-space: normal;
    word-break: break-word;
  }
  .btn-default {
    white-space: normal;
    word-break: break-word;
  }

  .uploadfile-thumb {
    position: relative;
    overflow: hidden;
    color: white;
    input[type="file"] {
      position: absolute;
      top: 0;
      right: 0;
      left: 0;
      opacity: 0;
      cursor: inherit;
      display: block;
    }
  }

  .image-carousel-thumb {
    height: 150px;
  }

  .active {
    .carousel-content {
      box-shadow: 0 0 2px 2px rgba(91, 192, 222, 0.6);
      border-color: #5bc0de;
    }
  }
  // Action panel
  .action-panel.active {
    box-shadow: 0 0 2px 2px rgba(91, 192, 222, 0.6);
    border-color: #5bc0de;
  }

  .btn-group {
    .btn {
      padding-left: 0px;
      padding-right: 0px;
    }
  }
</style>
