<template>
  <div>
    <div class="d-flex-sm align-items-center mt-4 mb-3">
      <h3 class="w-fix-260 mb-0">内容</h3>
    </div>
    <div class="d-flex-sm" style="justify-content: center">
      <div class="w-fix-260">
        <input type="text" v-model="background" :name="'image-url'" v-validate="'required'"
               style="width: 0px; height: 0px; border: none;"/>
        <rich-menu-preview
          :background="background"
          :template-id="templateId"
          :typeTemplate="typeTemplate"
          :class="errors.first('image-url') ? 'is-validate' : ''"
          @click="expandAction">
        </rich-menu-preview>
        <div class="my-2">
          <span v-if="errors.first('image-url')" class="is-validate-label">背景画像は必須です</span>
          <button type="button" class="btn-block btn btn-secondary"
                  data-toggle="modal" data-target="#modalRichmenuTemplateChoose">
            テンプレートを選択
          </button>
        </div>
        <div class="my-2">
          <button type="button" class="btn-block btn btn-secondary"
                  data-toggle="modal" data-target="#imageModalCenter">
            背景画像をアップロード
          </button>
        </div>
        <div class="my-2">
          <button type="button" class="btn-block btn btn-secondary"
                  @click="showEditor()">
            一式の個別画像を編集
          </button>
        </div>
        <span class="invalid-feedback d-block" style="display: none;"></span></div>
      <div class="flex-1 ml-4 w-max-800">
        <div>
          <div data-vv-name="atLestLink" class="d-flex-sm justify-content-between align-items-center mb-3"
               aria-required="false" aria-invalid="true">
            <h4 class="mb-0">アクション</h4>

          </div>
          <div class="invalid-feedback d-block" style="display: none;"></div>
          <div id="accordion">
            <div v-for="(item, index) in actionObjects" v-bind:key="index">
              <div class="card mb-2"
                   :class="errors.items.find(item=>item.field.includes('richmenu_type_'+index)) ? 'is-validate': '' ">
                <div class="p-2" @click="expandAction(item.key, false, index)">
                  <h5 class="m-0">
                    <button type="button"
                            class="btn-block btn-link text-left btn btn-outline-block">
                      <i class="fas mr-2 fa-angle-right" style="width: 20px"
                         v-if="!item.expand && !errors.items.find(item=>item.field.includes('richmenu_type_'+index))"></i>
                      <i class="fas mr-2 fa-angle-down" style="width: 20px" v-else></i>{{item.key}}
                    </button>
                  </h5>
                </div>
                <div v-show="item.expand || errors.items.find(item=>item.field.includes('richmenu_type_'+index))">
                  <div>
                    <div class="card-body pt-0 accordion-0 center">
                      <div>
                        <message-action-type
                          class="kv-select form-group"
                          :name="'richmenu_type_'+index"
                          :value="item.action"
                          :supports="['', 'postback', 'uri', 'message', 'datetimepicker', 'survey']"
                          :labelRequired="false"
                          :showTitle="false"
                          @input="item.action = $event"
                        >
                        </message-action-type>

                      </div>
                    </div>
                  </div>
                </div>
              </div>
            </div>
          </div>
        </div>
      </div>
    </div>

    <rich-menu-modal-editor-image
      v-if="isShowEditor"
      :templateId="templateId"
      @close="isShowEditor = false"
      @input="exportImage"
    ></rich-menu-modal-editor-image>
  </div>
</template>

<script>
import { mapActions } from 'vuex';

