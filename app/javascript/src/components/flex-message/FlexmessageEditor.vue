<template>
  <div>
    <div class="form-group">
      <label>代替テキスト<required-mark></required-mark></label>
      <input
        type="text"
        :name="`altText${index}`"
        class="form-control"
        placeholder="代替テキストを入力してください"
        v-model="altText"
        v-validate="'required|max:400'"
        data-vv-as="代替テキスト"
      />
      <error-message :message="errors.first(`altText${index}`)"></error-message>
    </div>
    <div class="d-flex flex-column" style="">
      <div class="form-group" v-show="htmlPreview !== null">
        <label>メッセージ通知文</label>
        <input
          type="text"
          name="altText"
          class="form-control alt-text-input"
          placeholder="メッセージ通知文を入力してください"
          v-validate="{ required: isValidate }"
          v-model="altText"
        />
      </div>
      <div class="flex-container">
        <div class="form-group flex-message preview" v-show="htmlPreview !== null">
          <div v-html="data.html_template"></div>
        </div>
        <div class="col-sm-6 form-group controls">
          <div
            v-for="item in mapObject"
            :key="item.id"
            class="group-action-flex-message"
            :class="item.id"
            @click="changeActive(item.id)"
          >
            <flexmessage-text-action v-if="item.type === 'text'" :data="item" :name="item.id" @input="editObject" />

            <flexmessage-button-action v-if="item.type === 'button'" :data="item" :name="item.id" @input="editObject" />

            <flexmessage-image-action
              v-if="item.type === 'image'"
              :data="item"
              :name="item.id"
              :aspectMode="aspectMode"
              @input="editObject"
            />

            <flexmessage-box-action v-if="item.type === 'box'" :data="item" :name="item.id" @input="editObject" />
          </div>
        </div>
      </div>
    </div>
  </div>
</template>

<script>
import { omitDeep } from '@/core/omitDeep';
import Util from '@/core/util';
import RequiredMark from '../common/RequiredMark.vue';

