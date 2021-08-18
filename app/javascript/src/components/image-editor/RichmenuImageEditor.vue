<template>
  <div>
    <div class="editor-content">
      <div style="display: flex; flex-direction: column; background: rgb(245, 245, 245); max-width: 300px;">
        <div class="line-nav-bar">
          <p v-if="editor==='richmenu'">リッチメニュー</p>
          <p v-else>BOT</p>
        </div>
        <div class="bg-text-mess" :style="styleAuto()">
        </div>
        <div v-if="editor==='richmenu'">
          <table v-if="templateId===201" style="width: 300px">
            <tbody>
            <tr>
              <td style="width: 100px;">
                <div class="preview-area active" :id="objectLists[0].name" @click="chooseActive(0)"
                     style="width: 100%; height: 100px">
                  <img :id="'preview_'+objectLists[0].name">
                </div>
              </td>
              <td style="width: 100px;">
                <div class="preview-area" :id="objectLists[1].name" @click="chooseActive(1)"
                     style="width: 100%; height: 100px">
                  <img :id="'preview_'+objectLists[1].name">
                </div>
              </td>
              <td style="width: 100px;">
                <div class="preview-area" :id="objectLists[2].name" @click="chooseActive(2)"
                     style="width: 100%; height: 100px">
                  <img :id="'preview_'+objectLists[2].name">
                </div>
              </td>
            </tr>
            <tr>
              <td style="width: 100px;">

              <div class="preview-area " :id="objectLists[3].name" @click="chooseActive(3)">
                  <img :id="'preview_'+objectLists[3].name"></div>
              </td>
              <td style="width: 100px;">
              <div class="preview-area" :id="objectLists[4].name" @click="chooseActive(4)">
                  <img :id="'preview_'+objectLists[4].name"></div>
              </td>
              <td style="width: 100px;">

              <div class="preview-area " :id="objectLists[5].name" @click="chooseActive(5)">
                  <img :id="'preview_'+objectLists[5].name"></div>
              </td>
            </tr>
            </tbody>
          </table>
          <table v-if="templateId===202" style="width: 300px">
            <tbody>
            <tr>
              <td style="width: 150px;">
                <div class="preview-area active" :id="objectLists[0].name" @click="chooseActive(0)"
                     style="width: 100%; height: 100px">
                  <img :id="'preview_'+objectLists[0].name">
                </div>
              </td>
              <td style="width: 150px;">
                <div class="preview-area" :id="objectLists[1].name" @click="chooseActive(1)"
                     style="width: 100%; height: 100px">
                  <img :id="'preview_'+objectLists[1].name">
                </div>
              </td>

            </tr>
            <tr>
              <td style="width: 150px;">
                <div class="preview-area" :id="objectLists[2].name" @click="chooseActive(2)"
                     style="width: 100%; height: 100px">
                  <img :id="'preview_'+objectLists[2].name">
                </div>
              </td>
              <td style="width: 150px;">
                <div class="preview-area " :id="objectLists[3].name" @click="chooseActive(3)">
                  <img :id="'preview_'+objectLists[3].name"></div>
              </td>
            </tr>
            </tbody>
          </table>
          <table v-if="templateId===203" style="width: 300px">
            <tbody>
            <tr>
              <td colspan="3" style="width: 300px;">
                <div class="preview-area active" :id="objectLists[0].name" @click="chooseActive(0)"
                     style="width: 100%; height: 100px">
                  <img :id="'preview_'+objectLists[0].name">
                </div>
              </td>
            </tr>
            <tr>
              <td style="width: 100px;">

              <div class="preview-area " :id="objectLists[1].name" @click="chooseActive(1)">
                  <img :id="'preview_'+objectLists[1].name"></div>
              </td>
              <td style="width: 100px;">

              <div class="preview-area" :id="objectLists[2].name" @click="chooseActive(2)">
                  <img :id="'preview_'+objectLists[2].name"></div>
              </td>
              <td style="width: 100px;">

              <div class="preview-area " :id="objectLists[3].name" @click="chooseActive(3)">
                  <img :id="'preview_'+objectLists[3].name"></div>
              </td>
            </tr>
            </tbody>
          </table>
          <table v-if="templateId===204" style="width: 300px">
            <tbody>
            <tr>
              <td style="width: 200px; height: 100%" rowspan="2">
                <div class="preview-area active" :id="objectLists[0].name" @click="chooseActive(0)"
                     style="width: 100%; height: 100%;">
                  <img :id="'preview_'+objectLists[0].name">
                </div>
              </td>
              <td style="width: 100px;">
                <div class="preview-area" :id="objectLists[1].name" @click="chooseActive(1)"
                     style="width: 100%; height: 100px">
                  <img :id="'preview_'+objectLists[1].name">
                </div>
              </td>
            </tr>
            <tr>

              <td style="width: 100px;">
                <div class="preview-area" :id="objectLists[2].name" @click="chooseActive(2)"
                     style="width: 100%; height: 100px">
                  <img :id="'preview_'+objectLists[2].name">
                </div>
              </td>
            </tr>
            </tbody>
          </table>
          <table v-if="templateId===205" style="width: 300px">
            <tbody>
            <tr>
              <td style="width: 300px;">
                <div class="preview-area active" :id="objectLists[0].name" @click="chooseActive(0)"
                     style="width: 100%; height: 100px">
                  <img :id="'preview_'+objectLists[0].name">
                </div>
              </td>

            </tr>
            <tr>
              <td style="width: 300px;">
                <div class="preview-area" :id="objectLists[1].name" @click="chooseActive(1)"
                     style="width: 100%; height: 100px">
                  <img :id="'preview_'+objectLists[1].name">
                </div>
              </td>
            </tr>
            </tbody>
          </table>
          <table v-if="templateId===206" style="width: 300px">
            <tbody>
            <tr>
              <td style="width: 150px; height: 200px" rowspan="2">
                <div class="preview-area active" :id="objectLists[0].name" @click="chooseActive(0)"
                     style="width: 100%; height: 100%">
                  <img :id="'preview_'+objectLists[0].name">
                </div>
              </td>

            </tr>
            <tr>
              <td style="width: 150px; height: 200px" rowspan="2">
                <div class="preview-area" :id="objectLists[1].name" @click="chooseActive(1)"
                     style="width: 100%; height: 100%">
                  <img :id="'preview_'+objectLists[1].name">
                </div>
              </td>
            </tr>
            </tbody>
          </table>
          <table v-if="templateId===207" style="width: 300px">
            <tbody>
            <tr>
              <td style="width: 300px; height: 200px" rowspan="2">
                <div class="preview-area active" :id="objectLists[0].name" @click="chooseActive(0)"
                     style="width: 100%; height: 100%">
                  <img :id="'preview_'+objectLists[0].name">
                </div>
              </td>

            </tr>

            </tbody>
          </table>
          <table v-if="templateId===1001" style="width: 300px; margin-top: 100px">
            <tbody>
            <tr>
              <td style="width: 100px;">
                <div class="preview-area active" :id="objectLists[0].name" @click="chooseActive(0)"
                     style="width: 100%; height: 100px">
                  <img :id="'preview_'+objectLists[0].name">
                </div>
              </td>
              <td style="width: 100px;">
                <div class="preview-area" :id="objectLists[1].name" @click="chooseActive(1)"
                     style="width: 100%; height: 100px">
                  <img :id="'preview_'+objectLists[1].name">
                </div>
              </td>
              <td style="width: 100px;">
                <div class="preview-area" :id="objectLists[2].name" @click="chooseActive(2)"
                     style="width: 100%; height: 100px">
                  <img :id="'preview_'+objectLists[2].name">
                </div>
              </td>
            </tr>
            </tbody>
          </table>
          <table v-if="templateId===1002" style="width: 300px; margin-top: 100px">
            <tbody>
            <tr>
              <td style="width: 100px;">
                <div class="preview-area active" :id="objectLists[0].name" @click="chooseActive(0)"
                     style="width: 100%; height: 100px">
                  <img :id="'preview_'+objectLists[0].name">
                </div>
              </td>
              <td style="width: 200px;">
                <div class="preview-area" :id="objectLists[1].name" @click="chooseActive(1)"
                     style="width: 100%; height: 100px">
                  <img :id="'preview_'+objectLists[1].name">
                </div>
              </td>
            </tr>
            </tbody>
          </table>
          <table v-if="templateId===1003" style="width: 300px; margin-top: 100px">
            <tbody>
            <tr>
              <td style="width: 200px;">
                <div class="preview-area active" :id="objectLists[0].name" @click="chooseActive(0)"
                     style="width: 100%; height: 100px">
                  <img :id="'preview_'+objectLists[0].name">
                </div>
              </td>
              <td style="width: 100px;">
                <div class="preview-area" :id="objectLists[1].name" @click="chooseActive(1)"
                     style="width: 100%; height: 100px">
                  <img :id="'preview_'+objectLists[1].name">
                </div>
              </td>
            </tr>
            </tbody>
          </table>
          <table v-if="templateId===1004" style="width: 300px; margin-top: 100px">
            <tbody>
            <tr>
              <td style="width: 150px;">
                <div class="preview-area active" :id="objectLists[0].name" @click="chooseActive(0)"
                     style="width: 100%; height: 100px">
                  <img :id="'preview_'+objectLists[0].name">
                </div>
              </td>
              <td style="width: 150px;">
                <div class="preview-area" :id="objectLists[1].name" @click="chooseActive(1)"
                     style="width: 100%; height: 100px">
                  <img :id="'preview_'+objectLists[1].name">
                </div>
              </td>
            </tr>
            </tbody>
          </table>
          <table v-if="templateId===1005" style="width: 300px; margin-top: 100px">
            <tbody>
            <tr>
              <td style="width: 300px;">
                <div class="preview-area active" :id="objectLists[0].name" @click="chooseActive(0)"
                     style="width: 100%; height: 100px">
                  <img :id="'preview_'+objectLists[0].name">
                </div>
              </td>
            </tr>
            </tbody>
          </table>
        </div>
        <div v-if="editor==='imagemap'" style="width: 300px; margin-bottom: 20px">
          <table v-if="templateId===201" style="width: 270px; height: 270px">
            <tbody>
            <tr>
              <td style="width: 90px;">
                <div class="preview-area active" :id="objectLists[0].name" @click="chooseActive(0)"
                     style="width: 100%; height: 135px">
                  <img :id="'preview_'+objectLists[0].name">
                </div>
              </td>
              <td style="width: 90px;">
                <div class="preview-area" :id="objectLists[1].name" @click="chooseActive(1)"
                     style="width: 100%; height: 135px">
                  <img :id="'preview_'+objectLists[1].name">
                </div>
              </td>
              <td style="width: 90px;">
                <div class="preview-area" :id="objectLists[2].name" @click="chooseActive(2)"
                     style="width: 100%; height: 135px">
                  <img :id="'preview_'+objectLists[2].name">
                </div>
              </td>
            </tr>
            <tr>
              <td style="width: 90px;">
                <div class="preview-area " :id="objectLists[3].name" @click="chooseActive(3)"
                     style="width: 100%; height: 135px">

                <img :id="'preview_'+objectLists[3].name"></div>
              </td>
              <td style="width: 90px;">
                <div class="preview-area" :id="objectLists[4].name" @click="chooseActive(4)"
                     style="width: 100%; height: 135px">
                  <img :id="'preview_'+objectLists[4].name"></div>
              </td>
              <td style="width: 90px;">
                <div class="preview-area " :id="objectLists[5].name" @click="chooseActive(5)"
                     style="width: 100%; height: 135px">
                  <img :id="'preview_'+objectLists[5].name"></div>
              </td>
            </tr>
            </tbody>
          </table>
          <table v-if="templateId===202" style="width: 270px; height: 270px">
            <tbody>
            <tr>
              <td style="width: 90px;">
                <div class="preview-area active" :id="objectLists[0].name" @click="chooseActive(0)"
                     style="width: 100%; height: 135px">
                  <img :id="'preview_'+objectLists[0].name">
                </div>
              </td>
              <td style="width: 90px;">
                <div class="preview-area" :id="objectLists[1].name" @click="chooseActive(1)"
                     style="width: 100%; height: 135px">
                  <img :id="'preview_'+objectLists[1].name">
                </div>
              </td>
            </tr>
            <tr>
              <td style="width: 135px;">
                <div class="preview-area " :id="objectLists[2].name" @click="chooseActive(2)"
                     style="width: 100%; height: 135px">

                  <img :id="'preview_'+objectLists[2].name"></div>
              </td>
              <td style="width: 135px;">
                <div class="preview-area" :id="objectLists[3].name" @click="chooseActive(3)"
                     style="width: 100%; height: 135px">
                  <img :id="'preview_'+objectLists[3].name"></div>
              </td>
            </tr>
            </tbody>
          </table>

          <table v-if="templateId===203" style="width: 270px; height: 270px">
            <tbody>
            <tr>
              <td style="width: 270px;">
                <div class="preview-area active" :id="objectLists[0].name" @click="chooseActive(0)"
                     style="width: 100%; height: 90px">
                  <img :id="'preview_'+objectLists[0].name">
                </div>
              </td>
            </tr>
            <tr>
              <td style="width: 270px;">
                <div class="preview-area" :id="objectLists[1].name" @click="chooseActive(1)"
                     style="width: 100%; height: 90px">
                  <img :id="'preview_'+objectLists[1].name">
                </div>
              </td>
            </tr>
            <tr>
              <td style="width: 270px;">
                <div class="preview-area" :id="objectLists[2].name" @click="chooseActive(2)"
                     style="width: 100%; height: 90px">
                  <img :id="'preview_'+objectLists[2].name">
                </div>
              </td>
            </tr>
            </tbody>
          </table>

          <table v-if="templateId===204" style="width: 270px; height: 270px">
            <tbody>
            <tr>
              <td style="width: 270px;" colspan="2">
                <div class="preview-area active" :id="objectLists[0].name" @click="chooseActive(0)"
                     style="width: 100%; height: 135px">
                  <img :id="'preview_'+objectLists[0].name">
                </div>
              </td>
            </tr>
            <tr>
              <td style="width: 90px;">
                <div class="preview-area" :id="objectLists[1].name" @click="chooseActive(1)"
                     style="width: 100%; height: 135px">
                  <img :id="'preview_'+objectLists[1].name">
                </div>
              </td>
              <td style="width: 90px;">
                <div class="preview-area" :id="objectLists[2].name" @click="chooseActive(2)"
                     style="width: 100%; height: 135px">
                  <img :id="'preview_'+objectLists[2].name">
                </div>
              </td>
            </tr>
            </tbody>
          </table>

          <table v-if="templateId===208" style="width: 270px; height: 270px">
            <tbody>
            <tr>
              <td style="width: 90px;">
                <div class="preview-area active" :id="objectLists[0].name" @click="chooseActive(0)"
                     style="width: 100%; height: 135px">
                  <img :id="'preview_'+objectLists[0].name">
                </div>
              </td>
            </tr>
            <tr>
              <td style="width: 90px;">
                <div class="preview-area" :id="objectLists[1].name" @click="chooseActive(1)"
                     style="width: 100%; height: 75px">
                  <img :id="'preview_'+objectLists[1].name">
                </div>
              </td>
            </tr>
            <tr>
              <td style="width: 90px;">
                <div class="preview-area" :id="objectLists[2].name" @click="chooseActive(2)"
                     style="width: 100%; height: 75px">
                  <img :id="'preview_'+objectLists[2].name">
                </div>
              </td>
            </tr>
            </tbody>
          </table>

          <table v-if="templateId===205" style="width: 270px; height: 270px">
            <tbody>
            <tr>
              <td style="width: 90px;">
                <div class="preview-area active" :id="objectLists[0].name" @click="chooseActive(0)"
                     style="width: 100%; height: 135px">
                  <img :id="'preview_'+objectLists[0].name">
                </div>
              </td>
            </tr>
            <tr>
              <td style="width: 90px;">
                <div class="preview-area" :id="objectLists[1].name" @click="chooseActive(1)"
                     style="width: 100%; height: 135px">
                  <img :id="'preview_'+objectLists[1].name">
                </div>
              </td>
            </tr>
            </tbody>
          </table>

          <table v-if="templateId===206" style="width: 270px; height: 270px">
            <tbody>
            <tr>
              <td style="width: 90px;">
                <div class="preview-area active" :id="objectLists[0].name" @click="chooseActive(0)"
                     style="width: 135px; height: 270px">
                  <img :id="'preview_'+objectLists[0].name">
                </div>
              </td>
              <td style="width: 90px;">
                <div class="preview-area" :id="objectLists[1].name" @click="chooseActive(1)"
                     style="width: 135px; height: 270px">
                  <img :id="'preview_'+objectLists[1].name">
                </div>
              </td>
            </tr>

            </tbody>
          </table>

          <table v-if="templateId===207" style="width: 270px; height: 270px">
            <tbody>
            <tr>
              <td style="width: 90px;">
                <div class="preview-area active" :id="objectLists[0].name" @click="chooseActive(0)"
                     style="width: 270px; height: 270px">
                  <img :id="'preview_'+objectLists[0].name">
                </div>
              </td>

            </tr>

            </tbody>
          </table>

        </div>
        <div class="line-nav-bar">
          <p>テキストメッセージ</p>
        </div>
      </div>
      <div style="" class="editor-divider"></div>
      <div style="display: flex; flex-direction: column; direction: revert; width: 100%" class="editor-container">
        <div style="text-align: right; display: flex; height: 50px; justify-content: flex-end">
          <button style="display: inline-block; height: 30px; " class="btn-close" @click="imageGeneration()"><i
            class="fa fa-download"></i>
            ダウンロード
          </button>
          <div style="width: 10px"></div>
          <button style="display: inline-block; height: 30px; " class="btn-save0" @click="imageGeneration(false)"><i class="fa fa-save"></i> 保存
          </button>
        </div>
        <image-editor :data="objectLists[selectIndex]" :preview="'#preview_'+objectLists[selectIndex].name"
                      :width="width" :height="height"
                      @input="objectLists[selectIndex] = $event"></image-editor>
        <div style="text-align: center; flex: 1; height: 50px">
        </div>
      </div>
    </div>
  </div>
