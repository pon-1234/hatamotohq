<template>
  <div class="modal fade" id="modalAnnouncementDetail" tabindex="-1" role="dialog" aria-hidden="true" data-keyboard="false">
    <div class="modal-dialog modal-lg modal-dialog-scrollable" role="document">
      <div class="modal-content">
        <div class="modal-header">
          <h5 class="modal-title" id="info-header-modalLabel">お知らせ詳細</h5>
          <button type="button" class="close" data-dismiss="modal" aria-label="Close">
              <span aria-hidden="true">&times;</span>
          </button>
        </div>
        <div class="modal-body" v-if="announcement">
          <h3 class="text-center">{{ announcement.title }}</h3>
          <section class="page-content">
            <div class="page-content__inner c-grid">
              <div id="output" class="" v-html="normalize(announcement.body)"></div>
            </div>
          </section>
        </div>
        <div class="modal-footer" >
          <button type="button" class="btn btn-light" data-dismiss="modal">閉じる</button>
        </div>
      </div>
    </div>
  </div>
</template>
<script>
export default {
  props: ['announcement'],

  methods: {
    normalize(body) {
      if (body && body.includes('<oembed')) {
        body = body.replaceAll('oembed', 'iframe');
        body = body.replaceAll('url', 'src');
        body = body.replaceAll('watch?v=', 'embed/');
      }
      return body;
    }
  }
};
</script>

<style lang="scss" scoped>
  .page-content__inner {
    padding-bottom: 100px
  }
  .c-grid {
    width: 100%;
    max-width: 1180px;
    padding-left: 40px;
    padding-right: 40px;
    margin: 0 auto;
    box-sizing: border-box
  }
  @media screen and (max-width:768px) {
    .page-content__inner {
      padding-bottom: 50px
    }
    .c-grid {
      padding-left: 20px;
      padding-right: 20px
    }
  }

  ::v-deep {
    .image-style-side,
    .image-style-align-left,
    .image-style-align-center,
    .image-style-align-right {
      max-width: 50%;
    }
    .image-style-side {
      float: right;
      margin-left: 1.5em;
    }
    .image-style-align-left {
      float: left;
      margin: 40px 5% 0 0!important;
    }
    .image,
    .image-style-align-center {
      margin-left: auto;
      margin-right: auto;
    }
    .image-style-align-right {
      float: right;
      margin: 40px 0 0 5%!important;
    }
    .image.image_resized {
      max-width: 100%;
      display: block;
      box-sizing: border-box;
      img {
        width: 100%;
      }
      figcaption {
        display: block;
      }
    }
    .image {
      display: table;
      clear: both;
      text-align: center;
      img {
        display: block;
        margin: 0 auto;
        max-width: 100%;
        min-width: 50px;
      }
      figcaption {
        display: table-caption;
        caption-side: bottom;
        word-break: break-word;
        color: hsl(0, 0%, 20%);
        background-color: hsl(0, 0%, 97%);
        padding: .6em;
        font-size: .75em;
        outline-offset: -1px;
      }
    }
    .raw-html-embed {
      p {
        display: flex;
      }
      a {
        img {
          width: 100%;
          max-width: 100%!important;
          border: none!important;
        }
      }
    }
    #output figure.media {
      width: 100%;
      height: 500px;
      clear: both;
      iframe {
        width: 100%;
        height: 100%;
      }
    }
  }

  #output {
    margin: 50px auto 0;
    box-sizing: border-box;
    background: #ffffff;
    font-feature-settings: 'palt' 1;
  }
  @media screen and (max-width: 768px) {
    #output {
      margin: 30px auto 0;
    }
  }
</style>