export default {
  props: {
    templateId: {
      type: Number,
      default: 201
    },
    templateValue: Number,
    background: String,
    areas: {
      type: Array,
      default: () => []
    },
    typeTemplate: {
      type: String,
      default: 'large'
    }
  },
  data() {
    return {
      isShowEditor: false,
      alphabet: 'ABCDEFGHIJKLMNOPQRSTUVWXYZ',
      actionObjects: this.areas
    };
  },

  inject: ['parentValidator'],
  created() {
    this.$validator = this.parentValidator;
  },

  watch: {
    templateValue(val, old) {
      if (old < val) {
        for (let i = old; i < val; i++) {
          this.actionObjects.push({
            key: this.alphabet.charAt(i),
            expand: false,
            action: this.ActionMessage.default,
            bounds: this.RichMenuBounds[this.templateId][i]
          });
        }
      } else if (old > val) {
        this.actionObjects.splice(val, old - val);
      }
    },
    templateId(val) {
      this.actionObjects.forEach((action, index) => {
        action.bounds = this.RichMenuBounds[val][index];
      });
    },
    actionObjects: {
      handler(val) {
        this.$emit('input', val);
      },
      deep: true
    }
  },

  beforeMount() {
    const old = this.actionObjects.length;
    const val = this.templateValue;

    if (old < val) {
      for (let i = old; i < val; i++) {
        this.actionObjects.push({
          key: this.alphabet.charAt(i),
          expand: false,
          action: this.ActionMessage.default,
          bounds: this.RichMenuBounds[this.templateId][i]
        });
      }
    } else if (old > val) {
      this.actionObjects.splice(val, old - val);
    }
  },

  methods: {
    ...mapActions('global', ['uploadImageForRichMenu']),

    expandAction(key, isAutoCollapse = true, index) {
      const field = this.errors.items.find(item => item.field.includes('richmenu_type_' + index));
      if (field && field.field) {
        this.errors.remove(field.field);
      }
      // field.remove();
      if (isAutoCollapse) {
        this.actionObjects.forEach((value, index) => {
          if (key === value.key) {
            this.$set(this.actionObjects[index], 'expand', true);
          } else {
            this.$set(this.actionObjects[index], 'expand', false);
          }
        });
      } else {
        const index = this.actionObjects.findIndex((val) => val.key === key);
        this.$set(this.actionObjects[index], 'expand', !this.actionObjects[index].expand);
      }
    },

    changeObjectAction(key, value) {
      this.actionObjects[key] = value;
    },
    showEditor() {
      this.isShowEditor = true;
    },
    exportImage(data) {
      // remove header
      data = data.replace('data:image/jpeg;base64,', '');
      // upload image
      this.uploadImageForRichMenu({
        file: this.b64toBlob(data)
      }).then((res) => {
        this.$emit('backgroundAliasChange', res);
      }).catch((err) => {
        console.log(err);
      });
    },

    b64toBlob(b64Data, contentType = 'image/jpeg', sliceSize = 512) {
      const byteCharacters = atob(b64Data);
      const byteArrays = [];

      for (let offset = 0; offset < byteCharacters.length; offset += sliceSize) {
        const slice = byteCharacters.slice(offset, offset + sliceSize);

        const byteNumbers = new Array(slice.length);
        for (let i = 0; i < slice.length; i++) {
          byteNumbers[i] = slice.charCodeAt(i);
        }

        const byteArray = new Uint8Array(byteNumbers);
        byteArrays.push(byteArray);
      }

      return new Blob(byteArrays, { type: contentType });
    }

  }
};
</script>

<style lang="scss" scoped>
  .btn {
    display: inline-block;
    font-weight: 400;
    text-align: center;
    vertical-align: middle;
    -webkit-user-select: none;
    -moz-user-select: none;
    -ms-user-select: none;
    user-select: none;
    /*border: 1px solid transparent;*/
    padding: 0.375rem 0.75rem;
    line-height: 1.5;
    border-radius: 2px;
    transition: color 0.15s ease-in-out, background-color 0.15s ease-in-out, border-color 0.15s ease-in-out, box-shadow 0.15s ease-in-out;
  }

  .card {
    position: relative;
    display: -webkit-box;
    display: flex;
    -webkit-box-orient: vertical;
    -webkit-box-direction: normal;
    flex-direction: column;
    min-width: 0;
    word-wrap: break-word;
    background-color: #fff;
    background-clip: border-box;
    border: 1px solid rgba(0, 0, 0, 0.125);
    border-radius: 4px;
    padding: 5px;
  }

  .card-body {
    -webkit-box-flex: 1;
    flex: 1 1 auto;
    padding: 1.25rem;
  }

  .col-form-label {
    padding-top: calc(0.375rem + 1px);
    padding-bottom: calc(0.375rem + 1px);
    margin-bottom: 0;
    font-size: inherit;
    line-height: 1.5;
  }

  .custom-select {
    display: inline-block;
    width: 100%;
    height: calc(2.15625rem + 2px);
    padding: 0.375rem 1.75rem 0.375rem 0.75rem;
    line-height: 1.5;
    color: #495057;
    vertical-align: middle;
    background: #ebf0fb;
    background-size: 8px 10px;
    border: 1px solid #cfd4da;
    border-radius: 4px !important;
    -webkit-appearance: none;
    -moz-appearance: none;
    appearance: none;
  }

  .kv-select {
    padding: 0px;
  }

  td {
    cursor: pointer;
  }

  table,
  table * {
    border-width: 2px !important;
  }
</style>
