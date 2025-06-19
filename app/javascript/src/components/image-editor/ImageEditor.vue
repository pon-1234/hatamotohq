<template>
  <div style="width: 100%; height: 100%; display: flex; flex-direction: column">
    <div style="flex: 1; object-fit: scale-down" id="canvas-area">
      <canvas id="canvas-editor" ref="canvasRef"></canvas>
    </div>

    <div style="position: relative; justify-content: center; height: 40px; display: flex; flex-direction: row">
      <div style="margin: auto 0; width: 30px;" @click="zoomIn" v-if="object.image.data !== null">
        <i class="fa fa-search-plus" aria-hidden="true"></i>
      </div>
      <div style="margin: auto 0; width: 30px;" @click="zoomOut" v-if="object.image.data !== null">
        <i class="fa fa-search-minus" aria-hidden="true"></i>
      </div>
    </div>
    <span v-if="errorMessage" class="w-100 text-center error">{{ errorMessage }}</span>
    <div style="position: relative; text-align: center; height: 40px; display: flex;">
      <label class="btn-img-upload text-info" role="button">
        <input @change="changeImage" type="file" name="image"
               style="position: absolute; z-index: 1; top: 0; opacity: 0; width: 100%">
        <i class="mdi mdi-image-size-select-actual"></i> アップロード
      </label>
    </div>
  </div>
</template>

<script setup>
import { ref, reactive, watch, onMounted, onUnmounted, nextTick } from 'vue';
import Media from '@/core/media';

// Props
const props = defineProps({
  preview: {
    type: String,
    required: true
  },
  modelValue: {
    type: Object,
    required: true
  },
  width: {
    type: Number,
    required: true
  },
  height: {
    type: Number,
    required: true
  }
});

// Emits
const emit = defineEmits(['update:modelValue']);

// Refs
const canvasRef = ref(null);

// State
const object = reactive(JSON.parse(JSON.stringify(props.modelValue)));
const currentIndex = ref(0);
const rectPath = ref(null);
const cropType = ref(null);
const wCenter = ref(0);
const hCenter = ref(0);
const cropTypes = ref([]);
const canvas = ref(null);
const context = ref(null);
const cropCanvas = ref(null);
const cropContext = ref(null);
const clipCanvas = ref(null);
const clipContext = ref(null);
const isMouseDown = ref(false);
const mouseX = ref(0);
const mouseY = ref(0);
const ratioW = ref(1);
const ratioH = ref(1);
const remoteW = ref(0);
const errorMessage = ref(null);

// Methods
const zoomIn = () => {
  const img = object.image;
  const oldW = img.w;
  const oldH = img.h;

  img.zoom += 0.05;

  img.w = img.origin.w * img.zoom;
  img.h = img.origin.h * img.zoom;
  img.x -= (Math.abs(img.w - oldW) / 2);
  img.y -= Math.abs(img.h - oldH) / 2;

  canvasRender();
};

const zoomOut = () => {
  const img = object.image;
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
  canvasRender();
};

const setupCrop = () => {
  rectPath.value = new Path2D();
  cropType.value = cropTypes.value[object.crop_type_index];
  rectPath.value.rect(
    wCenter.value - cropType.value.w / 2, 
    hCenter.value - cropType.value.h / 2, 
    cropType.value.w, 
    cropType.value.h
  );

  cropCanvas.value.width = props.width * cropType.value.w / remoteW.value;
  cropCanvas.value.height = props.height * cropType.value.h / remoteW.value;

  ratioW.value = cropCanvas.value.width / cropType.value.w;
  ratioH.value = cropCanvas.value.height / cropType.value.h;

  clipCanvas.value.width = cropType.value.w;
  clipCanvas.value.height = cropType.value.h;
};

