<template>
  <div class="container">
    <div class="row">
      <div class="col-md-8 col-md-offset-2">
        <div class="panel panel-linebot">
          <div class="panel-heading text-center mb20">
          </div>
          <div class="panel-body">
            <form class="form-horizontal" method="POST" action="">
              <div class="form-group">
                <div class="col-md-6 col-md-offset-3">
                  <input id="email" type="email" class="form-control input-login01" name="email" placeholder="メールアドレス" value="" required>
                </div>
              </div>

              <div class="form-group">
                <div class="col-md-6 col-md-offset-3">
                  <input id="password" type="password" class="form-control input-login02" name="password" placeholder="パスワード" required autocomplete="new-password">
                </div>
              </div>
              <div class="form-group">
                <div class="col-lg-12">
                  <button type="submit" class="btn btn-pink btn-block center-block mb5">
                      ログイン
                  </button>
                  <a class="text-center center-block green03 underline" href="">
                      <small>パスワードをお忘れの方はこちら</small>
                  </a>
                </div>
              </div>
            </form>
          </div>
        </div>
      </div>
    </div>
  </div>
</template>

<script>
export default {

}
</script>

<style>

</style>