<template>
  <select v-model="selected" class="form-control w-50">
    <option v-for="(item, index) in options" :key="index" :value="item.value">
      {{ item.text }}
    </option>
  </select>
</template>
<script>
export default {
  props: {
    value: {
      type: Number,
      default: 13
    }
  },
  data() {
    return {
      options: [
        { text: 'テキストメッセージ', value: 1 },
        { text: 'スタンプメッセージ', value: 2 },
        { text: '画像メッセージ', value: 3 },
        { text: '動画メッセージ', value: 4 },
        { text: '音声メッセージ', value: 5 },
        { text: '位置情報メッセージ', value: 6 },
        { text: 'イメージマップメッセージ', value: 7 }, // imagemap
        { text: 'ボタンメッセージ', value: 8 },
        { text: '確認メッセージ', value: 9 },
        { text: 'カルーセルメッセージ', value: 10 },
        { text: '画像カルーセルメッセージ', value: 11 }
        // { text: 'Flexメッセージ', value: 12 }
      ]
    };
  },
  created() {
    // this.$emit('input', 7);
  },
  computed: {
    selected: {
      get() {
        return this.value;
      },
      set(val) {
        this.$emit('input', val);
      }
    }
  }
};
</script>