const setupListener = () => {
  const canvasEl = canvas.value;
  
  const handleMouseDown = (e) => {
    mouseX.value = e.offsetX;
    mouseY.value = e.offsetY;
    isMouseDown.value = true;
  };

  const handleMouseMove = (e) => {
    e.preventDefault();
    e.stopPropagation();

    if (object.image.data) {
      const img = object.image;
      if (hasHover(img, e)) {
        canvasEl.style.cursor = 'move';
      } else {
        canvasEl.style.cursor = 'default';
      }

      if (isMouseDown.value) {
        move(img, {
          x: e.offsetX - mouseX.value,
          y: e.offsetY - mouseY.value
        });
        mouseX.value = e.offsetX;
        mouseY.value = e.offsetY;
        canvasRender();
      }
    }
  };

  const handleWheel = (e) => {
    e.preventDefault();
    if (object.image.data) {
      let delta = e.deltaY || e.wheelDelta;
      delta = Math.max(-1, Math.min(1, delta));

      const img = object.image;
      const oldW = img.w;
      const oldH = img.h;

      if (delta > 0) {
        img.zoom += 0.05;

        img.w = img.origin.w * img.zoom;
        img.h = img.origin.h * img.zoom;
        img.x -= (Math.abs(img.w - oldW) / 2);
        img.y -= Math.abs(img.h - oldH) / 2;

        canvasRender();
      } else if (delta < 0) {
        img.zoom -= 0.05;

        if (img.zoom <= 0.05) {
          img.zoom = 0.05;
        }

        img.w = img.origin.w * img.zoom;
        img.h = img.origin.h * img.zoom;
        img.x += Math.abs(img.w - oldW) / 2;
        img.y += Math.abs(img.h - oldH) / 2;
        canvasRender();
      }
    }

    return false;
  };

  const handleMouseUp = () => {
    if (isMouseDown.value) {
      isMouseDown.value = false;
    }
  };

  canvasEl.addEventListener('mousedown', handleMouseDown);
  canvasEl.addEventListener('mousemove', handleMouseMove);
  canvasEl.addEventListener('wheel', handleWheel);
  window.addEventListener('mouseup', handleMouseUp);

  // Cleanup
  onUnmounted(() => {
    canvasEl.removeEventListener('mousedown', handleMouseDown);
    canvasEl.removeEventListener('mousemove', handleMouseMove);
    canvasEl.removeEventListener('wheel', handleWheel);
    window.removeEventListener('mouseup', handleMouseUp);
  });
};

const canvasRender = () => {
  // background
  context.value.fillStyle = 'white';
  context.value.fillRect(0, 0, canvas.value.width, canvas.value.height);

  // modal
  context.value.globalAlpha = 0.8;
  if (object.image.data) {
    const img = object.image;
    context.value.drawImage(img.data, img.x, img.y, img.w, img.h);
  }

  context.value.fillStyle = '#ededed';
  context.value.fillRect(0, 0, canvas.value.width, canvas.value.height);
  context.value.globalAlpha = 1;

  // mask
  context.value.save();
  context.value.clip(rectPath.value);
  context.value.fillStyle = 'white';
  context.value.fill(rectPath.value);
  if (object.image.data) {
    const img = object.image;
    context.value.drawImage(img.data, img.x, img.y, img.w, img.h);

    // crop
    cropContext.value.fillStyle = 'white';
    cropContext.value.fillRect(0, 0, cropCanvas.value.width, cropCanvas.value.height);
    cropContext.value.drawImage(
      img.data, 
      (img.x * ratioW.value) - (wCenter.value - cropType.value.w / 2) * ratioW.value, 
      img.y * ratioH.value - (hCenter.value - cropType.value.h / 2) * remoteW.value, 
      img.w * ratioW.value, 
      img.h * ratioH.value
    );
    object.cache = cropCanvas.value.toDataURL('image/jpeg');
    
    // preview
    clipContext.value.drawImage(
      canvas.value, 
      wCenter.value - cropType.value.w / 2, 
      hCenter.value - cropType.value.h / 2, 
      cropType.value.w, 
      cropType.value.h, 
      0, 
      0, 
      cropType.value.w, 
      cropType.value.h
    );
    
    // Update preview image
    const previewEl = document.querySelector(props.preview);
    if (previewEl) {
      previewEl.src = clipCanvas.value.toDataURL('image/jpeg');
    }
  }
  context.value.strokeStyle = '#000000';
  context.value.setLineDash([3]);
  context.value.stroke(rectPath.value);

  context.value.restore();

  // sync object
  syncObj();
};

