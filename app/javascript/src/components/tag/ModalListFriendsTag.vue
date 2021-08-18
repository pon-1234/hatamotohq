<template>
  <div class="modal fade modal-common01" id="modal-friends-tag" tabindex="-1" role="dialog" aria-labelledby="myModalLabel" aria-hidden="true">
    <div class="modal-dialog" role="document">
      <div class="modal-content">
        <div class="modal-body">
          <button type="button" class="close" data-dismiss="modal" aria-label="Close">
            <span aria-hidden="true">&times;</span>
          </button>
          <label class="mb15">タグメンバー一覧</label>
          <div class="tbl-admin01 tbl-linebot01 table-responsive fz14 text-center">
            <table class="table table-hover">
              <thead>
                <tr>
                  <th class="w5">No.</th>
                  <th class="w40">名前</th>
                  <th class="w55">タグ一覧</th>
                </tr>
              </thead>
              <tbody v-if="friends && friends.length">
                 <tr  v-for="(item, index) in friends" v-bind:key="index">
                   <td>{{index+1}}</td>
                   <td ><div class="avatar-item"><img :src="item.line_customer.line_picture_url ? item.line_customer.line_picture_url : '/img/no-image-profile.png'"></div>{{item.line_customer.display_name ? item.line_customer.display_name:item.line_customer.line_name}}</td>
                   <td><span class="tag1 selected tag-selected" v-for="(tag, index) in item.tags" :key="index">{{tag.name}}</span></td>
                 </tr>
              </tbody>
            </table>
          </div>
        </div>
      </div>
    </div>
  </div>
</template>
<script>
export default {
  props: ['friends']
};
</script>
<style lang="scss" scoped>
  .table {
    max-width: 100%!important;
  }
  .avatar-item {
    width: 45px;
    height: 45px;
    background: #9a9a9a;
    border-radius: 50%;
    display: inline-block;
    margin-right: 5px;
    img {
        width: 100%;
        height: 100%;
        object-fit: cover;
        border-radius: 50%;
    }
  }

  .table-responsive {
    max-height: 400px!important;
    overflow: auto;
    height: 100%;
    margin-bottom: 0px!important;
    thead {
      border-bottom: none!important;
      th {
        background:#e0e0e0;
        border-bottom: none!important;
        position: sticky; top: 0;
      }
    }
  }
</style>
