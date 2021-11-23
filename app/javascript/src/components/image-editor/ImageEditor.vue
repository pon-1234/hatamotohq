<template>
  <div style="width: 100%; height: 100%; display: flex; flex-direction: column">
    <div style="flex: 1; object-fit: scale-down" id="canvas-area">
      <canvas id="canvas-editor"></canvas>
    </div>

    <div style="position: relative; justify-content: center; height: 40px; display: flex; flex-direction: row">
      <div style="margin: auto 0; width: 30px;" @click="zoomIn()" v-if="object.image.data !== null">
        <i class="fa fa-search-plus" aria-hidden="true"></i>
      </div>
      <div style="margin: auto 0; width: 30px;" @click="zoomOut()" v-if="object.image.data !== null">
        <i class="fa fa-search-minus" aria-hidden="true"></i>

      </div>

    </div>
    <span v-if="errorMessage" class="w-100 text-center error">{{ errorMessage }}</span>
    <div style="position: relative; text-align: center; height: 40px; display: flex;">
      <label class="btn-img-upload text-info" role="button">
        <input @change="changeImage($event)" type="file" name="image"
               style="position: absolute; z-index: 1; top: 0; opacity: 0; width: 100%">
        <i class="mdi mdi-image-size-select-actual"></i> アップロード
      </label>
    </div>
  </div>
</template>

<script>
import Media from '@/core/media';

