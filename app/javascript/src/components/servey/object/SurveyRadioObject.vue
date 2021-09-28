<template>
  <div>
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
        <div
          v-b-tooltip.hover
          title="回答入力欄の下に表示されます"
          class="ml-2"
        >
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
        <error-message
          :message="errors.first(name + '-subtext')"
        ></error-message>
      </div>
    </div>

    <div class="form-group clearfix d-flex">
      <span class="fw-200">回答の情報登録</span>
      <div class="flex-grow-1">
        <select
          @change="changeProfileInformation"
          class="form-control"
          v-model="friendInformationSelected"
        >
          <option
            v-for="(friendInformation, index) in friendInformations"
            :value="friendInformation"
            :key="index"
            >{{ friendInformation.name }}
          </option>
        </select>
        <div v-if="value.profile" style="margin-top: 10px;">
          <survey-profile-action
            v-if="value.profile.id === 3"
            type="text"
            :field="
              value.survey_profile_template
                ? value.survey_profile_template.field_name
                : null
            "
            :name="name + '-infomation'"
            @input="value.survey_profile_template = $event"
          ></survey-profile-action>
        </div>
      </div>
    </div>

    <div class="d-flex">
      <span class="fw-200">選択肢</span>
      <div class="flex-grow-1">
        <!-- START: checkbox options -->
        <div v-for="(item, index) of value.data" :key="index" class="card border-info border">
          <div class="card-header d-flex">
            <div>選択肢 {{ index + 1 }}</div>
            <div class="ml-auto">
              <div
                @click="moveUpObject(index)"
                class="btn btn-sm btn-light"
                v-if="index > 0"
                ><i class="mdi mdi-arrow-up-bold"></i
              ></div>
              <div
                @click="moveDownObject(index)"
                class="btn btn-sm btn-light"
                v-if="index < value.data.length - 1"
                ><i class="mdi mdi-arrow-down-bold"></i
              ></div>

              <div
                @click="removeObject(index)"
                v-if="value.data.length > 1"
                class="btn btn-sm btn-light">
                <i class="mdi mdi-delete"></i>
              </div>
            </div>
          </div>
          <div class="card-body">
            <div class="form-group d-flex">
              <span class="fw-200">ラベル<required-mark/></span>
              <input class="form-control flex-grow-1" type="text" aria-label="Option Label" aria-describedby="basic-addon1" v-validate="'required'" :name="name + '-value-' + index" v-model="item.value">
            </div>
            <div v-show="item.is_editor" class="form-group d-flex mt-2">
              <div class="fw-200 pr-2">
                <select
                  class="form-control d-block"
                  v-model="item.action.type"
                  @change="item.action.content = null"
                >
                  <option value="tag">タグ</option>
                  <!--<option value="information">友達情報</option>-->
                  <option value="postback">選択時のアクション</option>
                </select>
              </div>
              <div style="width: calc(100% - 200px)" v-if="!isBlink">
                <div v-if="item.action.type === 'tag'">
                  <input-tag
                    :tags="
                      item.action.content ? item.action.content.tag_ids : null
                    "
                    :allTags="true"
                    @input="
                      item.action.content
                        ? (item.action.content.tag_ids = $event)
                        : (item.action.content = { tag_ids: $event })
                    "
                  >
                  </input-tag>
                </div>
                <div
                  class="action-postback"
                  v-else-if="item.action.type === 'postback'"
                >
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
          <div
            @click="addItem()"
            v-if="value.data.length < max"
            class="btn btn-info"
          >
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
      friendInformations: [
        { id: 0, name: '選択なし', type: 'none' },
        { id: 1, name: '表示名', type: 'display_name' },
        { id: 2, name: 'メモ欄', type: 'note' },
        { id: 3, name: '友だち情報名', type: 'survey_profile' }
      ],
      friendInformationSelected: { id: 0, name: '選択なし', type: 'none' },
      value: this.content || {
        text: null,
        name: this.name,
        sub_text: null,
        survey_profile_template: {
          field_name: null,
          id: null
        },
        data: [
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
    if (this.value.profile) {
      this.friendInformationSelected = this.value.profile;
    }
    this.syncObj();
  },
  watch: {
    errors: {
      deep: true,
      handler(val) {
        this.value.data.forEach((object, index) => {
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
  methods: {
    changeProfileInformation() {
      // eslint-disable-next-line no-undef
      this.value.profile = _.cloneDeep(this.friendInformationSelected);
      if (this.value.profile.id !== 3) {
        this.value.survey_profile_template = {
          field_name: null,
          id: null
        };
      }
    },
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
      this.value.data.push({
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
        this.value.data.splice(to, 0, this.value.data.splice(index, 1)[0]);
        this.syncObj();
      }
    },
    moveDownObject(index) {
      if (index < this.value.data.length) {
        const to = index + 1;
        this.value.data.splice(to, 0, this.value.data.splice(index, 1)[0]);
        this.syncObj();
      }
    },
    removeObject(index) {
      this.value.data.splice(index, 1);
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
        a:hover{
            cursor: pointer;
        }
        .form-group{
            padding: 5px 0;
        }
        .mt10 {
            margin-top: 10px !important;
        }
        .mr10 {
            margin-right: 10px !important;
        }
        .action-postback {
            background: #DCDCDC;
            padding: 0 10px 10px 10px;
            border-radius: 4px
        }
    }
</style>