const hasHover = (img, e) => {
  return (e.offsetX >= img.x && e.offsetX <= img.x + img.w) && 
         (e.offsetY >= img.y && e.offsetY <= img.y + img.h);
};

const move = (img, delta) => {
  img.x += delta.x;
  img.y += delta.y;
};

const changeImage = async (ev) => {
  const blob = ev.currentTarget.files[0];
  if (!blob) return;
  
  const reader = new FileReader();
  reader.readAsArrayBuffer(blob);
  
  reader.onload = async (e) => {
    const validMimeBytes = await Media.validateFileByMimeBytes(e, 'image', null);
    if (!validMimeBytes.valid) {
      errorMessage.value = validMimeBytes.message;
      return;
    }
    
    const img = new Image();
    img.onload = () => {
      const imgObj = object.image;
      imgObj.data = img;
      imgObj.zoom = 1;
      imgObj.x = wCenter.value - img.width / 2;
      imgObj.y = hCenter.value - img.height / 2;
      imgObj.w = img.width;
      imgObj.h = img.height;
      imgObj.origin = {
        w: img.width,
        h: img.height
      };
      canvasRender();
    };
    img.src = URL.createObjectURL(blob);
  };
  
  errorMessage.value = '';
  ev.target.value = '';
};

const syncObj = () => {
  emit('update:modelValue', object);
};

// Watch
watch(() => props.modelValue, (val) => {
  Object.assign(object, JSON.parse(JSON.stringify(val)));
  setupCrop();
  canvasRender();
}, { deep: true });

// Lifecycle
onMounted(async () => {
  await nextTick();
  
  const container = document.getElementById('canvas-area');
  canvas.value = canvasRef.value;

  canvas.value.width = container.offsetWidth;
  canvas.value.height = container.offsetHeight;
  wCenter.value = canvas.value.width / 2;
  hCenter.value = canvas.value.height / 2;
  context.value = canvas.value.getContext('2d');

  cropCanvas.value = document.createElement('canvas');
  cropContext.value = cropCanvas.value.getContext('2d');

  clipCanvas.value = document.createElement('canvas');
  clipContext.value = clipCanvas.value.getContext('2d');

  const aspectRatio = 0.95;
  const sizeCrop = Math.min(canvas.value.width, canvas.value.height);
  const w = sizeCrop * aspectRatio / 3;
  remoteW.value = w;
  
  // Initialize crop types
  cropTypes.value = [
    { w: w, h: w },                    // 0
    { w: w * 3, h: w },                // 1
    { w: w * 3, h: w * 2 },            // 2
    { w: w * (3 / 2), h: w },          // 3
    { w: w * 2, h: w * 2 },            // 4
    { w: w * (3 / 2), h: w * 2 },      // 5
    { w: w * 2, h: w },                // 6
    { w: w, h: w * 3 / 2 },            // 7
    { w: w * 3 / 2, h: w * 3 / 2 },    // 8
    { w: w * 3, h: w },                // 9
    { w: w * 3, h: w * 3 / 2 },        // 10
    { w: w * 3, h: w * 3 / 2 / 2 },    // 11
    { w: w * 3 / 2, h: w * 3 },        // 12
    { w: w * 3, h: w * 3 }             // 13
  ];

  setupListener();

  if (object) {
    setupCrop();
    canvasRender();
  }
});
</script>

<style scoped lang="scss">
:deep(.btn-img-upload) {
  font-weight: normal;
  position: relative;
  margin: auto;
}

.error {
  color: red;
}
</style>
