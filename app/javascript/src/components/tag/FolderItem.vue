<template>
  <div @click="changeSelected" :class="getClassName()">
    <div  class="d-flex align-items-center" v-if="!isEdit || !active">
      <span>
        <i :class="active? 'fas fa-folder-open': 'fas fa-folder'"></i>
        {{data.name}} ({{data.tags_count}})
      </span>
      <div class="dropdown" v-if="active && index!=0">
        <button type="button" class="btn dropdown-toggle btn-default action-tags" data-toggle="dropdown" aria-expanded="false">
          編集<span class="caret"></span>
        </button>
        <ul class="dropdown-menu" role="menu">
            <li role="presentation" @click.stop="changeName"><a role="menuitem" tabindex="-1">名前を変える</a></li>
            <li role="presentation" @click="deleteFolder"><a role="menuitem" tabindex="-1" data-toggle="modal" data-target="#modal-confirm-delete-folder">フォルダを削除</a></li>
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
  props: ['data', 'active', 'index'],
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
        this.$emit('editTag', { id: this.data.id, name: this.$refs.folderName.value });
      }
    },

    deleteFolder() {
      this.$emit('deleteTag', this.data);
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
    }

  }
};
</script>
<style lang="scss" scoped>
  .folder-item {
    cursor: pointer;
    padding: 10px;
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
