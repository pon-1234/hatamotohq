<template>
  <div>
    <div class="d-flex align-items-center" v-if="!isEdit">
      <span class="flex-grow-1">
        {{ data.name }}
      </span>
      <div class="btn-group flex-1">
        <button type="button" class="btn btn-light btn-sm dropdown-toggle" data-toggle="dropdown" aria-expanded="false">
          操作 <span class="caret"></span>
        </button>
        <div class="dropdown-menu" role="menu" style="">
          <a class="dropdown-item" @click="changeName">タグ名を変える</a>
          <div class="dropdown-divider"></div>
          <a class="dropdown-item" @click="deleteFolder" data-toggle="modal" data-target="#modalConfirmDelTag"
            >タグを削除</a
          >
        </div>
      </div>
    </div>
    <div v-if="isEdit">
      <div class="input-group newgroup-inputs">
        <input
          type="text"
          placeholder="タグ名"
          class="form-control"
          @click.stop
          v-model.trim="tagName"
          @keyup.enter="enterSubmitChangeName"
          @compositionend="compositionend($event)"
          @compositionstart="compositionstart($event)"
          name="tag_name"
          data-vv-as="タグ名"
          maxlength="33"
          v-validate="'required|max:32'"
        />
        <span class="input-group-btn">
          <button type="button" class="btn btn-light" @click="submitChangeName" ref="buttonChange">決定</button>
        </span>
      </div>
      <error-message :message="errors.first('tag_name')"></error-message>
    </div>
  </div>
</template>
<script>
export default {
  props: ['data'],
  data() {
    return {
      isEdit: false,
      isEnter: true,
      tagName: null
    };
  },

  watch: {
    data(val) {
      this.tagName = val.name;
    }
  },

  created() {
    this.tagName = this.data.name;
  },

  methods: {
    changeName() {
      this.isEdit = true;
    },

    async submitChangeName() {
      const passed = await this.$validator.validateAll();
      if (!passed) return;
      if (this.tagName !== this.data.name) {
        this.$emit('editTag', { id: this.data.id, name: this.tagName });
      }

      this.isEdit = false;
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
  .active {
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
    color: white;
    .caret {
      margin-left: 2px;
    }
  }

  input {
    height: 36px !important;
  }
</style>