</template>
<script>

export default {
  props: {
    editor: {
      type: String,
      default: 'richmenu'
    },
    templateId: {
      type: Number,
      default: 201
    }
  },
  data() {
    return {
      bounds: this.RichMenuBounds[this.templateId],
      currentData: {},
      selectIndex: 0,
      objectLists: [],
      rendering: true,
      width: 833,
      height: 833
    };
  },

  created() {
    if (this.editor === 'imagemap') {
      this.width = 346;
      this.height = 520;
      this.bounds = this.ImageMapBounds[this.templateId];
    }
    this.setup();
  },

  watch: {
    templateId(val) {
      if (this.editor === 'imagemap') {
        this.bounds = this.ImageMapBounds[val];
      } else {
        this.bounds = this.RichMenuBounds[val];
      }
      this.setup();
    }
  },

  methods: {
    styleAuto() {
      return this.editor === 'imagemap' ? 'height: 50px;' : '';
    },
    setup() {
      this.objectLists = [];
      if (this.bounds) {
        for (const [index, bound] of this.bounds.entries()) {
          this.objectLists.push({
            name: 'obj_' + index,
            crop_type_index: bound.crop_index,
            bound: {
              x: bound.x,
              y: bound.y,
              w: bound.width,
              h: bound.height
            },
            image: {
              x: 0,
              y: 0,
              w: 0,
              h: 0,
              zoom: 1,
              data: null
            },
            cache: null
          });
        }
      } else {
        alert('zxczxcxzc');
      }
      // this.chooseActive(0);
      this.chooseActive(0);
    },

    chooseActive(index = 0) {
      const object = this.objectLists[index];
      this.selectIndex = index;

      $('.preview-area.active').removeClass('active');
      $('#' + object.name).addClass('active');
    },

    saveImage(data) {
      this.$emit('save', data);
    },
    imageGeneration(isDownload = true) {
      const canvas = document.createElement('canvas');

      if (this.editor === 'imagemap') {
        canvas.width = 1040;
        canvas.height = 1040;
      } else {
        canvas.width = 2500;
        canvas.height = 1686;

        if (this.templateId > 1000) {
          canvas.height = 843;
        }
      }

      const context = canvas.getContext('2d');
      context.fillStyle = 'white';
      context.fillRect(0, 0, canvas.width, canvas.height);

      // drawimage
      const tasks = [];
      for (let index = 0; index < this.objectLists.length; index++) {
        const object = this.objectLists[index];
        if (object.cache) {
          tasks.push(new Promise((resolve, reject) => {
            const image = new Image();
            image.onload = () => {
              const bound = object.bound;
              context.drawImage(image, bound.x, bound.y, bound.w, bound.h);
              resolve();
            };
            image.crossOrigin = 'anonymous';
            image.src = object.cache;
          }));
        }
      }

      Promise.all(tasks).then(() => {
        if (isDownload) {
          const a = document.createElement('a');
          a.href = canvas.toDataURL('image/jpeg');
          a.download = `${(new Date().getTime())}_${this.editor}_${a.href.length}.jpg`;
          document.body.appendChild(a);
          a.click();
          document.body.removeChild(a);
        } else {
          this.saveImage(canvas.toDataURL('image/jpeg'));
        }
      }).catch((err) => {
        console.log(err);
      });
    }
  }

};
</script>

