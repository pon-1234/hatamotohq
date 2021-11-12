<template>
  <div class="fw-300">
    <div v-if="!isPerview">
      <div class="btn btn-success" @click="addMoreFolder">
        <i class="uil-plus"></i>
        新しいフォルダー
      </div>
    </div>
    <div class="mt-2" :class="!isPerview ? '' : 'tag-content-preview'">
      <table class="table table-centered mb-0">
        <thead class="thead-light">
          <tr>
            <th scope="col" class="fh-42">フォルダー</th>
          </tr>
        </thead>
      </table>
      <div class="d-flex m-0 overflow-auto flex-column folder-list">
        <div class="folder-item new-folder" v-if="isAddMoreFolder">
          <div class="input-group d-flex">
            <input
              type="text"
              placeholder="フォルダー名"
              class="form-control"
              v-model.trim="folderData.name"
              @click.stop
              ref="folderName"
              @keyup.enter="enterSubmitAddNewFolder"
              @compositionend="compositionend($event)"
              @compositionstart="compositionstart($event)"
              name="folder_name"
              maxlength="33"
              data-vv-as="フォルダー名"
              v-validate="'required|max:32'"
            />
            <span class="ml-auto">
              <div class="btn btn-default" @click="submitCreateFolder" ref="buttonChange">決定</div>
            </span>
          </div>
          <error-message :message="errors.first('folder_name')"></error-message>
        </div>

        <folder-left-item
          v-for="(item, index) in data || []"
          :type="type"
          :isPerview="isPerview"
          :data="item"
          :active="selectedFolder == index"
          :index="index"
          :key="index"
          @changeSelected="changeSelectedFolder(index)"
          @editTag="submitUpdateFolder"
        />

        <div class="text-center mt-4" v-if="data.length === 0">データはありません</div>
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

  created() {},

  methods: {
    changeSelectedFolder(index) {
      this.$emit('changeSelectedFolder', index);
    },

    submitUpdateFolder(value) {
      this.$emit('submitUpdateFolder', value);
    },

    addMoreFolder() {
      this.isAddMoreFolder = !this.isAddMoreFolder;
      this.folderData.name = '';
    },

    submitCreateFolder(e) {
      this.$validator.validateAll().then(passed => {
        if (!passed) return;
        if (this.folderData.name) {
          this.$emit('submitCreateFolder', this.folderData);
          this.isAddMoreFolder = false;
        }
      });
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
    min-height: 70vh;
    background: #f3f3f3;
  }

  .tag-content-preview {
    max-height: 500px !important;
    margin-top: 0px !important;
  }

  .tag-content {
    height: 85vh;
    background-color: #f0f0f0;
    overflow: hidden;
    display: flex;
    flex-direction: column;
  }

  .tag-content-left {
    padding-right: 0px !important;
    padding-left: 0px !important;
  }

  .table-tags-header {
    margin-bottom: 0px !important;
  }

  @media (max-width: 991px) {
    .item-pc {
      display: none !important;
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
