<template>
    <section v-if="isLoading">
       ローディング...
    </section>
    <section v-else>
        <div class="row-ttl01 flex ai_center mb40 flex-wrap justify-content-between">
            <h3 class="hdg3">リッチメニュー編集</h3>
        </div>

        <div class="form-common01">
            <div class="form-border">
                <div class="form-group">
                    <label>タイトル<required-mark/></label>
                    <input v-model.trim="title" name="title" type="text" class="form-control" placeholder="タイトルを入力してください" v-validate="'required'">
                    <span v-if="errors.first('title')" class="invalid-box-label">タイトルは必須です</span>
                </div>
            </div>

            <div class="form-border">
                <div class="form-group">
                    <label>メニューバーのテキスト<required-mark/></label>
                    <input v-model.trim="chatBarText" name="richmenu-title" type="text" class="form-control" placeholder="タイトルを入力してください" v-validate="'required'">
                    <span v-if="errors.first('richmenu-title')" class="invalid-box-label">タイトルは必須です</span>
                </div>
            </div>

            <div class="form-border">
                <div class="form-group">
                    <label>表示期間<required-mark/></label>
                    <div class="d-flex mb20 sp-flex-direction">
                        <!-- <VueCtkDateTimePicker label="" v-model="start_date" input-size="sm" locale="ja" :error="!start_date" no-label :only-date="true" :max-date="end_date" format="YYYY-MM-DD" formatted="ll" button-now-translation="今"></VueCtkDateTimePicker>&nbsp; -->
                        <div style="display: flex; margin-bottom: 10px">
                            <datetime
                                    type="datetime"
                                    v-model="start_date"
                                    value-zone="Asia/Tokyo"
                                    :max-datetime="end_date"
                                    :input-class="{'error-date date-input': !start_date, 'date-input': start_date}">
                            </datetime>
                            <input type="hidden" :value="start_date" name="start-date" v-validate="'required'">
                        </div>
                        <span class="pc-only">&nbsp;&nbsp;~&nbsp;&nbsp;</span>
                        <!--</div>-->
                        <!--<div class="d-flex align-items-center mb20">-->
                        <!-- <VueCtkDateTimePicker label="" v-model="end_date" input-size="sm" locale="ja" :error="!end_date" no-label :only-date="true" :min-date="start_date" format="YYYY-MM-DD" formatted="ll" button-now-translation="今"></VueCtkDateTimePicker>&nbsp; -->
                        <div style="display: flex; margin-bottom: 10px">
                            <datetime
                                    type="datetime"
                                    v-model="end_date"
                                    value-zone="Asia/Tokyo"
                                    :min-datetime="start_date"
                                    :input-class="{'error-date date-input': !end_date, 'date-input': end_date}">
                            </datetime>
                            <input type="hidden" :value="end_date" name="end_date" v-validate="'required'">
                            &nbsp;&nbsp;
                            <button class="btn btn-secondary" @click="resetTime">リセット</button>
                        </div>
                    </div>
                    <span v-if="messageErrorDateTime" class="invalid-box-label">{{messageErrorDateTime}}</span>
                </div>
            </div>

            <!--Editor-->
            <div class="form-border">
                <rich-menu-type :background="backgroundUrl"
                                 :areas="areas"
                                 :templateId="templateId"
                                 :typeTemplate="typeTemplate"
                                 :templateValue="templateValue" @input="richMenu" />
            </div>

            <div class="form-border">
              <div class="form-group">
                  <label>配信先</label>
                  <div class="row-form01 row-form-send mb10">
                      <label><input type="radio" name="send" value="all" :checked="!tags" @click="resetListTag">全員</label>
                      <label><input type="radio" name="send" value="sort" :checked="tags && tags.length >= 0" @click="tags = []">タグで絞り込む</label>
                  </div>
                  <div class="box-form01 box-form-sort" :style="tags && tags.length >= 0? {display: 'block'}:{display: 'none'}">
                      <label>タグ</label>
                      <div class="list-checkbox-tag" v-if="refresh_tag">
                        <input-tag :tags="tags" @input="addListTag"/>
                      </div>
                  </div>
              </div>
            </div>
            <div class="form-border">
                <div class="form-group">
                    <label class="mb10">設定</label>
                    <div class="flex start ai_center">
                        <div class="toggle-switch btn-keyword01">
                            <input v-model="selected" id="keyword-onoff-setting01" class="toggle-input" type="checkbox">
                            <label for="keyword-onoff-setting01" class="toggle-label">
                                <span></span>
                            </label>
                        </div>
                    </div>
                </div>
            </div>
            <div class="form-bottom">
                <div class="row-form-btn flex start">
                    <button @click="submitRichMenu" class="btn btn-submit btn-block">保存</button>
                    <button class="btn btn-delete btn-block" data-toggle="modal"
                        data-target="#modalConfirmDelete">削除</button>
                </div>
            </div>
        </div>

        <modal-confirm
          :id="'modalConfirmDelete'"
          :title="'以下のリッチメニューを削除します。よろしいですか？'"
          :type="'delete'"
          @input="deleteRichMenu" />
        <modal-richmenu-template-selection :selectionId="templateId" @accept="templateChange" />
        <media-modal :data="{type: 'richmenu'}" @input="changeLineMediaAlias" />
        <modal-alert :title="'表示期間が別のリッチメニューと重複しています。別の表示期間を設定してください'" />
    </section>
</template>

<script>
import Util from '@/core/util';
import moment from 'moment';
import { mapActions } from 'vuex';

