<template>
  <div class="col">
    <div class="row">
      <div class="col-sm-6">
        <table class="table table-bordered table-striped mt-3">
          <tbody>
            <tr>
              <th>登録日</th>
              <td>{{ siteDetail.created_at | formatted_time_without_minute }}</td>
            </tr>
          </tbody>
        </table>
      </div>
    </div>
    <hr class="mb-4" />
    <h4 class="font-weight-normal">統計(配信)</h4>
    <div class="row">
      <div class="col-sm-6">
        <table class="table table-striped">
          <thead>
            <tr>
              <th>URLクリック数</th>
              <td></td>
            </tr>
          </thead>
          <tbody>
            <tr>
              <th>URL送信回数</th>
              <td>{{siteDetail.sending_count}}回</td>
            </tr>
            <tr>
              <th>総クリック数</th>
              <td>{{siteDetail.click_count}}回</td>
            </tr>
            <tr>
              <th>クリック数／送信回数</th>
              <td>{{(siteDetail.click_count / siteDetail.sending_count) | numberToPercent}}</td>
            </tr>
          </tbody>
        </table>
      </div>
      <div class="col-sm-6">
        <table class="table table-striped">
          <thead>
            <tr>
              <th>クリック人数</th>
              <td></td>
            </tr>
          </thead>
          <tbody>
            <tr>
              <th>URL送信人数</th>
              <td>{{siteDetail.receiver_count}}人</td>
            </tr>
            <tr>
              <th>訪問人数</th>
              <td>{{siteDetail.visitor_count}}人</td>
            </tr>
            <tr>
              <th>訪問人数／友だち総数</th>
              <td>{{(siteDetail.visitor_count / siteDetail.friendTotal) | numberToPercent}}</td>
            </tr>
          </tbody>
        </table>
      </div>
    </div>
  </div>
</template>
<script>
export default {
  props: ['siteDetail']
};
</script>
<style lang="scss" scoped>
</style>
