<template>
  <div>
    <div>
      <div>
        <div class="alert alert-warning">
          パネルタイトルの有無・画像の有無・ボタンの数は全てのパネルで同じ必要があります。
        </div>

        <ul class="nav nav-tabs" role="tablist">
          <li role="presentation" v-for="(item, index) in defaults.columns" :key="index" :class="selected === index ? 'active' : ''" @click="changeSelected(index)">
            <a aria-controls="text" role="tab" data-toggle="tab" aria-expanded="true">
                パネル{{ index + 1}}
              <span @click="removeColumn(index)" v-if="defaults.columns.length > 1">
                <i class="fa fa-times"></i>
              </span>
            </a>
          </li>
          <li class="d-flex justify-content-center p-1" @click="addMoreColumn">
            <span>
              <i class="uil-plus"></i>追加
            </span>
          </li>
        </ul>
        <div class="carousel-body" hidden>
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
                <div class="carousel-content" @click="changeSelected(index)"  :class="errors.items.find(item=>item.field.includes('template_carousel_'+index))? 'invalid-box': ''">
                  <div class="carousel-thumb" :style="{ backgroundImage: 'url(' + item.thumbnailImageUrl + ')'}" v-if="item.thumbnailImageUrl" >
                  </div>
                  <div v-if="isThumbnail && 'thumbnailImageUrl' in item && !item.thumbnailImageUrl" class="carousel-thumb" :class="errors.first('image-url-'+ index)?'invalid-box':'' ">
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
          <div class="carousel-group-action row">
            <div class="col-sm-5 p-0">
              <div class="form-group">
                <label>パネル{{ selected + 1}}タイトル <required-mark></required-mark></label>
                <input type="text" :name="'carousel-title'+indexColumn" placeholder="タイトル" class="form-control" v-model="column.title" maxlength='40' v-validate="{required: requiredTitle}" data-vv-as="タイトル">
                <error-message :message="errors.first('carousel-title'+indexColumn)"></error-message>
              </div>
              <div class="form-group">
                <label>パネル{{ selected + 1}}本文</label><required-mark></required-mark>
                <textarea  :name="'carousel-text'+indexColumn" placeholder="本文を入力してください" class="form-control" v-model="column.text" maxlength='60' v-validate="'required'" data-vv-as="本文"> </textarea>
                <error-message :message="errors.first('carousel-text'+indexColumn)"></error-message>
              </div>
            </div>
            <div class="col-sm-7">
              <div class="form-group">
                <label>画像</label>
                <div class="row">
                  <div class="col-sm-6">
                    <div class="group-button-thumb">
                      <div class="btn btn-info btn-block btn-sm uploadfile-thumb"  data-toggle="modal" :data-target="'#uploadImageModal'+ indexParent">
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
            <div class="col-sm-12 p-0 row">
              <div class="col-sm-3">
              <ul class="nav nav-tabs nav-stacked nav-buttons d-block">
                <li v-for="(item, index) in column.actions" :key="index" :class="selectedAction == index? 'active': ''" @click="changeActiveAction(index)">
                  <div class="nav-button" :class="errors.items.find(item=>item.field.includes(indexParent + 'template_button_' + index)) ? 'invalid-box': ''">
                    ボタン{{index + 1}}
                    <span v-if="column.actions.length > 1" class="action-tab-selector-remover" @click.stop="removeCurrentAction(index)"><i class="fas fa-times"></i></span>
                  </div>
                </li>
                <li v-if="column.actions.length < 3">
                  <div class="nav-button btn justify-content-center" @click="addMoreAction">
                    <i class="uil-plus"></i> 追加
                  </div>
                </li>
              </ul>
              </div>
              <div class="col-sm-9">
                <div v-for="(item, index) in column.actions" :key="index" v-show="selectedAction === index" class="card card-light">
                  <div class="card-header d-flex flex-start align-items-center">
                    <h3 class="card-title">選択肢{{index+1}}</h3>
                    <div class="btn btn-secondary btn-sm ml-auto" @click.stop="copyCurrentAction(index)"><i class="fas fa-copy"></i></div>
                  </div>
                  <div class="card-body">
                    <div class="col-sm-12">
                      <message-action-type
                        :name="index+ '_template_carousel_'+ indexColumn"
                        :value="item"
                        @input="changeActionColumn(indexColumn, index, ...arguments)"
                      />
                    </div>
                  </div>
                </div>
              </div>

              <!-- <div class="form-group" >
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
              </div> -->
            </div>
          </div>
        </div>
      </div>
    </div>
    <modal-select-media @input="uploadThumb" :data="{type: 'image'}" :id="'uploadImageModal'+indexParent"/>
  </div>
</template>
<script>
import ErrorMessage from '../../common/ErrorMessage.vue';
import RequiredMark from '../../common/RequiredMark.vue';

export default {
  components: { RequiredMark, ErrorMessage },
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

        // this.requiredTitle = !!val.columns.find(item => item.title); // TODO: need to clear

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

      this.defaults.columns.push(option);
      this.selected = this.defaults.columns.length - 1;
      console.log('selected tab = ', this.selected);
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
      console.log('this.selected', this.selected);
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
  .nav-stacked>li {
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
      border-left: 3px solid #28a745;
      color: #28a745;
      font-weight: bold;
    }
  }

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
