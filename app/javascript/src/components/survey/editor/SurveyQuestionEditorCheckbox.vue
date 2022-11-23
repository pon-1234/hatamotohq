<template>
  <div class="survey">
    <div class="form-group clearfix d-flex">
      <label class="fw-200">項目名<required-mark /></label>
      <div class="flex-grow-1">
        <input
          v-model.trim="questionContentData.text"
          type="text"
          :name="name + '-text'"
          class="form-control"
          maxlength="256"
          placeholder="項目名を入力してください"
          v-validate="'required|max:255'"
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
          v-model.trim="questionContentData.sub_text"
          :name="name + '-subtext'"
          type="text"
          class="form-control"
          placeholder="補足文を入力してください"
          maxlength="256"
          v-validate="'max:255'"
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
          :field="questionContentData.variable ? questionContentData.variable.name : null"
          :name="name + '-infomation'"
          @input="questionContentData.variable = $event"
        ></survey-variable-config>
      </div>
    </div>

    <div class="d-flex">
      <span class="fw-200">選択肢</span>
      <div class="flex-grow-1">
        <!-- START: checkbox options -->
        <div v-for="(item, index) of questionContentData.options" :key="index" class="card border-info border">
          <div class="card-header d-flex">
            <div>選択肢 {{ index + 1 }}</div>
            <div class="ml-auto">
              <div @click="moveUpObject(index)" class="btn btn-sm btn-light" v-if="index > 0">
                <i class="dripicons-chevron-up"></i>
              </div>
              <div
                @click="moveDownObject(index)"
                class="btn btn-sm btn-light"
                v-if="index < questionContentData.options.length - 1"
              >
                <i class="dripicons-chevron-down"></i>
              </div>

              <div
                @click="removeObject(index)"
                v-if="questionContentData.options.length > 1"
                class="btn btn-sm btn-light"
              >
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
                v-model.trim="item.value"
                placeholder="ラベルを入力してください"
              />
            </div>
            <div class="form-group d-flex mt-2">
              <div class="fw-200 pr-2">
                <span class="fw-200">選択時のアクション</span>
              </div>
              <div style="width: calc(100% - 200px)" :key="contentKey">
                <div class="action-postback">
                  <action-postback
                    :showTitle="false"
                    :value="item.action"
                    :name="name + '-postback-' + index"
                    :requiredLabel="false"
                    @input="item.action = $event"
                  ></action-postback>
                </div>
              </div>
            </div>
          </div>
        </div>
        <div class="mt-2">
          <div @click="addItem()" v-if="questionContentData.options.length < max" class="btn btn-info">
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
      contentKey: 0,
      max: 50,
      questionContentData: this.content || {
        text: null,
        sub_text: null,
        name: this.name,
        profile: null,
        variable: {
          name: null,
          id: null
        },
        options: [
          {
            value: null,
            action: {
              type: 'none'
            }
          }
        ]
      }
    };
  },
  inject: ['parentValidator'],

  created() {
    this.$validator = this.parentValidator;
    this.questionContentData.name = this.name;
    this.syncObj();
  },
  methods: {
    forceRerender() {
      this.contentKey++;
    },

    syncObj() {
      this.forceRerender();
      this.$emit('input', this.questionContentData);
    },
    addItem() {
      this.questionContentData.options.push({
        value: null,
        action: {
          type: 'none'
        }
      });
      this.syncObj();
    },
    moveUpObject(index) {
      if (index > 0) {
        const to = index - 1;
        this.questionContentData.options.splice(to, 0, this.questionContentData.options.splice(index, 1)[0]);
        this.syncObj();
      }
    },
    moveDownObject(index) {
      if (index < this.questionContentData.options.length) {
        const to = index + 1;
        this.questionContentData.options.splice(to, 0, this.questionContentData.options.splice(index, 1)[0]);
        this.syncObj();
      }
    },
    removeObject(index) {
      this.questionContentData.options.splice(index, 1);
      this.syncObj();
    }
  }
};
</script>
