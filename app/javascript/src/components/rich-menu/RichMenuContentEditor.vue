<template>
  <div>
    <div class="d-flex" style="justify-content: center">
      <div class="fw-260">
        <input
          type="text"
          v-model="background"
          :name="'image-url'"
          v-validate="'required'"
          class="d-none"
          data-vv-as="背景画像"
        />
        <rich-menu-preview
          :background="background"
          :template-id="templateId"
          :typeTemplate="typeTemplate"
          :class="errors.first('image-url') ? 'invalid-box' : ''"
          @click="expandAction"
        >
        </rich-menu-preview>
        <error-message :message="errors.first('image-url')"></error-message>
        <div class="my-2">
          <button
            type="button"
            class="btn-block btn btn-secondary"
            data-toggle="modal"
            data-target="#modalRichMenuTemplateSelection"
          >
            テンプレートを選択
          </button>
        </div>
        <div class="my-2">
          <button type="button" class="btn-block btn btn-secondary" data-toggle="modal" data-target="#modalSelectMedia">
            背景画像をアップロード
          </button>
        </div>
        <div class="my-2">
          <button type="button" class="btn-block btn btn-secondary" @click="isShowingEditor = true">
            一式の個別画像を編集
          </button>
        </div>
        <span class="invalid-feedback d-block" style="display: none"></span>
      </div>
      <div class="flex-grow-1 ml-4 mxw-800">
        <h5>アクション設定</h5>
        <div>
          <div class="invalid-feedback d-block" style="display: none"></div>
          <div id="accordion">
            <div v-for="(item, index) in actionObjects" v-bind:key="index">
              <div
                class="card mb-2"
                :class="errors.items.find((item) => item.field.includes('richmenu_type_' + index)) ? 'invalid-box' : ''"
              >
                <div class="p-2" @click="expandAction(item.key, false, index)">
                  <h5 class="m-0">
                    <button type="button" class="btn-block btn-link text-left btn btn-outline-block">
                      <i
                        class="fas mr-2 mdi mdi-chevron-right"
                        style="width: 20px"
                        v-if="
                          !item.expand && !errors.items.find((item) => item.field.includes('richmenu_type_' + index))
                        "
                      ></i>
                      <i class="fas mr-2 mdi mdi-chevron-down" style="width: 20px" v-else></i>{{ item.key }}
                    </button>
                  </h5>
                </div>
                <div v-show="item.expand || errors.items.find((item) => item.field.includes('richmenu_type_' + index))">
                  <div>
                    <div class="card-body pt-0 accordion-0 center">
                      <div>
                        <action-editor
                          class="form-group"
                          :name="'richmenu_type_' + index"
                          :value="item.action"
                          :supports="['', 'postback', 'uri', 'message', 'datetimepicker']"
                          :requiredLabel="false"
                          :showTitle="false"
                          @input="item.action = $event"
                        >
                        </action-editor>
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

    <modal-rich-menu-image-editor
      v-if="isShowingEditor"
      :templateId="templateId"
      @input="exportImage"
      @close="isShowingEditor = false"
    ></modal-rich-menu-image-editor>
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
    piecesCount: Number,
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
      isShowingEditor: false,
      alphabet: 'ABCDEFGHIJKLMNOPQRSTUVWXYZ',
      actionObjects: []
    };
  },

  inject: ['parentValidator'],
  created() {
    this.$validator = this.parentValidator;
    this.actionObjects = [...this.areas];
  },

  watch: {
    piecesCount(val, old) {
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
    const val = this.piecesCount;

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
    ...mapActions('global', ['uploadRichMenu']),

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
        const index = this.actionObjects.findIndex(val => val.key === key);
        this.$set(this.actionObjects[index], 'expand', !this.actionObjects[index].expand);
      }
    },

    changeObjectAction(key, value) {
      this.actionObjects[key] = value;
    },
    exportImage(data) {
      this.isShowingEditor = false;
      // remove header
      data = data.replace('data:image/jpeg;base64,', '');
      // upload image
      this.uploadRichMenu({
        file: this.b64toBlob(data)
      })
        .then(response => {
          this.$emit('onMediaChanged', response);
        })
        .catch(err => {
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
    transition: color 0.15s ease-in-out, background-color 0.15s ease-in-out, border-color 0.15s ease-in-out,
      box-shadow 0.15s ease-in-out;
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

  td {
    cursor: pointer;
  }

  table,
  table * {
    border-width: 2px !important;
  }
</style>
