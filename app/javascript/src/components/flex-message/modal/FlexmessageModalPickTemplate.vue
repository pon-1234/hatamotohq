<template>
  <div
    class="modal fade modal-template modal-common01"
    :id="name"
    tabindex="-1"
    role="dialog"
    aria-labelledby="myModalLabel"
    aria-hidden="true"
  >
    <div class="modal-dialog" role="document">
      <div class="modal-content" style="padding: 0 15px 15px 15px;">
        <div class="modal-header">
          <h4 class="modal-title">Flexメッセージのテンプレートを選ぶ</h4>
          <button type="button" class="close" data-dismiss="modal" aria-label="Close">
            <span aria-hidden="true">&times;</span>
          </button>
        </div>
        <div class="modal-body mh-100 overflow-hidden">
          <div style="background: #ededed; text-align: center"  v-if="flexMessageTemplates != null">
            <div  data-sample-id="restaurant" class="sample-item" v-for="(template, key) in flexMessageTemplates"
                 :key="key" @click="pickTemplateShowCase(template)" data-dismiss="modal">
              <div class="thumb">
                <img :src="template.image_template" style="">
                <div class="label" style="display: block; text-align: center; font-size: 16px; overflow: hidden; text-overflow: ellipsis">
                  {{template.title}}
                </div>
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
  props: ['name', 'flexMessageTemplates'],

  methods: {
    pickTemplateShowCase(template) {
      this.$emit('input', template.id);
    }
  }
};
</script>

<style scoped lang="scss">

  ::v-deep {
    .thumb{
      display: block;
    }

    .thumb > img {
      justify-content: center;
      /* width: 100%; */
      height: 200px;
      padding: 10px 0;
      object-position: left;
      object-fit: cover;
    }

    .sample-item {
      width: 33%;
      margin-bottom: 10px;
      cursor: pointer;
      display: inline-block;
      border: 2px solid transparent;
    }

    .sample-item:hover{
      border-color: #ff9900;
    }

    .label {
      color: #1b1b1b;
    }

    .modal-body{
      background: #ededed;
    }
    .modal-dialog {
      top: 0 !important;
      margin: auto;
      transform: translateY(0) !important;
      padding: 30px !important;
      max-width: 1200px;
    }
    @media (max-width: 1200px) {
      .thumb > img{
        height: 300px;
      }
      .sample-item {
        width: 40%;
      }
      .modal-dialog {
        margin: auto;
        padding: 30px 20px !important;

      }
    }
    @media (max-width: 768px) {
      .thumb > img{
        height: 100px;
      }
      .modal-dialog {
        padding: 40px 0 !important;

        position: relative;
        width: auto;
        margin: auto;
        max-width: 95%;
      }
    }

    a {
      background: initial !important;
    }
  }
</style>