export default {
  props: {
    richMenuId: {
      type: Number,
      default: null
    }
  },

  data() {
    return {
      isLoading: true,
      backgroundUrl: null,
      templateId: 201,
      templateValue: 6,
      line_media_alias: null,
      title: null,
      chatBarText: null,
      selected: false,
      start_date: moment().format('YYYY-MM-DD'),
      end_date: moment().format('YYYY-MM-DD'),
      areas: [],
      tags: null,
      refresh_tag: true,
      typeTemplate: 'large',
      messageErrorDateTime: ''
    };
  },

  provide() {
    return { parentValidator: this.$validator };
  },
  watch: {
    line_media_alias(val) {
      this.backgroundUrl = process.env.MIX_MEDIA_FLEXA_URL + '/' + val;
    }
  },

  async beforeMount() {
    if (this.richMenuId === null) {
      window.location.href = process.env.MIX_ROOT_PATH + '/richmenus';
    } else {
      this.$store.dispatch('richmenu/getDetail', this.richMenuId)
        .then((res) => {
          this.isLoading = false;
          this.line_media_alias = res.line_media_alias;
          this.title = res.title;
          this.chatBarText = res.chatBarText;
          this.selected = res.selected;
          this.start_date = moment(res.start_date).format('YYYY-MM-DDTHH:mm:ss.000+09:00');
          this.end_date = moment(res.end_date).format('YYYY-MM-DDTHH:mm:ss.000+09:00');
          this.areas = res.areas;
          this.templateId = res.templateId;
          this.templateValue = this.RichMenuValue[this.templateId];

          if (res.tags && res.tags.length) {
            this.refresh_tag = false;
            this.tags = res.tags;
            this.$nextTick(() => {
              this.refresh_tag = true;
            });
          }
        })
        .catch(() => window.history.back());
    }

    await this.getTags();
    await this.listTagAssigned();
  },

  methods: {
    ...mapActions('tag', [
      'getTags',
      'listTagAssigned'
    ]),

    templateChange(data) {
      this.templateId = data.id;
      this.templateValue = this.RichMenuValue[this.templateId];
      this.typeTemplate = data.type;
    },

    changeLineMediaAlias(alias) {
      this.line_media_alias = alias;
    },

    disabledMaxDate() {
      if (this.end_date) { return { from: new Date(this.end_date) }; }
    },

    disabledMinDate() {
      return { to: new Date(this.start_date) };
    },

    richMenu(input) {
      this.areas = input;
    },

    async submitRichMenu() {
      let isError = !(await this.$validator.validateAll());

      // validate areas
      for (const area of this.areas) {
        if (Util.checkConditionActionElement(area.action)) {
          area.expand = true;
          isError = true;
        } else {
          area.expand = false;
        }
      }

      const datetimeStart = moment(this.start_date).format('YYYY-MM-DD HH:mm');
      const datetimeEnd = moment(this.end_date).format('YYYY-MM-DD HH:mm');

      if (moment(datetimeStart).isAfter(datetimeEnd)) {
        isError = true;
        this.messageErrorDateTime = '開始時間は終了時間の前に設定してください。';
      } else {
        this.messageErrorDateTime = '';
      }

      if (isError) {
        $('input, textarea').each(
          function(index) {
            var input = $(this);
            if (input.attr('aria-invalid') && input.attr('aria-invalid') === 'true') {
              $('html,body').animate({ scrollTop: input.offset().top - 200 }, 'slow');
              return false;
            }
          }
        );
        return;
      }

      const data = {
        id: this.richMenuId,
        start_date: datetimeStart,
        end_date: datetimeEnd,
        line_media_alias: this.line_media_alias,
        templateId: this.templateId,
        size: {
          width: 2500,
          height: 1686
        },
        title: this.title,
        chatBarText: this.chatBarText,
        selected: this.selected ? 1 : 0,
        areas: this.areas
      };

      if (this.tags) {
        data.tags = this.tags;
      }

      if (this.typeTemplate === 'compact' || this.templateId > 1000) {
        data.size.width = 2500;
        data.size.height = 843;
      }

      this.$store.dispatch('richmenu/editRichmenu', data).then((res) => {
        // thanh cong
        window.toastr.success('編集完成しました');
        window.location.href = process.env.MIX_ROOT_PATH + '/richmenus';
      }).catch((err) => {
        if (err.status === 400 || err.status === 422) {
          // show dialog error
          $('#modal-alert').modal('show');
        } else if (err.status === 422) {
          window.toastr.error('');
        }
      });
    },

    async deleteRichMenu() {
      await this.$store.dispatch('richmenu/destroyRichmenu', {
        richMenuId: this.richMenuId
      });
      window.location.href = process.env.MIX_ROOT_PATH + '/richmenus';
    },

    getPlaceholderDate() {
      return moment().format('YYYY-MM-DD');
    },

    resetTime() {
      this.start_date = null;
      this.end_date = null;
    },

    resetListTag() {
      this.refresh_tag = false;
      this.tags = null;
      this.$nextTick(() => {
        this.refresh_tag = true;
      });
    },

    addListTag(data) {
      this.tags = data;
    }
  }
};
</script>

<style scoped lang="scss">
    ::v-deep{
      .form-control[disabled], .form-control[readonly], fieldset[disabled] .form-control{
          background: white !important;
      }

      .date-time-picker {
        max-width: 300px!important;
        margin: unset!important;
      }

      #time-select-wrapper {
        max-width: 150px!important;
      }
        @media(min-width: 991px) {
            .vdatetime{

            }
            .sp-flex-direction{
                flex-direction: row;
            }
        }
        @media(max-width: 991px) {
            .vdatetime{

            }
            .sp-flex-direction{
                flex-direction: column;
            }
        }
    }

</style>
