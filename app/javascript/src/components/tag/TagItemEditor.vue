<template>
  <div class="folder-item">
    <div  class="d-flex align-items-center" v-if="!isEdit">
      <span class="flex-grow-1">
        {{data.name}}
      </span>
      <div class="btn-group flex-1">
        <button type="button" class="btn btn-primary" @click="changeName">編集</button>
        <button type="button" class="btn btn-primary dropdown-toggle dropdown-icon" data-toggle="dropdown" aria-expanded="false"></button>
        <div class="dropdown-menu" role="menu" style="">
            <a class="dropdown-item" @click="changeName">名前を変える</a>
            <div class="dropdown-divider"></div>
            <a class="dropdown-item" @click="deleteFolder" data-toggle="modal" data-target="#modalConfirmDelTag">タグを削除</a>
          </div>
      </div>
    </div>
    <div v-if="isEdit">
      <div class="input-group newgroup-inputs">
        <input type="text"  placeholder="フォルダ名" class="form-control" @click.stop :value="data.name" ref="tagName"
          @keyup.enter='enterSubmitChangeName'
          @compositionend="compositionend($event)"
          @compositionstart="compositionstart($event)"
         >
        <span class="input-group-btn">
          <button type="button" class="btn btn-default" @click="submitChangeName"  ref="buttonChange">
            決定
          </button>
        </span>
      </div>
    </div>
  </div>
</template>
<script>
export default {
  props: ['data'],
  data() {
    return {
      isEdit: false,
      isEnter: true
    };
  },
  methods: {
    changeName() {
      this.isEdit = true;
    },

    submitChangeName() {
      if (this.$refs.tagName.value !== this.data.name) {
        this.$emit('editTag', { id: this.data.id, name: this.$refs.tagName.value });
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
    color: white;
    .caret {
      margin-left: 2px;
    }
  }

  input {
    height: 36px!important;
  }
</style>