export default {
  components: { RequiredMark },
  props: {
    data: Object,
    isValidate: Boolean
  },
  inject: ['parentValidator'],
  data() {
    return {
      altText: '',
      mapObject: {},
      currentEditor: null,
      htmlPreview: null,
      jsonPreview: null,
      aspectMode: 'cover',
      passedObject: {}
    };
  },

  watch: {
    data() {
      this.$nextTick(async() => {
        this.setup();
      });
    }
  },

  created() {
    this.$validator = this.parentValidator;
  },

  mounted() {
    this.setup();
  },

  methods: {
    setup() {
      if (this.data && this.data.json_template == null) return;
      this.currentEditor = null;
      this.htmlPreview = $('div.flex-message.preview');
      this.jsonPreview = JSON.parse(this.data.json_template);
      this.mapObject = {};
      this.detectObject(this.jsonPreview);
      this.makeActionHtml(this.htmlPreview);
      this.objectMapToJson(this.jsonPreview);
      console.log(this.mapObject);
    },

    detectObject(json) {
      if (json.contents) {
        this.detectObject(json.contents);
      }

      for (const value of Object.values(json)) {
        if (value && value.type != null && value.id != null) {
          if (value.type === 'bubble') {
            this.detectObject(value);
            // this.detectObject(value.body);
          } else if (value.type === 'text' && value.editable != null) {
            this.$set(this.mapObject, value.id, {
              id: value.id,
              type: value.type,
              text: value.text,
              size: value.size,
              action: value.action
            });
          } else if (value.type === 'box') {
            if (value.editable != null) {
              this.mapObject[value.id] = {
                id: value.id,
                type: value.type,
                action: value.action
              };
            }
            this.detectObject(value);
          } else if (value.type === 'image' && value.editable != null) {
            this.mapObject[value.id] = {
              id: value.id,
              type: value.type,
              url: value.url,
              action: value.action
            };
          } else if (value.type === 'button' && value.editable != null) {
            this.mapObject[value.id] = {
              id: value.id,
              type: value.type,
              action: value.action
            };
          }
        }
      }
    },

    makeActionHtml($html) {
      const that = this;
      for (const key of Object.keys(this.mapObject)) {
        const $div = $html.find('#' + key);
        $div.addClass('flex-editor');
        $div.click(ev => {
          that.chooseObject(key);
          ev.stopPropagation();
        });
      }
    },

    chooseObject(id) {
      this.currentEditor = this.mapObject[id];

      this.$nextTick(async() => {
        this.$validator.validateAll().then(passed => {
          const isError = this.errors.items.find(item => item.field.includes(id));
          if (isError) {
            this.passedObject[id] = false;
            this.htmlPreview.find('div#' + id).addClass('flex-error');
          } else {
            this.passedObject[id] = true;
            this.htmlPreview.find('div#' + id).removeClass('flex-error');
          }
          this.emitObject();
        });
      });

      this.htmlPreview.find('.flex-editor-active').removeClass('flex-editor-active');
      $('.form-group')
        .find('.active-flex-el')
        .removeClass('active-flex-el');

      const className = '.' + id;
      $('.card-container')
        .parent()
        .removeClass('active');
      $(className + '-expand')
        .parent()
        .addClass('active');

      $('html,body').animate({ scrollTop: $(className).offset().top - 100 }, 'slow');
      this.htmlPreview.find('div#' + id).addClass('flex-editor-active');
      $(className).addClass('active-flex-el');

      const style = this.htmlPreview
        .find('div#' + id)
        .find('span')
        .css('background-size');
      this.aspectMode = style;
    },

    editObject(value) {
      this.objectMapToJson(this.jsonPreview);

      // view update
      if (value.type === 'text') {
        this.FontSizeClass.forEach(item => {
          this.htmlPreview.find('div#' + value.id).removeClass('Ex' + item);
        });
        this.htmlPreview.find('div#' + value.id).removeAttr('style');
        if (value.size.match(Util.regexFontSizeUsingPx())) {
          this.htmlPreview.find('div#' + value.id).css('font-size', value.size);
        } else if (value.size.match(Util.regexFontSizeUsingWord())) {
          const sizeClass =
            value.size.slice(0, value.size.length - 1).toUpperCase() + value.size.slice(-1).toLowerCase();
          this.htmlPreview.find('div#' + value.id).addClass('Ex' + sizeClass);
        }
        this.htmlPreview.find('div#' + value.id + ' p').text(value.text);
      } else if (value.type === 'button') {
        this.htmlPreview.find('div#' + value.id + ' a>div').text(value.action.label);
      } else if (value.type === 'image') {
        this.htmlPreview.find('div#' + value.id + ' div>a>span').css('background-image', "url('" + value.url + "')");
        if (value.aspectMode === 'cover') {
          this.htmlPreview.find('div#' + value.id + ' div>a>span').css('background-size', 'cover');
        } else {
          this.htmlPreview.find('div#' + value.id + ' div>a>span').css('background-size', 'contain');
        }
      }

      // validate
      this.$nextTick(async() => {
        this.$validator.validateAll().then(passed => {
          const isError = this.errors.items.find(item => item.field.includes(value.id));
          if (isError) {
            this.passedObject[value.id] = false;
            this.htmlPreview.find('div#' + value.id).addClass('flex-error');
          } else {
            this.passedObject[value.id] = true;
            this.htmlPreview.find('div#' + value.id).removeClass('flex-error');
          }

          this.emitObject();
        });
      });
    },

    objectMapToJson(json) {
      for (const value of Object.values(json)) {
        if (Array.isArray(value)) {
          for (let i = 0; i < value.length; i++) {
            this.objectMapToJson(value[i]);
          }
        } else if (value.id) {
          if (value.type === 'text' && value.editable != null) {
            const objectMap = this.mapObject[value.id];
            value.text = objectMap.text;
            if (objectMap.size) {
              value.size = objectMap.size;
            }
            if (objectMap.action && objectMap.action.type !== 'none') {
              value.action = objectMap.action;
            } else {
              delete value.action;
            }
          } else if (value.type === 'box') {
            if (value.editable != null) {
              const objectMap = this.mapObject[value.id];

              if (objectMap.action && objectMap.action.type !== 'none') {
                value.action = objectMap.action;
              } else {
                delete value.action;
              }
            }
            // map treeObject
            if (value.contents) {
              this.objectMapToJson(value.contents);
            }
          } else if (value.type === 'image' && value.editable != null) {
            const objectMap = this.mapObject[value.id];
            value.url = objectMap.url;
            if (objectMap.action && objectMap.action.type !== 'none') {
              value.action = objectMap.action;
            } else {
              delete value.action;
            }

            if (objectMap.aspectMode) {
              value.aspectMode = objectMap.aspectMode;
            }
          } else if (value.type === 'button' && value.editable != null) {
            const objectMap = this.mapObject[value.id];
            if (objectMap.action && objectMap.action.type !== 'none') {
              value.action = objectMap.action;
            } else {
              delete value.action;
            }
          }
        }
      }
    },

    emitObject() {
      console.log('emitObject', this.jsonPreview);
      this.$emit('input', {
        altText: this.altText,
        passedObject: this.passedObject,
        html_template: this.htmlPreview.html(),
        json_template: JSON.stringify(this.jsonPreview),
        json_message: JSON.stringify(omitDeep(this.jsonPreview, 'editable', 'linkUri', 'id'))
      });
    },

    changeActive(id) {
      this.htmlPreview.find('.flex-editor-active').removeClass('flex-editor-active');
      $('.form-group')
        .find('.active-flex-el')
        .removeClass('active-flex-el');

      const className = '.' + id;
      this.htmlPreview.find('div#' + id).addClass('flex-editor-active');
      $(className).addClass('active-flex-el');
      const style = this.htmlPreview
        .find('div#' + id)
        .find('span')
        .css('background-size');
      this.aspectMode = style;
    }
  }
};
</script>

