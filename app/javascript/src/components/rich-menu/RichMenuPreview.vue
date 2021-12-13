<template>
  <div
    class="
      richmenu-preview
      d-flex-sm
      justify-content-center
      align-items-center
      position-relative
      cursor-pointer
      bg-white
    "
    :style="
      typeTemplate == 'compact' || templateId > 1000
        ? { cursor: 'pointer', height: '86px' }
        : { cursor: 'pointer', height: '172.554px' }
    "
  >
    <img :src="background || '/img/richmenu-default.png'" class="w-100 h-100 position-absolute" />

    <div class="text-center text-muted mb-0 position-absolute" v-if="background == null">
      <small> テンプレートを選択して、背景画像をアップロードしてください。 </small>
    </div>

    <table class="position-absolute w-100 h-100 rounded border border-primary text-center" v-if="templateId == '201'">
      <tr>
        <td
          class="h2 text-white border-left border-primary bg-dark-10"
          style="width: 33.33%"
          @click="$emit('click', 'A')"
        >
          A
        </td>
        <td class="h2 text-white border-left border-primary" style="width: 33.33%" @click="$emit('click', 'B')">B</td>
        <td class="h2 text-white border-left border-primary" style="width: 33.34%" @click="$emit('click', 'C')">C</td>
      </tr>
      <tr class="border-top border-primary">
        <td class="h2 text-white border-left border-primary" style="width: 33.33%" @click="$emit('click', 'D')">D</td>
        <td class="h2 text-white border-left border-primary" style="width: 33.33%" @click="$emit('click', 'E')">E</td>
        <td class="h2 text-white border-left border-primary" style="width: 33.34%" @click="$emit('click', 'F')">F</td>
      </tr>
    </table>

    <table
      class="position-absolute w-100 h-100 rounded border border-primary text-center"
      v-else-if="templateId == '202'"
    >
      <tr>
        <td class="h2 text-white border-left border-primary bg-dark-10" style="width: 50%" @click="$emit('click', 'A')">
          A
        </td>
        <td class="h2 text-white border-left border-primary" style="width: 50%" @click="$emit('click', 'B')">B</td>
      </tr>
      <tr class="border-top border-primary">
        <td class="h2 text-white border-left border-primary" style="width: 50%" @click="$emit('click', 'C')">C</td>
        <td class="h2 text-white border-left border-primary" style="width: 50%" @click="$emit('click', 'D')">D</td>
      </tr>
    </table>

    <table
      class="position-absolute w-100 h-100 rounded border border-primary text-center"
      v-else-if="templateId == '203'"
    >
      <tr>
        <td
          class="h2 text-white border-left border-primary bg-dark-10"
          colspan="3"
          style="width: 100%"
          @click="$emit('click', 'A')"
        >
          A
        </td>
      </tr>
      <tr class="border-top border-primary">
        <td class="h2 text-white border-left border-primary" style="width: 33.33%" @click="$emit('click', 'B')">B</td>
        <td class="h2 text-white border-left border-primary" style="width: 33.33%" @click="$emit('click', 'C')">C</td>
        <td class="h2 text-white border-left border-primary" style="width: 33.34%" @click="$emit('click', 'D')">D</td>
      </tr>
    </table>
    <table
      class="position-absolute w-100 h-100 rounded border border-primary text-center"
      v-else-if="templateId == '204'"
    >
      <tr>
        <td
          class="h2 text-white border-left border-primary bg-dark-10"
          colspan="2"
          rowspan="2"
          @click="$emit('click', 'A')"
        >
          A
        </td>

        <td class="h2 text-white border-left border-primary" style="width: 33.34%" @click="$emit('click', 'B')">B</td>
      </tr>
      <tr class="border-top border-primary">
        <td class="h2 text-white border-left border-primary" style="width: 33.34%" @click="$emit('click', 'C')">C</td>
      </tr>
    </table>
    <table
      class="position-absolute w-100 h-100 rounded border border-primary text-center"
      v-else-if="templateId == '205'"
    >
      <tr>
        <td
          class="h2 text-white border-left border-primary bg-dark-10"
          style="width: 33.33%"
          @click="$emit('click', 'A')"
        >
          A
        </td>
      </tr>
      <tr class="border-top border-primary">
        <td class="h2 text-white border-left border-primary" style="width: 33.33%" @click="$emit('click', 'B')">B</td>
      </tr>
    </table>
    <table
      class="position-absolute w-100 h-100 rounded border border-primary text-center"
      v-else-if="templateId == '206'"
    >
      <tr>
        <td
          class="h2 text-white border-left border-primary bg-dark-10"
          rowspan="2"
          style="width: 50%"
          @click="$emit('click', 'A')"
        >
          A
        </td>
        <td
          class="h2 text-white border-left border-primary"
          rowspan="2"
          style="width: 50%"
          @click="$emit('click', 'B')"
        >
          B
        </td>
      </tr>
    </table>
    <table
      class="position-absolute w-100 h-100 rounded border border-primary text-center"
      v-else-if="templateId == '207'"
    >
      <tr>
        <td
          class="h2 text-white border-left border-primary bg-dark-10"
          rowspan="2"
          style="width: 100%"
          @click="$emit('click', 'A')"
        >
          A
        </td>
      </tr>
    </table>
    <table
      class="position-absolute w-100 h-100 rounded border border-primary text-center table-compact"
      v-else-if="templateId == '1001'"
    >
      <tr>
        <td
          class="h2 text-white border-left border-primary bg-dark-10"
          style="width: 33.33%"
          @click="$emit('click', 'A')"
        >
          A
        </td>
        <td
          class="h2 text-white border-left border-primary bg-dark-10"
          style="width: 33.34%"
          @click="$emit('click', 'B')"
        >
          B
        </td>
        <td
          class="h2 text-white border-left border-primary bg-dark-10"
          style="width: 33.33%"
          @click="$emit('click', 'C')"
        >
          C
        </td>
      </tr>
    </table>
    <table
      class="position-absolute w-100 h-100 rounded border border-primary text-center table-compact"
      v-else-if="templateId == '1002'"
    >
      <tr>
        <td
          class="h2 text-white border-left border-primary bg-dark-10"
          style="width: 33.33%"
          @click="$emit('click', 'A')"
        >
          A
        </td>
        <td
          class="h2 text-white border-left border-primary bg-dark-10"
          style="width: 66.67%"
          @click="$emit('click', 'B')"
        >
          B
        </td>
      </tr>
    </table>
    <table
      class="position-absolute w-100 h-100 rounded border border-primary text-center table-compact"
      v-else-if="templateId == '1003'"
    >
      <tr>
        <td
          class="h2 text-white border-left border-primary bg-dark-10"
          style="width: 66.67%"
          @click="$emit('click', 'A')"
        >
          A
        </td>
        <td
          class="h2 text-white border-left border-primary bg-dark-10"
          style="width: 33.33%"
          @click="$emit('click', 'B')"
        >
          B
        </td>
      </tr>
    </table>
    <table
      class="position-absolute w-100 h-100 rounded border border-primary text-center table-compact"
      v-else-if="templateId == '1004'"
    >
      <tr>
        <td class="h2 text-white border-left border-primary bg-dark-10" style="width: 50%" @click="$emit('click', 'A')">
          A
        </td>
        <td class="h2 text-white border-left border-primary bg-dark-10" style="width: 50%" @click="$emit('click', 'B')">
          B
        </td>
      </tr>
    </table>
    <table
      class="position-absolute w-100 h-100 rounded border border-primary text-center table-compact"
      v-else-if="templateId == '1005'"
    >
      <tr>
        <td
          class="h2 text-white border-left border-primary bg-dark-10"
          style="width: 100%"
          @click="$emit('click', 'A')"
        >
          A
        </td>
      </tr>
    </table>
  </div>
</template>

<script>
export default {
  name: 'RichMenuPreview',
  components: {},
  props: {
    background: String,
    data: String,
    templateId: Number,
    typeTemplate: String
  }
};
</script>

<style lang="scss" scoped>
  ::v-deep {
    .justify-content-center {
      -webkit-box-pack: center !important;
      justify-content: center !important;
    }
    .btn-toolbar {
      margin-left: -5px;
    }
  }
</style>
