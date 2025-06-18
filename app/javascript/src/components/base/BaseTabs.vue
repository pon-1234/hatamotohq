<template>
  <div class="base-tabs">
    <!-- Tab Navigation -->
    <ul class="nav" :class="navClasses" role="tablist">
      <li
        v-for="(tab, index) in tabs"
        :key="tab.id || index"
        class="nav-item"
        role="presentation"
      >
        <button
          class="nav-link"
          :class="{ 
            active: currentTabIndex === index,
            disabled: tab.disabled 
          }"
          :id="`tab-${_uid}-${index}`"
          type="button"
          role="tab"
          :aria-controls="`panel-${_uid}-${index}`"
          :aria-selected="currentTabIndex === index"
          :disabled="tab.disabled"
          @click="selectTab(index)"
        >
          <i v-if="tab.icon" :class="tab.icon" class="mr-1"></i>
          {{ tab.title }}
        </button>
      </li>
    </ul>

    <!-- Tab Content -->
    <div class="tab-content" :class="contentClass">
      <div
        v-for="(tab, index) in tabs"
        :key="tab.id || index"
        class="tab-pane"
        :class="{ 
          show: currentTabIndex === index,
          active: currentTabIndex === index,
          fade: fade
        }"
        :id="`panel-${_uid}-${index}`"
        role="tabpanel"
        :aria-labelledby="`tab-${_uid}-${index}`"
      >
        <slot :name="tab.slot || `tab-${index}`" />
      </div>
    </div>
  </div>
</template>

<script>
export default {
  name: 'BaseTabs',
  props: {
    value: {
      type: Number,
      default: 0
    },
    tabs: {
      type: Array,
      required: true,
      validator: (tabs) => {
        return tabs.every(tab => tab.title);
      }
    },
    pills: {
      type: Boolean,
      default: false
    },
    fill: {
      type: Boolean,
      default: false
    },
    justified: {
      type: Boolean,
      default: false
    },
    vertical: {
      type: Boolean,
      default: false
    },
    small: {
      type: Boolean,
      default: false
    },
    fade: {
      type: Boolean,
      default: true
    },
    navClass: {
      type: String,
      default: ''
    },
    contentClass: {
      type: String,
      default: ''
    }
  },
  data() {
    return {
      currentTabIndex: this.value
    };
  },
  computed: {
    navClasses() {
      return [
        this.pills ? 'nav-pills' : 'nav-tabs',
        {
          'nav-fill': this.fill,
          'nav-justified': this.justified,
          'flex-column': this.vertical,
          'small': this.small
        },
        this.navClass
      ];
    }
  },
  watch: {
    value(newVal) {
      this.currentTabIndex = newVal;
    },
    currentTabIndex(newVal) {
      this.$emit('input', newVal);
      this.$emit('change', newVal);
    }
  },
  mounted() {
    // Find initially active tab
    const activeIndex = this.tabs.findIndex(tab => tab.active);
    if (activeIndex >= 0) {
      this.currentTabIndex = activeIndex;
    }
  },
  methods: {
    selectTab(index) {
      if (!this.tabs[index].disabled) {
        this.currentTabIndex = index;
      }
    },
    nextTab() {
      let nextIndex = this.currentTabIndex + 1;
      while (nextIndex < this.tabs.length && this.tabs[nextIndex].disabled) {
        nextIndex++;
      }
      if (nextIndex < this.tabs.length) {
        this.selectTab(nextIndex);
      }
    },
    previousTab() {
      let prevIndex = this.currentTabIndex - 1;
      while (prevIndex >= 0 && this.tabs[prevIndex].disabled) {
        prevIndex--;
      }
      if (prevIndex >= 0) {
        this.selectTab(prevIndex);
      }
    }
  }
};
</script>

<style scoped>
.base-tabs {
  width: 100%;
}

.nav {
  display: flex;
  flex-wrap: wrap;
  padding-left: 0;
  margin-bottom: 0;
  list-style: none;
}

.nav-tabs {
  border-bottom: 1px solid #dee2e6;
}

.nav-tabs .nav-item {
  margin-bottom: -1px;
}

.nav-tabs .nav-link {
  border: 1px solid transparent;
  border-top-left-radius: 0.25rem;
  border-top-right-radius: 0.25rem;
  background: none;
  padding: 0.5rem 1rem;
  color: #495057;
  text-decoration: none;
  transition: color 0.15s ease-in-out, background-color 0.15s ease-in-out, border-color 0.15s ease-in-out;
}

.nav-tabs .nav-link:hover {
  border-color: #e9ecef #e9ecef #dee2e6;
  color: #495057;
}

.nav-tabs .nav-link.disabled {
  color: #6c757d;
  background-color: transparent;
  border-color: transparent;
  cursor: not-allowed;
}

.nav-tabs .nav-link.active {
  color: #495057;
  background-color: #fff;
  border-color: #dee2e6 #dee2e6 #fff;
}

.nav-pills .nav-link {
  border-radius: 0.25rem;
  background: none;
  border: none;
  padding: 0.5rem 1rem;
  color: #007bff;
  text-decoration: none;
  transition: color 0.15s ease-in-out, background-color 0.15s ease-in-out;
}

.nav-pills .nav-link.active {
  color: #fff;
  background-color: #007bff;
}

.nav-pills .nav-link:hover {
  color: #0056b3;
}

.nav-fill .nav-item {
  flex: 1 1 auto;
  text-align: center;
}

.nav-justified .nav-item {
  flex-basis: 0;
  flex-grow: 1;
  text-align: center;
}

.flex-column {
  flex-direction: column;
}

.flex-column .nav-link {
  width: 100%;
}

.small .nav-link {
  padding: 0.25rem 0.5rem;
  font-size: 0.875rem;
}

.tab-content {
  padding: 1rem 0;
}

.tab-pane {
  display: none;
}

.tab-pane.show {
  display: block;
}

.tab-pane.fade {
  transition: opacity 0.15s linear;
}

.tab-pane.fade:not(.show) {
  opacity: 0;
}

/* Vertical tabs layout */
.base-tabs:has(.flex-column) {
  display: flex;
}

.base-tabs:has(.flex-column) .nav {
  width: 200px;
  border-bottom: none;
  border-right: 1px solid #dee2e6;
  margin-bottom: 0;
  margin-right: 1rem;
}

.base-tabs:has(.flex-column) .tab-content {
  flex: 1;
  padding: 0 0 0 1rem;
}
</style>