export default {
  props: ['preview', 'data', 'width', 'height'],

  data() {
    return {
      object: this.data,
      currentIndex: 0,
      rectPath: null,
      cropType: null,
      wCenter: 0,
      hCenter: 0,
      cropTypes: [],
      canvas: null,
      context: null,
      cropCanvas: null,
      cropContext: null,
      clipCanvas: null,
      clipContext: null,
      isMouseDown: false,
      mouseX: 0,
      mouseY: 0,
      ratioW: 1,
      ratioH: 1,
      remoteW: 0,
      errorMessage: null
    };
  },

  watch: {
    data(val) {
      this.object = val;
      this.setupCrop();
      this.canvasRender();
    }
  },

  mounted() {
    const container = document.getElementById('canvas-area');
    this.canvas = document.getElementById('canvas-editor');

    this.canvas.width = container.offsetWidth;
    this.canvas.height = container.offsetHeight;
    this.wCenter = this.canvas.width / 2;
    this.hCenter = this.canvas.height / 2;
    this.context = this.canvas.getContext('2d');

    this.cropCanvas = document.createElement('canvas');
    this.cropContext = this.cropCanvas.getContext('2d');

    this.clipCanvas = document.createElement('canvas');
    this.clipContext = this.clipCanvas.getContext('2d');

    const aspectRatio = 0.95;

    const sizeCrop = Math.min(this.canvas.width, this.canvas.height);
    // rectangle
    const w = sizeCrop * aspectRatio / 3;
    this.remoteW = w;
    // 0
    this.cropTypes.push({
      w: w,
      h: w
    });
    // 1
    this.cropTypes.push({
      w: w * 3,
      h: w
    });
    // 2
    this.cropTypes.push({
      w: w * 3,
      h: w * 2
    });
    // 3
    this.cropTypes.push({
      w: w * (3 / 2),
      h: w
    });
    // 4
    this.cropTypes.push({
      w: w * 2,
      h: w * 2
    });
    // 5
    this.cropTypes.push({
      w: w * (3 / 2),
      h: w * 2
    });

    // 6
    this.cropTypes.push({
      w: w * 2,
      h: w
    });

    // 7
    this.cropTypes.push({
      w: w,
      h: w * 3 / 2
    });

    // 8
    this.cropTypes.push({
      w: w * 3 / 2,
      h: w * 3 / 2
    });

    // 9
    this.cropTypes.push({
      w: w * 3,
      h: w
    });

    // 10
    this.cropTypes.push({
      w: w * 3,
      h: w * 3 / 2
    });

    // 11
    this.cropTypes.push({
      w: w * 3,
      h: w * 3 / 2 / 2
    });

    // 12
    this.cropTypes.push({
      w: w * 3 / 2,
      h: w * 3
    });

    // 13
    this.cropTypes.push({
      w: w * 3,
      h: w * 3
    });

    this.setupListener();

    if (this.object) {
      this.setupCrop();
      this.canvasRender();
    }
  },

  methods: {

    zoomIn() {
      const img = this.object.image;
      const oldW = img.w;
      const oldH = img.h;

      img.zoom += 0.05;

      img.w = img.origin.w * img.zoom;
      img.h = img.origin.h * img.zoom;
      img.x -= (Math.abs(img.w - oldW) / 2);
      img.y -= Math.abs(img.h - oldH) / 2;

      this.canvasRender();
    },
    zoomOut() {
      const img = this.object.image;
      const oldW = img.w;
      const oldH = img.h;

      img.zoom -= 0.05;

      if (img.zoom <= 0.05) {
        img.zoom = 0.05;
      }

      img.w = img.origin.w * img.zoom;
      img.h = img.origin.h * img.zoom;
      img.x += Math.abs(img.w - oldW) / 2;
      img.y += Math.abs(img.h - oldH) / 2;
      this.canvasRender();
    },
    setupCrop() {
      this.rectPath = new Path2D();
      this.cropType = this.cropTypes[this.object.crop_type_index];
      this.rectPath.rect(this.wCenter - this.cropType.w / 2, this.hCenter - this.cropType.h / 2, this.cropType.w, this.cropType.h);

      this.cropCanvas.width = this.width * this.cropType.w / this.remoteW;
      this.cropCanvas.height = this.height * this.cropType.h / this.remoteW;

      this.ratioW = this.cropCanvas.width / this.cropType.w;
      this.ratioH = this.cropCanvas.height / this.cropType.h;

      this.clipCanvas.width = this.cropType.w;
      this.clipCanvas.height = this.cropType.h;
    },

    setupListener() {
      this.canvas.addEventListener('mousedown', e => {
        this.mouseX = e.offsetX;
        this.mouseY = e.offsetY;
        this.isMouseDown = true;
      });

      this.canvas.addEventListener('mousemove', e => {
        e.preventDefault();
        e.stopPropagation();

        if (this.object.image.data) {
          const img = this.object.image;
          if (this.hasHover(img, e)) {
            this.canvas.style.cursor = 'move';
          } else {
            this.canvas.style.cursor = 'default';
          }

          if (this.isMouseDown) {
            this.move(img, {
              x: e.offsetX - this.mouseX,
              y: e.offsetY - this.mouseY
            });
            this.mouseX = e.offsetX;
            this.mouseY = e.offsetY;
            this.canvasRender();
          }
        }
      });

      this.canvas.addEventListener('wheel', e => {
        e.preventDefault();
        if (this.object.image.data) {
          let delta = e.delta || e.wheelDelta;
          delta = Math.max(-1, Math.min(1, delta));

          const img = this.object.image;
          const oldW = img.w;
          const oldH = img.h;

          if (delta > 0) {
            img.zoom += 0.05;

            img.w = img.origin.w * img.zoom;
            img.h = img.origin.h * img.zoom;
            img.x -= (Math.abs(img.w - oldW) / 2);
            img.y -= Math.abs(img.h - oldH) / 2;

            this.canvasRender();
          } else if (delta < 0) {
            img.zoom -= 0.05;

            if (img.zoom <= 0.05) {
              img.zoom = 0.05;
            }

            img.w = img.origin.w * img.zoom;
            img.h = img.origin.h * img.zoom;
            img.x += Math.abs(img.w - oldW) / 2;
            img.y += Math.abs(img.h - oldH) / 2;
            this.canvasRender();
          }
        }

        return false;
      });

      window.addEventListener('mouseup', e => {
        if (this.isMouseDown) {
          this.isMouseDown = false;
        }
      });
    },

    canvasRender() {
      // backgroud
      this.context.fillStyle = 'white';
      this.context.fillRect(0, 0, this.canvas.width, this.canvas.height);

      // modal
      this.context.globalAlpha = 0.8;
      if (this.object.image.data) {
        const img = this.object.image;

        this.context.drawImage(img.data, img.x, img.y, img.w, img.h);
      }

      this.context.fillStyle = '#ededed';
      this.context.fillRect(0, 0, this.canvas.width, this.canvas.height);
      this.context.globalAlpha = 1;

      // mask
      this.context.save();
      this.context.clip(this.rectPath);
      this.context.fillStyle = 'white';
      this.context.fill(this.rectPath);
      if (this.object.image.data) {
        const img = this.object.image;
        this.context.drawImage(img.data, img.x, img.y, img.w, img.h);

        // crop
        this.cropContext.fillStyle = 'white';
        this.cropContext.fillRect(0, 0, this.cropCanvas.width, this.cropCanvas.height);
        this.cropContext.drawImage(img.data, (img.x * this.ratioW) - (this.wCenter - this.cropType.w / 2) * this.ratioW, img.y * this.ratioH - (this.hCenter - this.cropType.h / 2) * this.ratioW, img.w * this.ratioW, img.h * this.ratioH);
        this.object.cache = this.cropCanvas.toDataURL('image/jpeg');
        // preview
        this.clipContext.drawImage(this.canvas, this.wCenter - this.cropType.w / 2, this.hCenter - this.cropType.h / 2, this.cropType.w, this.cropType.h, 0, 0, this.cropType.w, this.cropType.h);
        $(this.preview).attr('src', this.clipCanvas.toDataURL('image/jpeg'));
      }
      this.context.strokeStyle = '#000000';
      this.context.setLineDash([3]);
      this.context.stroke(this.rectPath);

      this.context.restore();

      // sync object
      this.syncObj();
    },

    hasHover: function(img, e) {
      return (e.x >= img.x && e.x <= img.x + img.w) && (e.y >= img.y && e.y <= img.y + img.h);
    },

    move: function(img, delta) {
      img.x += delta.x;
      img.y += delta.y;
    },

    changeImage(ev) {
      const blob = ev.currentTarget.files[0];
      const _this = this;
      const reader = new FileReader();
      reader.readAsArrayBuffer(blob);
      reader.onload = async function(e) {
        const validMimeBytes = await Media.validateFileByMimeBytes(e, 'image', null);
        if (!validMimeBytes.valid) {
          _this.errorMessage = validMimeBytes.message;
          return;
        }
        const img = new Image();
        img.onload = () => {
          const imgObj = _this.object.image;
          imgObj.data = img;
          imgObj.zoom = 1;
          imgObj.x = _this.wCenter - img.width / 2;
          imgObj.y = _this.hCenter - img.height / 2;
          imgObj.w = img.width;
          imgObj.h = img.height;
          imgObj.origin = {
            w: img.width,
            h: img.height
          };
          $('input[type="file"]').val(null);
          _this.canvasRender();
        };
        img.src = URL.createObjectURL(blob);
      };
      this.errorMessage = '';
      ev.target.value = '';
    },

    syncObj() {
      this.$emit('input', this.object);
    }
  }
};
</script>

<style scoped lang="scss">
  ::v-deep {
    .btn-img-upload {
      font-weight: normal;
      position: relative;
      margin: auto;
    }
  }

  .error {
    color: red;
  }
</style>
