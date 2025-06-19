<template>
  <div @click="focusForm" v-click-outside="blurInputTag" class="input-tag-container">
    <div class="tag-input-wrapper" :class="{ disabled: disabled }">
      <i
        :class="isFocus ? 'fas fa-angle-up float-r' : 'fas mdi mdi-chevron-down float-r'"
        class="down icon-action"
        @click.stop="showDropDown"
      ></i>
      <ul class="list-inline d-inline-block mb-2">
        <li v-for="tag in selectedTags" :key="tag.id" class="list-inline-item">
          <span class="tag-badge" :title="tag.name">
            {{ tag.name }}
            <button 
              v-if="!disabled"
              @click.stop="removeTag(tag)"
              class="tag-remove-btn"
              type="button"
              aria-label="削除"
            >
              <i class="fas fa-times"></i>
            </button>
          </span>
        </li>
      </ul>
      <input
        :disabled="disabled"
        v-model.trim="search"
        ref="inputTag"
        class="input-text-tag form-control"
        type="search"
        autocomplete="off"
        placeholder="タグ名を入力"
        @focus="focusForm"
      />
      <div class="w-100 dropdown-tag row" v-if="!disabled && isFocus" :class="{ top: isShowTop }">
        <div :class="leftTagClass">
          <div class="tag-content">
            <table class="table table-tags-header">
              <thead class="thead-light">
                <tr>
                  <th scope="col" style="height: 42px">フォルダー</th>
                </tr>
              </thead>
            </table>
            <div class="tag-scroll folder-list">
              <div
                v-for="(item, index) in folders"
                :key="index"
                :class="selectedFolderIndex === index ? 'folder-item active' : 'folder-item'"
                @click="changeSelected(index)"
              >
                <i :class="selectedFolderIndex === index ? 'fas fa-folder-open' : 'fas fa-folder'"></i>
                <span class="tag-label">{{ item.name }}</span> ({{ item.tags.length }})
              </div>
            </div>
          </div>
        </div>
        <div :class="rightTagClass">
          <div class="tag-content">
            <div class="x-tag-header">
              <div class="x-btn-back">
                <i style="margin: auto" class="fas fa-arrow-left item-sm" @click="backToFolder"></i>
              </div>
              <div class="x-title" v-if="curFolder">{{ curFolder.name }}</div>
            </div>

            <div class="tag-scroll tag-list" v-if="availableOptions && availableOptions.length">
              <div
                v-for="(item, index) in availableOptions"
                :key="index"
                :class="selectedTags.find((el) => el.id === item.id) ? 'folder-item active' : 'folder-item'"
                @click="onTagSelected(item)"
              >
                <span class="tag-label">{{ item.name }}</span>
                <span class="tag-choose item-hidden"><i class="fas fa-check"></i>選択</span>
                <span class="tag-checked item-hidden"><i class="fas fa-check"></i>選択中</span>
                <span class="tag-remove item-hidden"><i class="fas fa-times"></i>解除</span>
              </div>
            </div>
            <div v-else class="tag-scroll tag-empty-content text-center">空のデータ</div>
          </div>
        </div>
      </div>
    </div>
  </div>
</template>

<script setup>
import { ref, computed, watch, onBeforeMount, nextTick } from 'vue';
import { useStore } from 'vuex';
import ClickOutside from 'vue-click-outside';

// Props
const props = defineProps({
  tags: {
    type: Array,
    default: () => []
  },
  allTags: {
    type: Boolean,
    default: true
  },
  disabled: {
    type: Boolean,
    default: false
  },
  tagIds: {
    type: Array,
    default: () => []
  }
});

// Emits
const emit = defineEmits(['input']);

// Store
const store = useStore();

// Refs
const inputTag = ref(null);
const selectedFolderIndex = ref(0);
const isFocus = ref(false);
const search = ref('');
const selectedTags = ref([]);
const isPc = ref(true);

// Computed
const folders = computed(() => store.state.tag.folders);

const criteria = computed(() => search.value.trim().toLowerCase());

const curFolder = computed(() => folders.value[selectedFolderIndex.value]);

const availableOptions = computed(() => {
  const criteriaValue = criteria.value;
  const options = folders.value[selectedFolderIndex.value]?.tags || [];
  if (criteriaValue) {
    return options.filter(opt => opt.name.toLowerCase().indexOf(criteriaValue) > -1);
  }
  return options;
});

const isShowTop = computed(() => {
  if (!inputTag.value) return false;
  const rect = inputTag.value.getBoundingClientRect();
  return (
    document.documentElement.scrollHeight - (rect.top + window.scrollY) < 400 || 
    rect.top + window.scrollY < 100
  );
});

const leftTagClass = computed(() => {
  let className = 'col-md-5 tag-content-left';
  if (isPc.value) {
    className += ' item-pc';
  }
  return className;
});

const rightTagClass = computed(() => {
  let className = 'col-md-7 tag-content-right';
  if (!isPc.value) {
    className += ' item-pc';
  }
  return className;
});

// Methods
const getTags = () => store.dispatch('tag/getTags');

const changeSelected = (index) => {
  selectedFolderIndex.value = index;
  isPc.value = true;
};

const onTagSelected = (item) => {
  const index = selectedTags.value.findIndex(el => el.id === item.id);
  if (index > -1) {
    selectedTags.value.splice(index, 1);
  } else {
    selectedTags.value.push(item);
  }
  emit('input', selectedTags.value);
};

