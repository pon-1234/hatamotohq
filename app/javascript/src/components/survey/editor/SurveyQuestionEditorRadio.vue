<template>
  <div class="survey">
    <div class="form-group clearfix d-flex">
      <label class="fw-200">項目名<required-mark /></label>
      <div class="flex-grow-1">
        <input
          v-model.trim="value.text"
          type="text"
          :name="name + '-text'"
          class="form-control"
          maxlength="140"
          placeholder=""
          v-validate="'required'"
          data-vv-as="項目名"
        />
        <error-message :message="errors.first(name + '-text')"></error-message>
      </div>
    </div>
    <div class="form-group clearfix d-flex">
      <div class="fw-200 d-flex align-items-center">
        <span>補足文</span>
        <div v-b-tooltip.hover title="回答入力欄の下に表示されます" class="ml-2">
          <i class="text-md far fa-question-circle"></i>
        </div>
      </div>
      <div class="flex-grow-1">
        <input
          v-model.trim="value.sub_text"
          :name="name + '-subtext'"
          type="text"
          class="form-control"
          placeholder=""
          data-vv-as="補足文"
        />
        <error-message :message="errors.first(name + '-subtext')"></error-message>
      </div>
    </div>

    <div class="form-group clearfix d-flex">
      <span class="fw-200">回答の情報登録</span>
      <div class="flex-grow-1">
        <survey-variable-config
          type="text"
          :field="value.variable ? value.variable.name : null"
          :name="name + '-infomation'"
          @input="value.variable = $event"
        ></survey-variable-config>
      </div>
    </div>

    <div class="d-flex">
      <span class="fw-200">選択肢</span>
      <div class="flex-grow-1">
        <!-- START: checkbox options -->
        <div v-for="(item, index) of options" :key="index" class="card border-info border">
          <div class="card-header d-flex">
            <div>選択肢 {{ index + 1 }}</div>
            <div class="ml-auto">
              <div @click="moveUpObject(index)" class="btn btn-sm btn-light" v-if="index > 0">
                <i class="dripicons-chevron-up"></i>
              </div>
              <div @click="moveDownObject(index)" class="btn btn-sm btn-light" v-if="index < options.length - 1">
                <i class="dripicons-chevron-down"></i>
              </div>

              <div @click="removeObject(index)" v-if="options.length > 1" class="btn btn-sm btn-light">
                <i class="mdi mdi-delete"></i>
              </div>
            </div>
          </div>
          <div class="card-body">
            <div class="form-group d-flex">
              <span class="fw-200">ラベル<required-mark /></span>
              <input
                class="form-control flex-grow-1"
                type="text"
                aria-label="Option Label"
                aria-describedby="basic-addon1"
                v-validate="'required'"
                :name="name + '-value-' + index"
                v-model="item.value"
              />
            </div>
            <div v-show="item.is_editor" class="form-group d-flex mt-2">
              <div class="fw-200 pr-2">
                <select class="form-control d-block" v-model="item.action.type" @change="item.action.content = null">
                  <option value="tag">タグ</option>
                  <!--<option value="information">友達情報</option>-->
                  <option value="postback">選択時のアクション</option>
                </select>
              </div>
              <div style="width: calc(100% - 200px)" v-if="!isBlink">
                <div v-if="item.action.type === 'tag'">
                  <input-tag
                    :tags="item.action.content ? item.action.content.tag_ids : null"
                    :allTags="true"
                    @input="
                      item.action.content
                        ? (item.action.content.tag_ids = $event)
                        : (item.action.content = { tag_ids: $event })
                    "
                  >
                  </input-tag>
                </div>
                <div class="action-postback" v-else-if="item.action.type === 'postback'">
                  <action-postback
                    :showTitle="false"
                    :value="item.action.content"
                    :name="name + '-postback-' + index"
                    :labelRequired="false"
                    @input="item.action.content = $event"
                  ></action-postback>
                </div>
              </div>
            </div>
          </div>
        </div>
        <div class="mt-2">
          <div @click="addItem()" v-if="options.length < max" class="btn btn-info">
            <i class="uil-plus"></i> 選択肢追加
          </div>
        </div>
      </div>
      <!-- END: checkbox options -->
    </div>
  </div>
</template>

<script>
export default {
  props: ['content', 'name'],
  data() {
    return {
      max: 50,
      isBlink: false,
      value: this.content || {
        text: null,
        name: this.name,
        sub_text: null,
        variable: {
          name: null,
          id: null
        },
        options: [
          {
            is_editor: true,
            value: null,
            action: {
              type: 'tag',
              content: {
                tag_ids: null
              }
            }
          }
        ]
      }
    };
  },
  inject: ['parentValidator'],

  created() {
    this.$validator = this.parentValidator;
    this.value.name = this.name;
    this.syncObj();
  },

  watch: {
    errors: {
      deep: true,
      handler(val) {
        this.options.forEach((object, index) => {
          const fieldText = val.items.find(item => {
            return item.field.includes(this.name + '-postback-' + index);
          });

          if (fieldText) {
            object.is_editor = true;
          }
        });
      }
    }
  },

  computed: {
    options() {
      return this.value ? this.value.options : [];
    }
  },

  methods: {
    blink() {
      this.isBlink = true;
      this.$nextTick(() => {
        this.isBlink = false;
      });
    },
    syncObj() {
      this.blink();
      console.log(this.value);
      this.$emit('input', this.value);
    },
    addItem() {
      this.options.push({
        is_editor: true,
        value: null,
        action: {
          type: 'tag',
          content: {
            tag_ids: null
          }
        }
      });
      this.syncObj();
    },
    moveUpObject(index) {
      if (index > 0) {
        const to = index - 1;
        this.options.splice(to, 0, this.options.splice(index, 1)[0]);
        this.syncObj();
      }
    },
    moveDownObject(index) {
      if (index < this.options.length) {
        const to = index + 1;
        this.options.splice(to, 0, this.options.splice(index, 1)[0]);
        this.syncObj();
      }
    },
    removeObject(index) {
      this.options.splice(index, 1);
      this.syncObj();
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
    a:hover {
      cursor: pointer;
    }
    .form-group {
      padding: 5px 0;
    }
    .mt10 {
      margin-top: 10px !important;
    }
    .mr10 {
      margin-right: 10px !important;
    }
    .action-postback {
      background: #dcdcdc;
      padding: 0 10px 10px 10px;
      border-radius: 4px;
    }
  }
</style>
