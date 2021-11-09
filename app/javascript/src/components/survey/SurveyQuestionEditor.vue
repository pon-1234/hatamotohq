<template>
  <div class="mt-2" :key="contentKey">
    <div v-for="(object, index) of objectLists" :key="index" class="card border-primary border">
      <div class="card-header d-flex">
        <h5 class="survey-title">質問 {{ index + 1 }}</h5>
        <div class="ml-auto">
          <div class="btn btn-sm btn-light" @click="copyObject(index)">
            <i class="mdi mdi-content-copy"></i>
          </div>
          <div @click="moveUpObject(index)" class="btn btn-sm btn-light" v-if="index > 0">
            <i class="dripicons-chevron-up"></i>
          </div>
          <div
            type="button"
            @click="moveDownObject(index)"
            class="btn btn-sm btn-light"
            v-if="index < objectLists.length - 1"
          >
            <i class="dripicons-chevron-down"></i>
          </div>
          <div @click="removeObject(index)" v-if="objectLists.length > 1" class="btn btn-sm btn-light">
            <i class="mdi mdi-delete"></i>
          </div>
        </div>
      </div>
      <div class="card-body">
        <div class="form-group d-flex mt-2 align-items-center">
          <div class="fw-200" @click="object.editing = !object.editing">質問タイプ</div>
          <select
            v-model="object.type"
            @change="
              object.content = null;
              object.editing = true;
            "
            class="form-control flex-grow-1"
          >
            <option value="text">記述式（１行回答）</option>
            <option value="textarea">段落（複数行回答）</option>
            <option value="pulldown">プルダウン</option>
            <option value="radio">ラジオボタン</option>
            <option value="checkbox">チェックボックス</option>
            <option value="file">ファイル添付（JPEG/PNG/PDF）</option>
            <option value="date">日付</option>
          </select>
          <div class="custom-control custom-checkbox ml-2 text-nowrap">
            <input
              type="checkbox"
              class="custom-control-input"
              :id="`questionRequiredCheck${index}`"
              v-model="object.required"
            />
            <label class="custom-control-label" :for="`questionRequiredCheck${index}`"> 必須</label>
          </div>
        </div>

        <div class="mt-2">
          <survey-text-object
            :name="name + '-text-' + index"
            :content="object.content"
            @input="object.content = $event"
            v-if="object.type === 'text'"
          ></survey-text-object>

          <survey-text-area-object
            :name="name + '-textarea-' + index"
            :content="object.content"
            @input="object.content = $event"
            v-else-if="object.type === 'textarea'"
          >
          </survey-text-area-object>

          <survey-radio-object
            :name="name + '-radio-' + index"
            :content="object.content"
            @input="object.content = $event"
            v-else-if="object.type === 'radio'"
          ></survey-radio-object>

          <survey-check-box-object
            :name="name + '-checkbox-' + index"
            :content="object.content"
            @input="object.content = $event"
            v-else-if="object.type === 'checkbox'"
          ></survey-check-box-object>

          <survey-pulldown-object
            :name="name + '-pulldown-' + index"
            :content="object.content"
            @input="object.content = $event"
            v-else-if="object.type === 'pulldown'"
          ></survey-pulldown-object>

          <survey-file-object
            :name="name + '-file-' + index"
            :content="object.content"
            @input="object.content = $event"
            v-else-if="object.type === 'file'"
          ></survey-file-object>

          <survey-date-object
            :name="name + '-date-' + index"
            :content="object.content"
            @input="object.content = $event"
            v-else-if="object.type === 'date'"
          ></survey-date-object>
        </div>
      </div>
    </div>

    <div class="text-center" v-if="objectLists.length < maxObject">
      <div @click="addNewObject()" class="btn btn-primary"><i class="uil-plus"></i> 質問追加</div>
    </div>
  </div>
</template>