const removeTag = (tag) => {
  const index = selectedTags.value.findIndex(el => el.id === tag.id);
  if (index > -1) {
    selectedTags.value.splice(index, 1);
    emit('input', selectedTags.value);
  }
};

const focusForm = () => {
  isFocus.value = true;
  nextTick(() => {
    if (inputTag.value) {
      inputTag.value.focus();
    }
  });
};

const blurInputTag = () => {
  isFocus.value = false;
  search.value = '';
};

const showDropDown = () => {
  isFocus.value = !isFocus.value;
};

const backToFolder = () => {
  isPc.value = false;
};

const initData = () => {
  folders.value.forEach(({ tags }) => {
    tags.forEach(tag => {
      if (props.tagIds.includes(tag.id)) {
        selectedTags.value.push(tag);
        emit('input', selectedTags.value);
      }
    });
  });
};

// Lifecycle
onBeforeMount(async () => {
  await getTags();
  if (props.tags) {
    selectedTags.value = [...props.tags];
  }
  if (props.tagIds.length) {
    initData();
  }
});

// Watchers
watch(() => props.tags, (newTags) => {
  if (!newTags) return;
  selectedTags.value = [...newTags];
});

// Custom directives
const vClickOutside = ClickOutside.directive;
</script>

<style lang="scss" scoped>
  .input-tag-container {
    position: relative;
  }

  .tag-input-wrapper {
    position: relative;
    &.disabled {
      opacity: 0.65;
      pointer-events: none;
    }
  }

  .tag-badge {
    display: inline-flex;
    align-items: center;
    padding: 0.25rem 0.5rem;
    font-size: 0.875rem;
    font-weight: 700;
    line-height: 1;
    color: #fff;
    text-align: center;
    white-space: nowrap;
    vertical-align: baseline;
    border-radius: 0.25rem;
    background-color: #17a2b8;
    margin-right: 0.25rem;
    margin-bottom: 0.25rem;
  }

  .tag-remove-btn {
    background: none;
    border: none;
    color: #fff;
    cursor: pointer;
    padding: 0;
    margin-left: 0.5rem;
    font-size: 0.875rem;
    opacity: 0.8;
    &:hover {
      opacity: 1;
    }
  }

  .tag-label {
    overflow: hidden;
    white-space: nowrap;
    text-overflow: ellipsis;
  }

  .float-r {
    float: right;
  }

  .dropdown-tag {
    position: absolute;
    left: 0;
    right: 0;
    height: 300px;
    max-height: 300px;
    max-width: 450px;
    z-index: 9999;
    margin-top: 15px;
    background-color: #fff;
    background-clip: padding-box;
    border: 1px solid rgba(0, 0, 0, 0.15);
    border-radius: 0.25rem;
    min-width: 500px;
  }
  .dropdown-tag.top {
    top: -320px;
  }

  .down {
    top: 18px;
    position: absolute;
    right: 10px;
  }

  .input-text-tag {
    display: inline-block;
    max-width: 200px;
    padding-right: 0px !important;
    padding-left: 0px !important;
    border: none !important;
    margin-bottom: 0px;
    background: transparent;
    outline: none;
  }

  .tag-content-left,
  .tag-content-right {
    padding: 0px !important;
  }

  .table-tags-header {
    margin-bottom: 0px !important;
    max-width: none !important;
  }

  .item-sm {
    display: none;
  }

  .tag-empty-content {
    padding: 40px;
  }

  @media (max-width: 768px) {
    .dropdown-tag {
      min-width: initial;
    }
  }

  @media (max-width: 991px) {
    .item-pc {
      display: none !important;
    }

    .item-sm {
      display: inline-block !important;
    }

    .fa-arrow-left {
      margin-right: 10px;
      cursor: pointer;
    }
  }

  .badge {
    background-color: #f0ad4e !important;
  }

  .item-hidden {
    display: none;
    font-size: 12px;
    margin-left: auto;
    flex-direction: column;
    align-items: center;
    font-weight: bold;
    .fas {
      font-size: 14px;
    }
  }

  .folder-item {
    padding: 10px;
    height: 50px;
    min-height: 50px;
    line-height: 2;
    cursor: pointer;
    padding: 10px;
    display: flex;
    align-items: center;
    white-space: nowrap;
    overflow: hidden;
    min-width: 200px;
  }

  .folder-item:hover {
    background: #f0ad4e;
  }

  .folder-list {
    .active:hover {
      background-color: #fff3a0;
    }

    .active {
      background-color: #fff3a0;
    }
  }

  .tag-list {
    .active:hover {
      .tag-remove {
        display: flex !important;
      }
      .tag-checked {
        display: none !important;
      }

      .tag-choose {
        display: none !important;
      }
    }

    .active {
      .tag-checked {
        display: flex !important;
      }
    }

    .folder-item:hover {
      .tag-choose {
        display: flex;
      }
    }
  }

  .fa-folder {
    color: #fedc67;
  }

  .fa-folder-open {
    color: #f0ad4e;
  }

  .tag-content {
    height: 100%;
    max-height: 300px;
    overflow: hidden;
    display: flex;
    flex-direction: column;
    .tag-scroll {
      height: 100%;
      overflow-x: hidden;
      overflow-y: auto;
      margin: 0 0;
      display: flex;
      flex-direction: column;
    }
  }

  .icon-action {
    cursor: pointer;
  }
</style>
