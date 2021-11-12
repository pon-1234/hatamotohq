<template>
  <div>
    <div class="form-group">
      <label>代替テキスト</label>
      <input
        type="text"
        :name="`altText${index}`"
        class="form-control"
        placeholder="代替テキストを入力してください"
        v-model.trim="altText"
        maxlength="401"
        v-validate="'max:400'"
        data-vv-as="代替テキスト"
      />
      <error-message :message="errors.first(`altText${index}`)"></error-message>
    </div>

    <!--Editor-->
    <div class="d-flex">
      <div class="fw-260">
        <input
          type="text"
          v-model="backgroundUrl"
          :name="'image-url' + index"
          v-validate="'required'"
          data-vv-as="背景画像"
          class="d-none"
        />
        <imagemap-view
          :background="backgroundUrl"
          :template-id="templateId"
          :class="errors.first('image-url' + index) ? 'fh-260 invalid-box' : 'fh-260'"
          @click="expandAction"
        />
        <error-message :message="errors.first('image-url' + index)"></error-message>

        <button
          type="button"
          class="btn-block btn btn-secondary mt-2"
          data-toggle="modal"
          :data-target="`#imagemapTemplateSelectorModal${index}`"
        >
          テンプレートを選択
        </button>
        <button
          type="button"
          class="btn-block btn btn-secondary mt-2"
          data-toggle="modal"
          :data-target="`#imagemapModalUploadImage${index}`"
        >
          背景画像をアップロード
        </button>
        <button type="button" class="btn-block btn btn-secondary mt-2" @click="isShowingEditor = true">
          一式の個別画像を編集
        </button>
      </div>
      <div class="flex-grow-1 ml-4">
        <h5>アクション設定</h5>
        <div id="accordion">
          <div v-for="(item, index) in actionObjects" v-bind:key="index">
            <div
              class="card mb-2"
              :class="errors.items.find((item) => item.field.includes('imagemap_action_' + index)) ? 'invalid-box' : ''"
            >
              <div class="p-2" @click="expandAction(item.key, false, index)">
                <h5 class="m-0">
                  <button type="button" class="btn-block btn-link text-left btn btn-outline-block">
                    <i class="fas mr-2 mdi mdi-chevron-right" style="width: 20px" v-if="!item.expand"></i>
                    <i class="fas mr-2 mdi mdi-chevron-down" style="width: 20px" v-else></i>{{ item.key }}
                  </button>
                </h5>
              </div>
              <div v-show="item.expand">
                <div>
                  <div class="card-body pt-0 accordion-0 center">
                    <div>
                      <action-editor
                        :index="index"
                        :value="item.action"
                        :supports="['message', 'uri', 'survey']"
                        :labelRequired="false"
                        :showTitle="false"
                        :name="'imagemap_action_' + index"
                        @input="item.action = $event"
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

    <imagemap-template-selector
      :id="'imagemapTemplateSelectorModal' + index"
      :selectionId="templateId"
      @accept="templateChange"
    >
    </imagemap-template-selector>

    <modal-select-media
      @select="onSelectMedia"
      :types="['imagemap']"
      :filterable="false"
      :id="`imagemapModalUploadImage${index}`"
    >
    </modal-select-media>

    <modal-rich-menu-image-editor
      v-if="isShowingEditor"
      :templateId="templateId"
      editor="imagemap"
      @close="isShowingEditor = false"
      @input="exportImage"
    ></modal-rich-menu-image-editor>
  </div>
</template>

<script>
import { mapState, mapActions } from 'vuex';
import Util from '../../core/util';
import ErrorMessage from '../common/ErrorMessage.vue';

export default {
  components: { ErrorMessage },
  props: ['index', 'data'],
  data() {
    return {
      isShowingEditor: false,
      templateId: this.data.templateId,
      templateValue: this.data.templateValue,
      altText: this.data.altText,
      actionObjects: this.data.actions,
      backgroundUrl: this.data.baseUrl,
      alphabet: 'ABCDEFGHIJKLMNOPQRSTUVWXYZ'
    };
  },

  inject: ['parentValidator'],
  created() {
    this.$validator = this.parentValidator;
  },

  computed: {
    ...mapState('system', {
      isSubmitChange: state => state.isSubmitChange
    })
  },

  beforeMount() {
    const old = this.actionObjects.length;
    const val = this.templateValue;

    if (old < val) {
      for (let i = old; i < val; i++) {
        this.actionObjects.push({
          key: this.alphabet.charAt(i),
          expand: false,
          action: this.ActionMessageImageMap.default,
          area: this.ImageMapBounds[this.templateId][i]
        });
      }
    } else if (old > val) {
      this.actionObjects.splice(val, old - val);
    }
  },

  watch: {
    templateValue(val, old) {
      if (old < val) {
        for (let i = old; i < val; i++) {
          this.actionObjects.push({
            key: this.alphabet.charAt(i),
            expand: false,
            action: this.ActionMessageImageMap.default,
            area: this.ImageMapBounds[this.templateId][i]
          });
        }
      } else if (old > val) {
        this.actionObjects.splice(val, old - val);
      }
    },

    templateId(val) {
      this.actionObjects.forEach((action, index) => {
        action.area = this.ImageMapBounds[val][index];
      });
    },

    actionObjects: {
      handler(val) {
        this.publish(val);
      },
      deep: true
    },

    isSubmitChange: {
      handler(val) {
        for (const area of this.actionObjects) {
          if (Util.validateAction(area.action)) {
            area.expand = true;
          } else {
            area.expand = false;
          }
        }
      },
      deep: true
    }
  },

  methods: {
    ...mapActions('global', ['uploadImageMap']),
    firstWhere(array, cond) {
      for (const o of array) {
        if (cond(o)) {
          return o;
        }
      }

      return null;
    },

    expandAction(key, isAutoCollapse = true, index) {
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

    templateChange(data) {
      this.templateId = data.id;
      this.templateValue = data.value;
    },

    onSelectMedia(media) {
      this.backgroundUrl = media.url;
    },

    publish(actionObject) {
      const actions = actionObject.map((object) => {
        let objectNew = JSON.parse(JSON.stringify(object));
        objectNew = Object.assign(objectNew, objectNew.action);
        return objectNew;
      });

      const params = {
        type: 'imagemap',
        baseUrl: this.backgroundUrl,
        templateId: this.templateId,
        templateValue: this.templateValue,
        altText: this.altText,
        baseSize: {
          width: 1040,
          height: 1040
        },
        actions: actions
      };

      this.$emit('input', params);
    },
    exportImage(data) {
      // remove header
      data = data.replace('data:image/jpeg;base64,', '');
      // upload image
      this.uploadImageMap({
        file: this.b64toBlob(data)
      }).then((res) => {
        this.backgroundUrl = res.url;
        this.publish(this.actionObjects);
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
  .imagemap {
    border: 1px solid #ededed;
    padding: 5px;
    box-sizing: padding-box;
  }

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

  td {
    cursor: pointer;
  }

  table,
  table * {
    border-width: 2px !important;
  }
</style>
