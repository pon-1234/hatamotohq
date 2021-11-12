<template>
  <div>
    <div class="border template-buttons row">
      <div class="d-flex group-title col-12">
        <label class="mt-2"> タイトル<required-mark /></label>
        <input
          class="form-control"
          placeholder="タイトルを入力してください"
          type="text"
          maxlength="41"
          v-model.trim="templateData.title"
          v-validate="'required|max:40'"
          data-vv-as="タイトル"
          :name="'button-title' + indexParent"
        />
        <error-message :message="errors.first('button-title' + indexParent)"></error-message>
      </div>

      <div class="d-flex group-title col-12">
        <label class="mt-2 d-flex align-items-center"> テキスト<required-mark /> </label>
        <input
          class="form-control"
          placeholder="テキストを入力してください"
          :name="'button-text' + indexParent"
          type="text"
          maxlength="61"
          v-model.trim="templateData.text"
          v-validate="'required|max:60'"
          data-vv-as="テキスト"
        />
        <error-message :message="errors.first('button-text' + indexParent)"></error-message>
      </div>

      <div class="row col-12" style="margin-top: 15px !important">
        <div class="col-sm-3">
          <ul class="nav nav-tabs nav-stacked nav-buttons d-block">
            <li
              v-for="(item, index) in templateData.actions"
              :key="index"
              :class="selected == index ? 'active' : ''"
              @click="changeSelected(index)"
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
                <span v-if="templateData.actions.length > 1" @click.stop="removeAction(index)" class="ml-auto mr-1"
                  ><i class="dripicons-trash"></i
                ></span>
              </div>
            </li>
            <li v-if="templateData.actions.length < 4">
              <div class="nav-button btn btn-primary justify-content-center" @click="addMoreAction">
                <i class="uil-plus"></i> 追加
              </div>
            </li>
          </ul>
        </div>
        <div class="col-sm-9">
          <div class="card">
            <div class="card-header">
              <b>選択肢{{ selected + 1 }}</b>
            </div>
            <div class="card-body">
              <div v-for="(item, index) in templateData.actions" :key="index" v-show="index === selected">
                <action-editor
                  :name="'parent_' + indexParent + 'template_button_' + index"
                  :value="item"
                  @input="changeAction(index, $event)"
                />
              </div>
            </div>
          </div>
        </div>
      </div>
    </div>
  </div>
</template>
<script>
export default {
  props: ['data', 'indexParent'],
  inject: ['parentValidator'],
  data() {
    return {
      selected: 0,
      action_type: 'message',
      templateData: {
        type: this.TemplateMessageType.Buttons,
        title: '',
        text: '',
        altText: '',
        actions: [this.ActionMessage.default]
      }
    };
  },
  created() {
    this.$validator = this.parentValidator;
    if (this.data) {
      Object.assign(this.templateData, this.data);
      this.action_type = this.templateData.actions[0].type;
    }
  },
  watch: {
    templateData: {
      handler(val) {
        this.$emit('input', val);
      },
      deep: true
    }
  },
  methods: {
    addMoreAction() {
      this.selected = this.templateData.actions.length;
      this.templateData.actions.push(this.ActionMessage.default);
    },

    changeSelected(index) {
      this.selected = index;
      this.action_type = this.templateData.actions[index].type;
    },

    removeAction(index) {
      this.templateData.actions.splice(index, 1);
      this.selected = 0;
    },

    changeAction(index, data) {
      this.templateData.actions.splice(index, 1, data);
    }
  }
};
</script>

<style lang="scss" scoped>
  ::v-deep {
    .row {
      margin: 0 !important;
    }

    .group-title {
      flex-direction: column;
    }

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
      .action-tab-selector-remover {
        color: white;
      }
    }

    .glyphicon-remove {
      font-size: 13px;
      margin-bottom: 2px;
    }
  }
</style>