<style lang="scss" scoped>
  ::v-deep {
    .flex-error {
      border: 1px solid red !important;
    }
    .flex-editor {
      border: 1px solid transparent;
    }

    .flex-editor:hover {
      border: 1px solid #0a90eb;
    }
    .flex-editor-active {
      border-color: #0a90eb;
    }

    .preview *::-webkit-scrollbar {
      display: inherit !important;
      color: inherit;

      height: 8px;
      margin-top: 2px;
    }
    .preview ::-webkit-scrollbar-thumb {
      /* leave most bars alone */
      background-color: grey;
      border-radius: 6px;
    }
  }

  .preview {
    padding: 20px;
    min-width: 350px;
    max-width: 500px;
    flex: 1;
    background: #ededed;
    display: flex;
  }

  .preview > div {
    margin: 10px auto;
    width: 100%;
    justify-content: center;
  }

  .controls {
    max-width: 500px;
  }

  .flex-container {
    display: flex;
    /*justify-content: center;*/
  }

  @media (max-width: 799px) {
    .preview {
      max-width: initial;
    }
    .col-sm-6 {
      padding: 0;
    }
    .controls {
      max-width: 100%;
      width: 100%;
    }
    .flex-container {
      flex-direction: column;
    }
  }

  .group-action-flex-message {
    border: thin solid #ccd0d2;
    padding: 10px;
    margin-bottom: 20px;
  }

  .active-flex-el {
    border-color: 2px solid #5bc0de;
    box-shadow: 0 0 2px 2px rgba(91, 192, 222, 0.6);
  }

  .alt-text-input {
    max-width: 985px;
  }
</style>
