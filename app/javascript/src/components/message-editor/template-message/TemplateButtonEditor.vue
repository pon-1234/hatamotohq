<template>
  <div>
    <div class="border template-buttons row">
      <div class="d-flex group-title col-md-6">
        <label class="mt20">
          タイトル<required-mark/>
        </label>
        <input class="input-age form-control" placeholder="タイトルを入力してください" type="text" maxlength="40" v-model="defaults.title" v-validate="'required'" :name="'button-title'+ indexParent"/>
        <span v-if="errors.first('button-title' + indexParent)" class="is-validate-label">タイトルは必須です</span>
      </div>
      <div class="d-flex group-title col-md-6">
        <label class="mt20">
          テキスト<required-mark/>
        </label>
        <input class="input-age form-control" placeholder="テキストを入力してください" :name="'button-text'+indexParent" type="text" maxlength="60" v-model="defaults.text" v-validate="'required'"/>
        <span v-if="errors.first('button-text'+indexParent)" class="is-validate-label">テキストは必須です</span>
      </div>
      <div class="col-md-12 mt20">
        <ul class="nav nav-tabs nav-buttons">
          <li v-for="(item, index) in defaults.actions" :key="index" :class="selected == index? 'active': ''" @click="changeSelected(index)">
            <div class="nav-button align-items-center justify-content-center" :class="errors.items.find(item=>item.field.includes(indexParent + 'template_button_' + index)) ? 'is-validate': ''">
              ボタン{{index + 1}}
              <span v-if="defaults.actions.length > 1" class="action-tab-selector-remover" @click.stop="removeAction(index)"><i class="fas fa-times"></i></span>
            </div>
          </li>
          <li v-if="defaults.actions.length < 4">
            <div class="nav-button align-items-center justify-content-center" @click="addMoreAction">
              <i class="fa fa-plus"></i> 追加
            </div>
          </li>
        </ul>

      </div>
      <div class="col-md-12 mt20">
        <label>
          選択後の挙動
          <required-mark/>
        </label>
      </div>
      <div class="col-md-12"  v-for="(item, index) in defaults.actions" :key="index" v-show="index === selected">
        <message-action-type
          :name="indexParent + 'template_button_' + index"
          :value="item"
          @input="changeAction(index, $event)"
        />
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
      defaults: {
        type: this.TemplateMessageType.Buttons,
        title: '',
        text: '',
        actions: [
          this.ActionMessage.default
        ]
      }
    };
  },
  created() {
    this.$validator = this.parentValidator;
    if (this.data) {
      Object.assign(this.defaults, this.data);
      this.action_type = this.defaults.actions[0].type;
    }
  },
  watch: {
    defaults: {
      handler(val) {
        this.$emit('input', val);
      },
      deep: true
    }
  },
  methods: {
    addMoreAction() {
      this.selected = this.defaults.actions.length;
      this.defaults.actions.push(this.ActionMessage.default);
    },

    changeSelected(index) {
      this.selected = index;
      this.action_type = this.defaults.actions[index].type;
    },

    removeAction(index) {
      this.defaults.actions.splice(index, 1);
      this.selected = 0;
    },

    changeAction(index, data) {
      this.defaults.actions.splice(index, 1, data);
    }
  }
};
</script>

<style lang="scss" scoped>
::v-deep{
  .template-buttons {
    padding: 15px 0
  ;
    margin: 0px!important;
  }

  .row {
      margin: 0!important;
  }

  .group-title {
    flex-direction: column;
  }



  .nav-buttons{
    li {
      cursor: pointer;
      .nav-button {
        color: #28a745;
        border: 1px solid #ddd;
        height: 30px;
        width: 100px;
        display: flex;
        justify-content: center;
        border-radius: 5px 5px 0 0;
      }

      .action-tab-selector-remover {
        padding: 5px;
        cursor: pointer;
        color: #28a745;
        border-radius: 2px;
        line-height: 1;
        align-items: center;
        justify-content: center;
        margin-left: 5px;
        display: inline-flex;
        vertical-align: middle;
      }
    }

    li.active {
     .nav-button {
        background: #28a745;
        color: white;
        font-weight: bold;
      }
      .action-tab-selector-remover {
        color: white;
      }
    }
  }

  .glyphicon-remove{
    font-size: 13px;
    margin-bottom: 2px;
  }
}
</style>
