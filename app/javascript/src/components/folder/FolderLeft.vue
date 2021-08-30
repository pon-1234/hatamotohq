<template>
  <div :class="getClassLeftTag()">
    <div class="tag-header" v-if="!isPerview">
      <div class="add_group btn  btn-success" @click="addMoreFolder">
        <i class="glyphicon glyphicon-plus"></i>
          新しいフォルダ
      </div>
    </div>
    <div class="tag-content" :class="!isPerview?'':'tag-content-preview'">
      <div class="folder-list-title">
        <table class="table table-tags-header">
          <thead class="thead-light">
            <tr>
              <th scope="col" style="height: 42px;">フォルダ</th>
            </tr>
          </thead>
        </table>
      </div>
      <div class="tag-scroll folder-list">
        <div class="folder-item new-folder" v-if="isAddMoreFolder">
          <div class="input-group newgroup-inputs">
          <input type="text"
            placeholder="フォルダ名"
            v-model="folderData.name" class="form-control"
            @click.stop ref="folderName"
            @keyup.enter='enterSubmitAddNewFolder'
            @compositionend="compositionend($event)"
            @compositionstart="compositionstart($event)"
            >
            <span class="input-group-btn">
              <button type="button" class="btn btn-default" @click="submitAddNewFolder" ref="buttonChange">
                決定
              </button>
            </span>
          </div>
        </div>

        <folder-left-item
          v-for="(item, index) in (data || [])"
          :type="type"
          :isPerview="isPerview"
          :data="item"
          :active="selectedFolder == index"
          :index="index"
          :key="index"
          @changeSelected="changeSelectedFolder(index)"
          @editTag="submitEditFolder"
          />
      </div>
    </div>
  </div>
</template>
<script>
export default {
  props: ['isPc', 'data', 'selectedFolder', 'type', 'isPerview'],
  data() {
    return {
      isAddMoreFolder: false,
      folderData: {
        type: this.type || '',
        name: null
      },
      isEnter: true
    };
  },

  created() {
  },

  methods: {
    changeSelectedFolder(index) {
      this.$emit('changeSelectedFolder', index);
    },

    getClassLeftTag() {
      let className = 'col-md-4 tag-content-left';

      if (this.isPc) {
        className += ' item-pc';
      }
      return className;
    },

    submitEditFolder(value) {
      this.$emit('submitEditFolder', value);
    },

    addMoreFolder() {
      this.isAddMoreFolder = !this.isAddMoreFolder;
      this.folderData.name = '';
    },

    submitAddNewFolder(e) {
      if (this.folderData.name) {
        this.$emit('submitAddNewFolder', this.folderData);
        // this.folderData.name = '';
        this.isAddMoreFolder = false;
      }
    },

    enterSubmitAddNewFolder(e) {
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

.folder-list {
  border-right: thin solid #ccc;
}

.tag-header {
  height: 40px;
  color: white;
  button {
    color: black!important;
  }
}

.tag-content-preview {
  max-height: 500px!important;
  margin-top: 0px!important;
}

.tag-content {
  height: 85vh;
  background-color: #f0f0f0;
  margin-top: 10px;
  overflow: hidden;
  display: flex;
  flex-direction: column;
  .tag-scroll {
    height: 100%;
    overflow-y: auto;
    overflow-x: auto;
    margin: 0 0;
    display: flex;
    flex-direction: column;
  }
}

.tag-content-left {
  padding-right: 0px!important;
  padding-left: 0px!important;
}

.table-tags-header {
  margin-bottom: 0px!important;
}

@media (max-width: 991px) {
  .item-pc {
    display: none!important;
  }

  .tag-scroll {
    overflow: hidden;
  }
}

.new-folder {
  background: #fff3a0 !important;
  padding: 10px;
}

</style>
