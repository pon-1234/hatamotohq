<template>
  <div tabindex="-1" role="dialog" aria-hidden="true" class="modal fade modal-common01" :id="id">
    <div class="modal-dialog modal-dialog-centered modal-md modal-rg" role="document">
      <div class="modal-content h-100 p-0">
        <div class="modal-header flex-shrink-0">
          <h5 class="mb-0" style="display: inline-block; margin: 0">チャンネルまたはメッセージを検索</h5>
          <button class="close" data-dismiss="modal">×</button>
        </div>

        <div class="modal-body mh-100 overflow-hidden" style="min-height: 160px">
          <div class="form-group">
            <input class="form-control" placeholder="ニックネームまたはメッセージの内容を入力してください" v-model="keyword">
          </div>
          <div class="form-group">
            <input-tag @input="selectTags" :allTags="true"/>
          </div>
        </div>
        <div class=" modal-footer" style="text-align: center">
          <button type="button" class="btn btn-secondary " data-dismiss="modal">キャンセル</button>
          <button type="button" class="btn btn-search" data-dismiss="modal" @click="search()">検索</button>
        </div>
      </div>
    </div>
  </div>
</template>

<script>
export default {
  props: ['id'],
  data() {
    return {
      type: 'keyword',
      keyword: null,
      tags: []
    };
  },

  methods: {
    search() {
      let tagStr = '';
      this.tags.forEach((tag) => {
        console.log(tag);
        if (tagStr.length > 0) {
          tagStr += '_';
        }
        tagStr += tag.id;
      });

      this.$emit('input', {
        type: this.type,
        keyword: this.keyword,
        tags: tagStr
      });
    },
    selectTags(tags) {
      this.tags = tags;
    }

  }
};
</script>

<style lang="scss" scoped>
::v-deep {
  .dropdown-tag {
    position: fixed !important;
    left: 14px;
  }
  .dropdown-tag.top{
    top: -195px !important;
  }
}

.btn-search {
  background: #00B900;
  color: white;
}
</style>
