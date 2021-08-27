<template>
  <div class="modal fade modal-tag modal-common01" id="modal-tag" tabindex="-1" role="dialog" aria-labelledby="myModalLabel" aria-hidden="true" style="display: none;">
    <div class="modal-dialog" role="document">
        <div class="modal-content">
            <div class="modal-body">
                <button type="button" class="close" data-dismiss="modal" aria-label="Close"><span aria-hidden="true">×</span></button>
                <label class="mb5">設定タグ一覧</label>
                <ul class="list-tag list-unstyled no-mgn">
                    <li class="tag" v-for="(item, index) in tags" :key="index">{{item.name}}</li>
                </ul>
            </div>
        </div>
    </div>
  </div>
</template>
<script>
export default {
  props: ['tags']
};
</script>
<style lang="scss" scoped>
.tag {
  margin-right: 5px;
}
</style>