<style scoped lang="scss">
  .preview-area {
    background: white;
    width: 100%;
    display: inline-table;
    height: 100px;
    overflow: hidden;
    border: 1px solid #ededed;
  }
  .preview-area>img{
    width: 100%;
  }

  .preview {
    width: 100% !important;
    height: 100% !important;
    overflow: hidden;
    background: white;
  }

  .preview-area.active {
    background: #f1f1f1;
  }

  ::v-deep {
    .editor-content {
      display: flex;
      flex-direction: row;
    }
    .editor-divider{
      width: 20px;
    }

    @media only screen and (max-width: 911px) {
      .editor-content {
        flex-direction: column;
      }

      .editor-divider{
        width: 100%;
        height: 20px;
      }
    }
    .btn-close {
      background: transparent;
      border: 1px solid #ededed;
      color: #00B900;
      padding: 5px 15px;
      font-size: 13px;
      border-radius: 4px;
      min-width: 100px;

    }

    .btn-save0 {
      background: #00B900;
      border: 1px solid #ededed;
      color: white;
      padding: 5px 15px;
      font-size: 13px;
      border-radius: 4px;
      min-width: 100px;
    }

    td {
      padding: 0 !important;
    }

    .bg-text-mess {
      height: 150px;
      width: 100%;
      background: rgb(245 245 245)
    }

    .line-nav-bar {
      width: 100%;
      height: 50px;
      background: rgb(10 47 76);
      color: white;
      display: flex

    }
    .line-nav-bar > p {
      background: rgb(10 47 76);
      display: inline-block;
      margin: auto;
    }

  }

</style>
