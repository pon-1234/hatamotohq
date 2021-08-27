<template>
  <div class="input-wrapper">
    <input
      v-model.trim="currentValue"
      :class="classes"
      :type="type"
      :placeholder="placeholder"
      @focus="showSuggest"
      @blur="onFocus = false"
      @keyup="showSuggest"
      v-validate="validate"
      @change="change"
      :name="name"
    />
    <transition name="fade">
      <div
        class="recent-contents"
        v-if="show || onFocus"
        v-click-outside="hideSuggest"
      >
        <div class="recent-contents-list">
          <span
            class="content suggest-contents"
            v-for="(v, i) in suggestList"
            @click="inputFromSuggest(v)"
            :key="i"
            >{{ v }}</span
          >
        </div>
      </div>
    </transition>
  </div>
</template>
<script>
import ClickOutside from 'vue-click-outside';
export default {
  directives: {
    ClickOutside
  },
  inject: ['parentValidator'],
  props: {
    validate: {
      type: Object,
      required: false
    },
    value: {
      type: String,
      required: false
    },
    name: {
      type: String,
      required: false,
      default: 'default_name'
    },
    list: {
      type: Array,
      required: true
    },
    placeholder: {
      type: String,
      required: false,
      default: 'pxまたはキーワード'
    },
    classes: {
      type: String,
      required: false
    },
    type: {
      type: String,
      required: false,
      default: 'text'
    }
  },
  data() {
    return {
      show: false,
      onFocus: false,
      currentValue: this.value,
      suggestList: []
    };
  },
  created() {
    this.$validator = this.parentValidator;
  },
  methods: {
    hideSuggest() {
      if (!this.onFocus) {
        this.show = false;
      }
    },
    inputFromSuggest(v) {
      this.currentValue = v;
      this.hideSuggest();
      this.change();
    },
    showSuggest() {
      const temp = this.currentValue.trim();
      if (temp === '') {
        this.suggestList = this.list;
      } else {
        this.suggestList = this.list.filter((item) => {
          return item.toLowerCase().indexOf(temp.toLowerCase()) !== -1;
        });
      }
      this.show = this.suggestList.length;
      this.onFocus = true;
    },
    change() {
      this.$emit('change', this.currentValue);
    }
  }
};
</script>
<style lang="scss" scoped>
.input-wrapper {
  position: relative;
  display: inline-block;
  width: 100%;

  .recent-contents {
    padding: 8px 10px;
    font-size: 14px;
    letter-spacing: 0;
    max-height: 200px;
    overflow-y: auto;
    background-color: #ffffff;
    position: absolute;
    border: 1px solid #ccd0d2;
    border-radius: 5px;
    z-index: 1;
    width: 100%;
    left: 0;
    top: 40px;

    .recent-contents-list {
      .suggest-contents {
        cursor: pointer;
      }
    }
  }

  .content {
    display: flex;
    &:not(:last-child) {
      margin-bottom: 8px;
    }
  }

  .fade-enter-active,
  .fade-leave-active {
    transition: opacity 0.5s;
  }
  .fade-enter, .fade-leave-to /* .fade-leave-active below version 2.1.8 */ {
    opacity: 0;
  }
}
</style>
