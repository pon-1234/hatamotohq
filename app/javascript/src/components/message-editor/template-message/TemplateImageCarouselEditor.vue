<template>
  <div class="row">
    <div class="col-md-12">
      <div class="panel panel-default pb20 mb-0">
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

        <div class="panel-body">
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
                      <div class="carousel-content" @click="changeSelected(index)">
                        <div class="carousel-thumb" :style="{ backgroundImage: 'url(' + item.imageUrl + ')'}" v-if="item.imageUrl"></div>
                        <div v-if="!item.imageUrl" class="carousel-thumb" :class="errors.first('image-url-'+ index)?'invalid-box':'' ">(画像未登録)</div>
                        <input type="hidden" v-model="item.imageUrl" :name="'image-url-'+index" v-validate="'required'" />
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
          <div class="carousel-group-action row" v-for="(column, indexColum) in defaults.columns" v-show="selected === indexColum" :key="indexColum">
            <div class="col-sm-8">
              <div class="form-group" >
                <label>選択後の挙動</label>
                <message-action-type
                  :name="'image_carousel' + indexColum"
                  :value="column.action"
                  @input="changeActionColumn(indexColum, $event)"
                    :labelRequired="false"
                />
              </div>
            </div>
            <div class="col-sm-4">
              <div class="group-button-thumb form-group">
                <label>画像<required-mark></required-mark></label>
                <div class="btn btn-info btn-block uploadfile-thumb" data-toggle="modal" :data-target="'#modalSelectMedia'+ indexParent">
                  <i class="glyphicon glyphicon-picture"></i>
                  画像選択
                  <!-- <input type="file"  ref="thumb" accept="image/*" @change="uploadThumb"/> -->
                </div>
                <div class="btn btn-default btn-sm" @click="removeCurrentThumb(indexColum)" v-if="column.imageUrl">
                  このパネルの画像を削除
                </div>
                <div class="btn btn-info btn-sm" @click="coppyAllThumb(indexColum)" v-if="column.imageUrl">
                  全パネルにこの画像をコピー
                </div>
                <div class="btn btn-default btn-sm" @click="removeAllThumb" v-if="column.imageUrl">
                  全パネルの画像を削除
                </div>
                <!-- error message if no image is selected -->
                <input type="hidden" v-model="column.imageUrl" :name="'image-url-'+indexColum" v-validate="'required'" data-vv-as="パネル画像"/>
                <template v-if="errors.first('image-url-'+ indexColum)">
                  <error-message message="パネルの画像は必須項目です"></error-message>
                </template>
                <!-- image preview -->
                <div class="form-group text-center">
                  <img v-if="column.imageUrl" :src="column.imageUrl" class="mw-250" >
                  <span v-if="errorMessageUploadFile" class="label error-message-upload">{{errorMessageUploadFile}}</span>
                </div>
              </div>
            </div>
          </div>
        </div>
      </div>
    </div>
    <modal-select-media @input="uploadThumb" :data="{type: 'image'}" :id="'modalSelectMedia'+indexParent"/>
  </div>
</template>
<script>

import { ActionMessage } from '../../../core/constant';

export default {
  props: ['data', 'indexParent'],
  inject: ['parentValidator'],
  data() {
    return {
      selected: 0,
      errorMessageUploadFile: '',
      defaults: {
        type: this.TemplateMessageType.ImageCarousel,
        columns: [
          {
            imageUrl: '',
            action: ActionMessage.default
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
        this.$emit('input', value);
      },
      deep: true
    }
  },
  methods: {
    addMoreColumn(index) {
      if (this.defaults.columns.length > 9) return;
      const option = {
        imageUrl: '',
        action: ActionMessage.default
      };

      this.defaults.columns.push(option);
      this.selected = this.defaults.columns.length - 1;
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

    async uploadThumb(value) {
      this.defaults.columns[this.selected].imageUrl = value.originalContentUrl;
      this.$emit('input', this.defaults);
    },

    removeCurrentThumb(index) {
      this.defaults.columns[index].imageUrl = '';
      this.$emit('input', this.defaults);
    },

    coppyAllThumb(index) {
      this.defaults.columns.forEach(item => { item.imageUrl = this.defaults.columns[index].imageUrl; });
    },

    removeAllThumb() {
      this.defaults.columns.forEach(item => { item.imageUrl = ''; });
    },

    changeSelectedAction(value) {
      this.defaults.columns[this.selected].action = value;
    },

    changeActionColumn(index, data) {
      console.log('changeActionColumn', index);
      this.defaults.columns[index].action = data;
    }

  }

};
</script>

<style lang="scss" scoped>
  .template-carousel{
    padding: 15px 0;
    margin: 0px!important;
  }

  .panel-heading {
    padding: 5px 10px;
    background-color: #ccc;
  }

  .panel-body {
    padding: 0px!important;
  }

  .carousel-body{
    background: #f1f1f1;
    overflow-y: hidden;
    margin: 0 0px;
    position: relative;
    padding: 5px;
    margin-bottom: 15px;
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
    width: 210px;
    display: inline-block;
    .carousel-header {
      .carousel-header-title {
        font-size: 14px;
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
      width: 200px;

      .carousel-thumb {
        height: 200px;
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

    .btn-info {
      color: white;
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

  .active {
    .carousel-content{
      box-shadow: 0 0 2px 2px rgba(91,192,222,0.6);
      border-color: #5bc0de;
    }
  }

  .carousel-group-action{
    padding: 15px;
  }

  // Panel tab
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
</style>
