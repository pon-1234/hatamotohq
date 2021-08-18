<template>
  <div>
    <div class="border template-carousel row">
      <div class="col-md-12">
        <div class="panel panel-default pb20 mb-0">
          <div class="panel-heading">
            <h5>カルーセル（プレビュー）</h5>
          </div>
          <div class="panel-body">
            <div class="carousel-body">
              <div class="list-carousel d-flex align-items-center">
                <div class="carousel-group d-flex align-items-center">
                  <div v-for="(item, index) in defaults.columns" :key="index" :class="selected === index ? 'carousel-preview active': 'carousel-preview'">
                    <div class="carousel-header">
                      <span class="carousel-header-title">{{index+1}}枚目</span>
                      <div class="carousel-header-action">
                        <span class="action-item" v-if="defaults.columns.length > 1" @click="moveLeftColumn(index)"><i  class="glyphicon glyphicon-arrow-left"></i></span>
                        <span class="action-item" v-if="defaults.columns.length > 1" @click="moveRightColumn(index)"><i  class="glyphicon glyphicon-arrow-right"></i></span>
                        <span class="action-item" @click="copyColumn(index, item)"><i  class="fas fa-copy glyphicon"></i></span>
                        <span class="action-item" @click="addMoreColumn(index)"><i  class="glyphicon glyphicon-plus"></i></span>
                        <span class="action-item" v-if="defaults.columns.length > 1" @click="removeColumn(index)"><i  class="glyphicon glyphicon-remove"></i></span>
                      </div>
                    </div>
                    <div class="carousel-content" @click="changeSelected(index)"  :class="errors.items.find(item=>item.field.includes('template_carousel_'+index))? 'is-validate': ''">
                      <div class="carousel-thumb" :style="{ backgroundImage: 'url(' + item.thumbnailImageUrl + ')'}" v-if="item.thumbnailImageUrl" >
                      </div>
                      <div v-if="isThumbnail && 'thumbnailImageUrl' in item && !item.thumbnailImageUrl" class="carousel-thumb" :class="errors.first('image-url-'+ index)?'is-validate':'' ">
                        (画像未登録)
                      <input type="hidden" v-model="item.thumbnailImageUrl" :name="'image-url-'+index" v-validate="'required'" />
                      </div>
                      <div class="carousel-heading">
                        <b v-if="item.title">{{item.title}}</b>
                        <b v-else>タイトル</b>
                        <p v-if="item.text">{{item.text}}</p>
                        <b v-else class="carousel-text"></b>
                      </div>
                      <div class="carousel-action" v-for="(action, indexAction) in item.actions" :key="indexAction">
                        <div class="carousel-action-label" v-if="action.label">
                          {{action.label}}
                        </div>
                        <div  class="carousel-action-label carousel-action-label-default" v-else >
                          選択肢: {{indexAction+1}}
                        </div>
                      </div>
                    </div>
                  </div>
                </div>
                <div class="carousel-add-btn" @click="addMoreColumn(null)" v-if="defaults.columns.length < 10">
                  <i class="glyphicon glyphicon-plus-sign"></i>
                  <span class="count-carousel">({{defaults.columns.length}} / 10)</span>
                </div>
              </div>
            </div>
            <div v-for="(column, indexColumn) in defaults.columns" :key="indexColumn"  v-show="indexColumn === selected" >
              <div class="carousel-group-action">
                <h4>{{selected + 1}}枚目</h4>
                <div class="col-sm-5 p-0">
                  <div class="form-group">
                    <label>タイトル <span class="label label-danger" v-if="requiredTitle">必須</span></label>
                    <input type="text" :name="'carousel-title'+indexColumn" placeholder="タイトル" class="form-control" v-model="column.title" maxlength='40' v-validate="{required: requiredTitle}">
                    <span v-if="errors.first('carousel-title'+indexColumn)" class="is-validate-label">タイトルは必須です</span>
                  </div>
                  <div class="form-group">
                    <label>本文</label><span class="label label-danger">必須</span>
                    <textarea  :name="'carousel-text'+indexColumn" placeholder="本文を入力してください" class="form-control" v-model="column.text" maxlength='60' v-validate="'required'"> </textarea>
                    <span v-if="errors.first('carousel-text'+indexColumn)" class="is-validate-label">本文は必須です</span>
                  </div>
                </div>
                <div class="col-sm-7">
                  <div class="form-group">
                    <label>画像</label>
                    <div class="">
                      <div class="col-sm-6">
                        <div class="group-button-thumb">
                          <div class="btn btn-info btn-block uploadfile-thumb"  data-toggle="modal" :data-target="'#imageModalCenter'+ indexParent">
                            <i class="glyphicon glyphicon-picture"></i>
                            画像選択
                            <!-- <input type="file"  ref="thumb" accept="image/*" @change="uploadThumb"/> -->
                          </div>
                          <div class="btn btn-default btn-sm" @click="removeCurrentThumb" v-if="column.thumbnailImageUrl">
                            このパネルの画像を削除
                          </div>
                          <div class="btn btn-info btn-sm" @click="coppyAllThumb" v-if="column.thumbnailImageUrl">
                            全パネルにこの画像をコピー
                          </div>
                          <div class="btn btn-default btn-sm" @click="removeAllThumb" v-if="column.thumbnailImageUrl">
                            全パネルの画像を削除
                          </div>
                        </div>
                      </div>
                      <div class="col-sm-6" >
                        <img v-if="column.thumbnailImageUrl" :src="column.thumbnailImageUrl" class="image-carousel-thumb" >
                        <span v-if="errorMessageUploadFile" class="label error-message-upload">{{errorMessageUploadFile}}</span>
                      </div>
                    </div>
                  </div>
                </div>
                <div class="col-sm-12 p-0">
                  <div class="form-group" >
                    <h5><label>ボタン{{selected + 1}}</label></h5>
                      <div v-for="(item, index) in column.actions"
                        :key="index" @click="changeActiveAction(index)"
                        :class="selectedAction === index ? 'panel action-panel panel-default pb20 active': 'panel action-panel panel-default pb20'" >
                        <div class="panel-body">
                          <div class="col-sm-9">
                            <label class="mt20">
                              選択後の挙動 : {{index+1}}
                            </label>
                            <message-action-type
                              :name="index+ '_template_carousel_'+ indexColumn"
                              :value="item"
                              @input="changeActionColumn(indexColumn, index, ...arguments)"
                            />
                          </div>
                          <div class="col-sm-3 panel-tool" style="">
                            <div class="btn-group btn-group-justified mt20">
                              <div class="btn-group" @click.stop="moveTopAction(index)"><button type="button" class="btn btn-default"><i class="glyphicon glyphicon-arrow-up"></i></button></div>
                              <div class="btn-group" @click.stop="moveBottomAction(index)"><button type="button" class="btn btn-default"><i class="glyphicon glyphicon-arrow-down"></i></button></div>
                              <div class="btn-group" @click.stop="copyCurrentAction(index)"><button type="button" class="btn btn-default"><i class="fas fa-copy"></i></button></div>
                              <div class="btn-group" v-if="column.actions.length > 1" @click.stop="removeCurrentAction(index)"><button type="button" class="btn btn-default"><i class="glyphicon glyphicon-remove"></i></button></div>
                            </div>
                          </div>
                        </div>
                      </div>
                  </div>
                </div>
                <div class="col-sm-12" v-if="column.actions.length < 3">
                  <div class="col-sm-1"></div>
                  <div class="col-sm-10">
                    <span  class="btn btn-sm btn-default btn-block btn-carousel-button-add" @click="addMoreAction">
                      <i class="glyphicon glyphicon-plus"></i>
                      追加 ({{column.actions.length}}/ 3)
                    </span>
                  </div>
                  <div class="col-sm-1"></div>
                </div>
              </div>
            </div>
          </div>
        </div>
      </div>
    </div>
    <media-modal @input="uploadThumb" :data="{type: 'image'}" :id="'imageModalCenter'+indexParent"/>
  </div>
