<template>
  <div @click="changeSelected" :class="getClassName()">
    <div  class="d-flex align-items-center" v-if="!isEdit || !active">
      <i :class="active? 'fas fa-folder-open': 'fas fa-folder'"></i>
      <span class="title">
        {{data.name}}
      </span>
      <span>
         ({{data.flex_messages_count || 0}})
      </span>
      <div class="dropdown" v-if="active && !disableEditor && index > 0">
        <button type="button" class="btn dropdown-toggle btn-default action-tags" data-toggle="dropdown" aria-expanded="false">
          編集<span class="caret"></span>
        </button>
        <ul class="dropdown-menu" role="menu">
          <li role="presentation" @click.stop="changeName"><a role="menuitem" tabindex="-1">名前を変える</a></li>
          <li role="presentation" @click.stop="deleteFolder"><a role="menuitem" tabindex="-1">フォルダを削除</a></li>
        </ul>
      </div>
    </div>
    <div v-if="isEdit && active">
      <div class="input-group newgroup-inputs">
        <input type="text"  placeholder="フォルダ名" class="form-control" @click.stop :value="data.name" ref="folderName"
        @keyup.enter='enterSubmitChangeName'
        @compositionend="compositionend($event)"
        @compositionstart="compositionstart($event)"
        >
        <span class="input-group-btn">
            <button type="button" class="btn btn-default" @click="submitChangeName" ref="buttonChange">
              決定
            </button>
          </span>
      </div>
    </div>

  </div>
</template>
<script>
export default {
  props: ['data', 'active', 'index', 'disableEditor'],
  data() {
    return {
      isEdit: false,
      isEnter: true
    };
  },
  methods: {
    getClassName() {
      let className = 'folder-item ';
      if (this.active) {
        className += 'active';
      }

      return className;
    },

    changeName() {
      this.isEdit = true;
    },

    changeSelected() {
      this.isEdit = false;
      this.$emit('changeSelected', { index: this.index, folderId: this.data.id });
    },

    submitChangeName() {
      if (this.$refs.folderName.value !== this.data.name) {
        this.$emit('editFolder', { id: this.data.id, name: this.$refs.folderName.value });
      }
    },

    enterSubmitChangeName(e) {
      if (!this.isEnter) {
        this.isEnter = true;
        return;
      }
      this.$refs.buttonChange.click();
    },

    compositionend() {
      this.isEnter = false;
    },

    compositionstart() {
      this.isEnter = true;
    },

    deleteFolder() {
      this.$emit('deleteFolder', this.data);
    }
  }
};
</script>
<style lang="scss" scoped>
  .folder-item {
    cursor: pointer;
    padding: 10px;
  }

  .folder-item span.title{
    width: calc(100% - 110px);
    overflow: hidden;
    text-overflow: ellipsis;
    margin-right: 5px;
    margin-left: 5px;
    flex: 1;
    white-space: nowrap;

  }

  .active{
    background-color: #e0e0e0;
  }

  .fa-folder {
    color: #fedc67;
  }

  .fa-folder-open {
    color: #f0ad4e;
  }

  .action-tags {
    padding: 1px 5px;
    .caret {
      margin-left: 2px;
    }
  }

  .dropdown {
    margin-left: auto;
  }

  input {
    height: 36px!important;
  }
</style>
