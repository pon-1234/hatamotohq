<template>
    <section>
        <div class="form-group clearfix" >
            <label class="col-sm-3">質問名 <required-mark/></label>
            <div class="col-sm-9">
                <input v-model.trim="value.text"
                       type="text"
                       :name="name+'-text'"
                       class="form-control"
                       maxlength="140"
                       placeholder="" v-validate="'required'">
                <span v-if="errors.first(name+'-text')" class="invalid-box-label">質問名は必須です</span>

            </div>
        </div>
        <div class="form-group clearfix">
            <label class="col-sm-3">質問補足</label>
            <div class="col-sm-9">
                <input v-model.trim="value.sub_text"
                       type="text"
                       :name="name+'-subtext'"
                       class="form-control"
                       placeholder="">
                <span v-if="errors.first(name+'-subtext')" class="invalid-box-label">質問補足は必須です</span>
            </div>
        </div>

        <div class="form-group clearfix">
            <label class="col-sm-3">回答の情報登録</label>
            <div class="col-sm-9">
                <select @change="changeProfileInformation" class="form-control" style="max-width: 220px"
                        v-model="friendInformationSelected">
                    <option v-for="(friendInformation, index) in friendInformations" :value="friendInformation"
                            :key="index">{{friendInformation.name}}
                    </option>
                </select>
                <div v-if="value.profile" style="margin-top: 10px;">
                    <survey-profile-action v-if="value.profile.id === 3" type="text"
                                           :field="value.survey_profile_template? value.survey_profile_template.field_name: null"
                                           :name="name+'-infomation'"
                                           @input="value.survey_profile_template = $event"></survey-profile-action>
                </div>
            </div>
        </div>

        <div v-for="(item, index) of value.data" :key="index" class="survey mt10" style="background: #ededed">
            <div style="display: flex">
                <p style="flex: 1; width: 150px; vertical-align: middle; margin: auto;">選択肢 {{index + 1}}</p>
                <div style="text-align: right">
                    <a @click="moveUpObject(index)" class="btn btn-sm btn-default" v-if="index > 0"><i class="fa fa-arrow-up"></i></a>
                    <a @click="moveDownObject(index)" class="btn btn-sm btn-default"
                       v-if="index < value.data.length - 1"><i class="fa fa-arrow-down"></i></a>
                    <a @click="removeObject(index)" class="btn btn-sm btn-default" v-if="value.data.length > 1">削除</a>
                </div>
            </div>
            <div style="display: flex" class="mt10">
                <input v-model="item.value"
                       :name="name+'-value-'+index"
                       class="form-control mr10"
                       v-validate="'required'">
                <button class="btn btn-sm btn-default" style="height: 36px" @click="item.is_editor = !item.is_editor">アクション選択</button>
            </div>
            <div v-show="item.is_editor" class="mt10" style="display: flex">
                <select class="form-control mr10" style="width: 165px; height: 36px !important;" v-model="item.action.type" @change="item.action.content = null">
                    <option value="tag">タグ</option>
                    <!--<option value="information">友達情報</option>-->
                    <option value="postback">選択時のアクション</option>
                </select>
                <div style="width: calc(100% - 165px)" v-if="!isBlink">
                    <div v-if="item.action.type==='tag'">
                        <input-tag
                                :data="item.action.content ? item.action.content.tag_ids : null"
                                :allTags="true"
                                @input="item.action.content ? item.action.content.tag_ids = $event : item.action.content = {tag_ids: $event}">
                        </input-tag>
                    </div>
                    <div class="action-postback" v-else-if="item.action.type==='postback'">
                        <action-postback
                                :showTitle="false"
                                :value="item.action.content"
                                :name="name+'-postback-'+index"
                                :labelRequired="false"
                                @input="item.action.content = $event"></action-postback>
                    </div>
                </div>
            </div>
        </div>
        <div class="mt10">
            <button type="button" @click="addItem()" v-if="value.data.length < max" class="btn btn-sm btn-default"><i class="fa fa-plus"></i> 追加</button>
        </div>
    </section>
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
        sub_text: null,
        name: this.name,
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
            background: gray;
            padding: 0 10px 10px 10px;
            border-radius: 4px
        }
    }
</style>