<script>
export default {
  props: ['data', 'name'],
  data() {
    return {
      contentKey: 0,
      maxObject: 50,
      objectLists: this.data || [
        {
          editing: true,
          required: false,
          type: 'text',
          content: null
        }
      ]
    };
  },
  inject: ['parentValidator'],

  mounted() {
    this.$validator = this.parentValidator;
    this.syncObj();
  },

  watch: {
    errors: {
      deep: true,
      handler(val) {
        this.objectLists.forEach((object, index) => {
          const fieldText = val.items.find(item => {
            return (
              item.field.includes(this.name + '-text-' + index) ||
              item.field.includes(this.name + '-textarea-' + index) ||
              item.field.includes(this.name + '-radio-' + index) ||
              item.field.includes(this.name + '-checkbox-' + index) ||
              item.field.includes(this.name + '-dropdown-' + index) ||
              item.field.includes(this.name + '-date-' + index) ||
              item.field.includes(this.name + '-file-' + index)
            );
          });
          if (fieldText) {
            object.editing = true;
          }
        });
      }
    }
  },

  methods: {
    forceRerender() {
      this.contentKey++;
    },
    syncObj() {
      this.forceRerender();
      this.$emit('input', this.objectLists);
    },
    addNewObject() {
      this.objectLists.push({
        editing: true,
        required: false,
        type: 'text',
        content: null
      });
      this.syncObj();
    },
    copyObject(index) {
      const newObject = _.cloneDeep(this.objectLists[index]);
      this.objectLists.push(newObject);
      this.syncObj();
      var newSurvey = $('.survey:last')[0];
      newSurvey.scrollIntoView({
        behavior: 'smooth'
      });
    },
    removeObject(index) {
      this.objectLists.splice(index, 1);
      this.syncObj();
    },
    moveUpObject(index) {
      if (index > 0) {
        const to = index - 1;
        this.objectLists.splice(to, 0, this.objectLists.splice(index, 1)[0]);
        this.syncObj();
      }
    },
    moveDownObject(index) {
      if (index < this.objectLists.length) {
        const to = index + 1;
        this.objectLists.splice(to, 0, this.objectLists.splice(index, 1)[0]);
        this.syncObj();
      }
    }
  }
};
</script>

<style lang="scss" scoped>
  ::v-deep {
    .survey {
      border: 1px solid #dedede;
      border-radius: 4px;
      padding: 10px;
    }
    .survey-content-text {
      width: 350px;
      max-width: 400px;
      vertical-align: middle;
      margin: auto 0;
      word-break: break-word;
      font-size: 14px;
    }
    .mt10 {
      margin-top: 10px !important;
    }
    .mr10 {
      margin-right: 10px !important;
    }
    .btn-tool {
      cursor: pointer;
      width: 120px;
      vertical-align: middle;
      font-weight: normal !important;
      text-align: center;
      max-height: 36px;
    }
    .btn-tool > label {
      font-weight: normal;
      margin: 0;
    }
    .btn-tool input {
      margin: auto;
    }
    .btn-copy {
      padding: 10px 15px;
    }

    .survey-title {
      margin: auto 10px auto 0;
      vertical-align: middle;
    }
  }
</style>
<style>
  .tooltip .tooltip-inner {
    background: black;
    color: white;
    border-radius: 16px;
    padding: 5px 10px 4px;
  }

  .tooltip .tooltip-arrow {
    width: 0;
    height: 0;
    border-style: solid;
    position: absolute;
    margin: 5px;
    border-color: black;
    z-index: 1;
  }

  .tooltip[x-placement^="top"] {
    margin-bottom: 5px;
  }

  .tooltip[x-placement^="top"] .tooltip-arrow {
    border-width: 5px 5px 0 5px;
    border-left-color: transparent !important;
    border-right-color: transparent !important;
    border-bottom-color: transparent !important;
    bottom: -5px;
    left: calc(50% - 5px);
    margin-top: 0;
    margin-bottom: 0;
  }

  .tooltip[aria-hidden="true"] {
    visibility: hidden;
    opacity: 0;
    transition: opacity 0.15s, visibility 0.15s;
  }

  .tooltip[aria-hidden="false"] {
    visibility: visible;
    opacity: 1;
    transition: opacity 0.15s;
  }
</style>