</template>
<script>

export default {
  props: ['data', 'indexParent'],
  inject: ['parentValidator'],
  data() {
    return {
      requiredTitle: false,
      selected: 0,
      selectedAction: 0,
      errorMessageUploadFile: '',
      isThumbnail: false,
      defaults: {
        type: this.TemplateMessageType.Carousel,
        columns: [
          {
            thumbnailImageUrl: '',
            title: '',
            text: '',
            actions: [
              this.ActionMessage.default
            ]
          }
        ]
      }
    };
  },

  created() {
    this.$validator = this.parentValidator;
    if (this.data) {
      Object.assign(this.defaults, this.data);
      this.$emit('input', this.defaults);
    }
  },
  watch: {
    defaults: {
      handler(val) {
        // eslint-disable-next-line no-undef
        const value = _.cloneDeep(val);
        this.isThumbnail = value.columns.find(item => item.thumbnailImageUrl !== '');
        if (!this.isThumbnail) {
          value.columns.forEach(item => {
            delete item.thumbnailImageUrl;
          });
        }

        this.requiredTitle = !!val.columns.find(item => item.title);

        this.$emit('input', value);
      },
      deep: true
    }
  },
  methods: {
    addMoreColumn(index) {
      if (this.defaults.columns.length > 9) return;
      const option = {
        thumbnailImageUrl: '',
        title: '',
        text: '',
        actions: []
      };

      this.defaults.columns[0].actions.forEach(item => {
        option.actions.push({ ...this.ActionMessage.default, label: '' });
      });

      if (index !== null) {
        this.defaults.columns.splice(index + 1, 0, option);
        this.selected = index + 1;
      } else {
        this.defaults.columns.push(option);
        this.selected = this.defaults.columns.length - 1;
      }
    },

    removeColumn(index) {
      this.defaults.columns.splice(index, 1);

      if (this.selected === this.defaults.columns.length) {
        this.selected -= 1;
      }
    },

    copyColumn(index, column) {
      if (this.defaults.columns.length > 9) return;
      // eslint-disable-next-line no-undef
      this.defaults.columns.splice(index + 1, 0, _.cloneDeep(column));
    },

    moveRightColumn(index) {
      const option = this.defaults.columns[index];
      if (this.defaults.columns[index + 1]) {
        this.defaults.columns[index] = this.defaults.columns.splice(index + 1, 1, option)[0];
        if (this.selected === index) {
          this.selected += 1;
        }
      }
    },

    moveLeftColumn(index) {
      const option = this.defaults.columns[index];
      if (this.defaults.columns[index - 1]) {
        this.defaults.columns[index] = this.defaults.columns.splice(index - 1, 1, option)[0];

        if (this.selected === index) {
          this.selected -= 1;
        }
      }
    },

    changeSelected(index) {
      this.selected = index;
    },

    uploadThumb(value) {
      this.defaults.columns[this.selected].thumbnailImageUrl = value.originalContentUrl;
      this.$emit('input', this.defaults);

      this.isThumbnail = true;
    },

    removeCurrentThumb() {
      this.defaults.columns[this.selected].thumbnailImageUrl = '';
      this.$emit('input', this.defaults);
    },

    coppyAllThumb() {
      this.defaults.columns.forEach(item => { item.thumbnailImageUrl = this.defaults.columns[this.selected].thumbnailImageUrl; });
    },

    removeAllThumb() {
      this.defaults.columns.forEach(item => { item.thumbnailImageUrl = ''; });
    },

    changeSelectedAction(index, value) {
      this.defaults.columns[this.selected].actions.splice(index, 1, value);
    },

    changeActionColumn(indexColumn, index, data) {
      this.defaults.columns[indexColumn].actions.splice(index, 1, data);
    },

    moveTopAction(index) {
      const option = this.defaults.columns[this.selected].actions[index];
      if (this.defaults.columns[this.selected].actions[index - 1]) {
        this.defaults.columns[this.selected].actions[index] = this.defaults.columns[this.selected].actions.splice(index - 1, 1, option)[0];

        if (this.selectedAction === index) {
          this.selectedAction -= 1;
        }
      }
    },

    moveBottomAction(index) {
      const option = this.defaults.columns[this.selected].actions[index];
      if (this.defaults.columns[this.selected].actions[index + 1]) {
        this.defaults.columns[this.selected].actions[index] = this.defaults.columns[this.selected].actions.splice(index + 1, 1, option)[0];
        if (this.selectedAction === index) {
          this.selectedAction += 1;
        }
      }
    },

    copyCurrentAction(index) {
      if (this.defaults.columns[this.selected].actions.length < 3) {
        this.defaults.columns.forEach((item) => {
          // eslint-disable-next-line no-undef
          item.actions.splice(index + 1, 0, _.cloneDeep(item.actions[index]));
        });
      }
    },

    removeCurrentAction(index) {
      this.defaults.columns.forEach((item) => {
        item.actions.splice(index, 1);
      });

      if (this.selectedAction === this.defaults.columns[this.selected].actions.length) {
        this.selectedAction -= 1;
      }
    },

    addMoreAction() {
      this.defaults.columns.forEach((item) => {
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
.error-message-upload {
  color: #bf5329;
  white-space: pre-line;
}

.template-carousel{
  padding: 15px 0;
  margin: 0px!important;
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

.carousel-body{
  background: #f1f1f1;
  overflow-y: hidden;
  margin: 0 0px;
  position: relative;
  padding: 5px;
  margin-bottom: 15px;
}

.carousel-group-action{
  padding: 15px;
}

.list-carousel{
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
  background-color: rgba(255,255,255,0.8);
  cursor: pointer;
  display: flex;
  flex-direction: column;
  align-items: center;
  .count-carousel{
    font-size: 20px;
  }

  .glyphicon-plus-sign{
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
        .glyphicon{
         font-size: 14px;
        }
      }

      .action-item:first-child {
        border-left-color: transparent;
      }
    }
  }

  .carousel-content{
    border: 1px solid #aaa;
    border-radius: 4px;
    background-color: white;
    cursor: pointer;

    .carousel-heading{
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

      .carousel-text{
        // font-weight: bold;
        // color: red;
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
  input[type=file] {
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
  .carousel-content{
    box-shadow: 0 0 2px 2px rgba(91,192,222,0.6);
    border-color: #5bc0de;
  }
}
// Action panel
.action-panel.active {
    box-shadow: 0 0 2px 2px rgba(91,192,222,0.6);
    border-color: #5bc0de;
}

.btn-group{
  .btn{
    padding-left: 0px;
    padding-right: 0px;
  }
}
</style>
