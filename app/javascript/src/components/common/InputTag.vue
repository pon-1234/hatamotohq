<template>
  <div @click="focusForm" v-click-outside="blurInputTag">
    <b-form-tags v-model="value" no-outer-focus class="mb-2 position-relative"  :add-button-text="'追加'" remove-on-delete>
      <template v-slot="{ tags, disabled, addTag }" >
        <i :class="isFocus?'fas fa-angle-up float-r':'fas fa-angle-down float-r'" class="down icon-action" @click.stop="showDropDown"></i>
        <ul v-if="tags.length > 0" class="list-inline d-inline-block mb-2">
          <li v-for="tag in tags" :key="tag" class="list-inline-item">
            <b-form-tag
              @remove="removeTag(tag, addTag)"
              :title="tag"
              :disabled="disabled"
              variant="info"
            >{{ tag }}</b-form-tag>
          </li>
        </ul>
        <b-form-input
          v-model="search"
          ref="inputTag"
          class="input-text-tag "
          type="search"
          autocomplete="off"
          placeholder="タグ名を入力"
          ></b-form-input>
        <div class="w-100 dropdown-tag row" v-if="isFocus" :class="{top: isShowTop()}">
          <div :class="getClassLeftTag()">
            <div class="tag-content">
              <table class="table table-tags-header">
                <thead class="thead-light">
                  <tr>
                    <th scope="col" style="height: 42px">フォルダ</th>
                  </tr>
                </thead>
              </table>
              <div class="tag-scroll folder-list">
                <div v-for="(item, index) in tags_options" :key="index" :class="selected_folder== index? 'folder-item active':'folder-item'" @click="changeSelected(index)">
                  <i :class="selected_folder== index? 'fas fa-folder-open': 'fas fa-folder'"></i>
                  <span class="tag-label">{{item.name}}</span> ({{item.tags.length}})
                </div>
              </div>
            </div>
          </div>
          <div :class="getClassRightTag()">
            <div class="tag-content">
              <!--<table class="table table-tags-header">-->
                <!--<thead>-->
                <!--<tr>-->
                  <!--<th class="w5" style="height: 42px"><i class="fas fa-arrow-left item-sm" @click="backToFolder"></i></th>-->
                  <!--<th v-if="tags_options[selected_folder]">{{tags_options[selected_folder].name}}</th>-->
                <!--</tr>-->
                <!--</thead>-->
              <!--</table>-->
              <div class="x-tag-header">
                <div class="x-btn-back">
                  <i style="margin: auto" class="fas fa-arrow-left item-sm" @click="backToFolder"></i></div>
                <div class="x-title"
                      v-if="tags_options[selected_folder]">{{tags_options[selected_folder].name}}</div>
              </div>

              <div class="tag-scroll tag-list" v-if="availableOptions && availableOptions.length">
                <div v-for="(item, index) in availableOptions"
                  :key="index" :class="selected_tag.find(el=>el.id === item.id)? 'folder-item active':'folder-item'"
                  @click="changeSelectedTag({item, addTag})">
                  <span class="tag-label">{{item.name}}</span> <span class="tag-choose item-hidden"><i class="fas fa-check"></i>選択</span> <span class="tag-checked item-hidden"><i class="fas fa-check"></i>選択中</span> <span class="tag-remove item-hidden"><i class="fas fa-times"></i>解除</span>
                </div>
              </div>
              <div v-else class="tag-scroll tag-empty-content text-center">
                空のデータ
              </div>
            </div>
          </div>
        </div>
      </template>
    </b-form-tags>
  </div>
</template>

<script>
import { mapState } from 'vuex';
import ClickOutside from 'vue-click-outside';

export default {
  props: ['data', 'allTags'],
  data() {
    return {
      value: [],
      selected_folder: 0,
      isFocus: false,
      search: '',
      selected_tag: [],
      isPc: true
    };
  },
  created() {
    if (this.data) {
      // eslint-disable-next-line no-undef
      this.selected_tag = _.cloneDeep(this.data);
      this.selected_tag.forEach(element => {
        this.value.push(element.name);
      });
    }
  },
  computed: {
    ...mapState('tag', {
      tags_options(state) {
        return this.allTags ? state.tags : state.tagsAssigned;
      }
    }),

    criteria() {
      return this.search.trim().toLowerCase();
    },

    availableOptions() {
      const criteria = this.criteria;
      const options = this.tags_options[this.selected_folder].tags;
      if (criteria) {
        return options.filter(opt => opt.name.toLowerCase().indexOf(criteria) > -1);
      }

      return options;
    }
  },

  directives: {
    ClickOutside
  },

  methods: {
    isShowTop() {
      const rect = this.$refs.inputTag.$el.getBoundingClientRect();
      return document.documentElement.scrollHeight - (rect.top + window.scrollY) < 400 || (rect.top + window.scrollY) < 100;
    },
    changeSelected(index) {
      this.selected_folder = index;
      this.isPc = true;
    },

    changeSelectedTag({ item, addTag }) {
      if (this.selected_tag.find(el => el.id === item.id)) {
        this.selected_tag = this.selected_tag.filter(el => el.id !== item.id);
        this.value = this.value.filter(el => el !== item.name);
      } else {
        this.selected_tag.push(item);
        this.value.push(item.name);
      }
      this.$emit('input', this.selected_tag);
      addTag();
    },

    removeTag(name, addTag) {
      this.value = this.value.filter(el => el !== name);
      this.selected_tag = this.selected_tag.filter(el => el.name !== name);
      addTag();
      this.$emit('input', this.selected_tag);
    },

    focusForm() {
      this.isFocus = true;
      if (this.$refs.inputTag) {
        this.$refs.inputTag.focus();
      }
    },

    blurInputTag() {
      this.isFocus = false;
      this.search = '';
    },

    showDropDown() {
      this.isFocus = !this.isFocus;
    },

    getClassLeftTag() {
      let className = 'col-md-5 tag-content-left';

      if (this.isPc) {
        className += ' item-pc';
      }
      return className;
    },

    getClassRightTag() {
      let className = 'col-md-7 tag-content-right';

      if (!this.isPc) {
        className += ' item-pc';
      }

      return className;
    },

    backToFolder() {
      this.isPc = false;
    }

  }
};
</script>
<style lang="scss" scoped>

.tag-label {
  overflow: hidden;
  white-space: nowrap;
  text-overflow: ellipsis;
}

.b-form-tag {
  font-weight: bold;
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
  border: 1px solid rgba(0, 0, 0, .15);
  border-radius: .25rem;
  min-width: 500px;
}
.dropdown-tag.top{
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
  padding-right: 0px!important;
  padding-left: 0px!important;
  border: none !important;;
  margin-bottom: 0px;
}

.d-inline-block {
  display: contents;
}

.tag-content-left, .tag-content-right {
  padding: 0px!important;
}

.table-tags-header {
  margin-bottom: 0px!important;
  max-width: none!important;
}

.item-sm {
  display: none;
}

.tag-empty-content {
  padding: 40px;
}

@media (max-width: 768px) {
  .dropdown-tag{
    min-width: initial;
  }

}

@media (max-width: 991px) {
  .item-pc {
    display: none!important;
  }

  .item-sm {
    display: inline-block!important;
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

  .icon-action{
    cursor: pointer;
  }
</style>
