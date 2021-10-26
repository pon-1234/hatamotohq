<template>
  <div :class="getClassName">
    <div class="d-flex align-items-center w-100" v-if="!isEdit || !active" @click="changeSelected">
      <span class="d-flex w-100 align-items-center">
        <i :class="active ? 'fas fa-folder-open' : 'fas fa-folder'"></i>
        <span style="vertical-align: middle; text-overflow: ellipsis; white-space: nowrap; overflow: hidden">{{
          data.name
        }}</span
        ><span>({{ childsCount }})</span>

        <div class="dropdown" v-if="active && data.name != '未分類' && !isPerview">
          <div class="btn-group">
            <div
              class="btn btn-light btn-sm dropdown-toggle dropdown-icon"
              data-toggle="dropdown"
              aria-expanded="false"
            >
              編集
            </div>
            <div class="dropdown-menu bg-white" role="menu">
              <a role="button" class="dropdown-item" @click.stop="changeName">名前を変える</a>
              <div class="dropdown-divider"></div>
              <a
                role="button"
                class="dropdown-item"
                data-toggle="modal"
                data-target="#modalDeleteFolder"
                @click="deleteFolder"
                >フォルダーを削除</a
              >
            </div>
          </div>
        </div>
      </span>
    </div>
    <div class="d-flex flex-column w-100" v-if="isEdit && active">
      <div class="d-flex align-items-center input-group">
        <input
          type="text"
          placeholder="フォルダー名"
          class="form-control"
          v-model.trim="folderName"
          @keyup.enter="enterSubmitChangeName"
          @compositionend="compositionend($event)"
          @compositionstart="compositionstart($event)"
          @click.stop
          maxlength="33"
          name="folder_name"
          data-vv-as="フォルダー名"
          v-validate="'required|max:32'"
        />
        <div class="btn btn-light btn-sm ml-auto" @click="submitChangeName" ref="buttonChange">決定</div>
      </div>
      <error-message :message="errors.first('folder_name')" v-if="errors.first('folder_name')"></error-message>
    </div>
  </div>
</template>
<script>
export default {
  props: ['data', 'active', 'index', 'type', 'isPerview'],
  data() {
    return {
      isEdit: false,
      isEnter: true,
      folderName: ''
    };
  },

  created() {
    this.folderName = this.data.name;
  },

  computed: {
    childsCount() {
      switch (this.type) {
      case 'tag':
        return this.data.tags.length;
      case 'scenario':
        return this.data.scenarios.length;
      case 'template_message':
        return this.data.templates.length;
      case 'rich_menu':
        return this.data.rich_menus.length;
      case 'auto_response':
        return this.data.auto_responses.length;
      case 'survey':
        return this.data.surveys.length;
      case 'variable':
        return this.data.variables.length;
      case 'reminder':
        return this.data.reminders.length;
      }
      return 0;
    },

    getClassName() {
      return 'folder-item ' + (this.active ? 'active' : '');
    }
  },
  methods: {
    changeName() {
      this.isEdit = true;
    },

    changeSelected() {
      this.isEdit = false;
      this.folderName = this.data.name;

      this.$emit('changeSelected', { index: this.index, folderId: this.data.id });
    },

    submitChangeName() {
      this.$validator.validateAll().then(passed => {
        if (!passed) {
          return;
        }
        this.isEdit = false;
        if (this.folderName !== this.data.name) {
          this.$emit('editTag', { id: this.data.id, name: this.folderName });
        }
      });
    },

    enterSubmitChangeName(e) {
      if (!this.isEnter) {
        this.isEnter = true;
        return;
      }
      this.$refs.buttonChange.click();
    },

    deleteFolder() {
      this.$emit('deleteTag');
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
    display: flex;
    cursor: pointer;
    padding: 10px;
    min-height: 55px !important;
  }
  .active {
    background-color: #e0e0e0;
  }

  .fa-folder {
    color: #fedc67;
  }

  .fa-folder-open {
    color: #f0ad4e;
  }

  .fa-folder::before,
  .fa-folder-open::before {
    margin-right: 5px;

    vertical-align: sub;
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
    height: 36px !important;
  }
</style>
