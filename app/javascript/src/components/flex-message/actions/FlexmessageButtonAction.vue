<template>
  <div>
    <p class="text-right" @click="expand()">
      <span class="float-left">ボタン</span>
      <i class="mdi mdi-arrow-expand" aria-hidden="true"></i>
    </p>
    <div
      style="margin-top: 10px; display: none"
      :class="name + '-expand'"
      class="card-container"
    >
      <div class="card">
        <h5 class="card-header">アクション設定</h5>
        <div class="card-body">
          <div class="form-group">
            <message-action-editor
              class="form-group"
              :isNone="false"
              :title="'Action Type'"
              :supports="[
                'postback',
                'uri',
                'message',
                'datetimepicker',
                'survey',
              ]"
              :name="name"
              :value="action"
              @input="action = $event"
            />
          </div>
        </div>
      </div>
    </div>
  </div>
</template>

<script>
export default {
  props: ['name', 'data'],
  data() {
    return {
      action: this.data.action || this.ActionMessage.default
    };
  },

  watch: {
    data() {
      this.action = this.data.action || this.ActionMessage.default;
    },
    action: {
      handler(val) {
        this.input();
      },
      deep: true
    }
  },

  methods: {
    input() {
      const mData = this.data;
      mData.action = this.action;
      this.$emit('input', mData);
    },
    expand() {
      if ($('div.' + this.name + '-expand').is(':visible')) {
        $('div.' + this.name + '-expand').parent().removeClass('active');
      } else {
        $('div.' + this.name + '-expand').parent().addClass('active');
      }
    }
  }
};
</script>

<style lang="scss" scoped>
  .active .card-container {
    display: block !important;
  }

  i.fa-arrow-expand::before {
    content: "\f078";
  }

  .active i.fa-arrow-expand::before {
    content: "\f077";
  }
  ::v-deep {
    .card-header:first-child {
      border-radius: calc(0.25rem - 1px) calc(0.25rem - 1px) 0 0;
    }
    .card-header {
      padding: 0.75rem 1.25rem;
      margin: 0;
      background-color: rgba(0, 0, 0, 0.03);
      border-bottom: 1px solid rgba(0, 0, 0, 0.125);
    }

    .card:nth-child(n + 2) {
      margin-top: 20px;
    }
    .card {
      position: relative;
      display: -ms-flexbox;
      display: flex;
      -ms-flex-direction: column;
      flex-direction: column;
      min-width: 0;
      word-wrap: break-word;
      background-color: #fff;
      background-clip: border-box;
      border: 1px solid rgba(0, 0, 0, 0.125);
      border-radius: 0.25rem;
    }

    .card-body {
      background-color: #efefef;
    }
    .card-body {
      -ms-flex: 1 1 auto;
      flex: 1 1 auto;
      min-height: 1px;
      padding: 1.25rem;
    }

    .col-form-label {
      padding-top: calc(0.375rem + 1px);
      padding-bottom: calc(0.375rem + 1px);
      margin-bottom: 0;
      font-size: inherit;
      line-height: 1.5;
    }

    h5,
    .h5 {
      font-size: 25px;
    }
  }
</style>
