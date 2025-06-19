<template>
  <div class="image-editor-toolbar">
    <div class="toolbar-section">
      <h6 class="toolbar-title">画像編集ツール</h6>
      
      <!-- Text Tools -->
      <div class="tool-group">
        <button
          v-tooltip.hover="'テキストを追加'"
          class="btn btn-outline-secondary btn-sm"
          @click="addText"
        >
          <i class="fas fa-font"></i>
        </button>
        <button
          v-tooltip.hover="'フォントサイズ'"
          class="btn btn-outline-secondary btn-sm"
          :disabled="!hasActiveObject"
          @click="showFontSizeModal"
        >
          <i class="fas fa-text-height"></i>
        </button>
        <button
          v-tooltip.hover="'フォントカラー'"
          class="btn btn-outline-secondary btn-sm"
          :disabled="!hasActiveObject"
          @click="showColorPicker"
        >
          <i class="fas fa-palette"></i>
        </button>
      </div>

      <!-- Shape Tools -->
      <div class="tool-group">
        <button
          v-tooltip.hover="'四角形を追加'"
          class="btn btn-outline-secondary btn-sm"
          @click="addRectangle"
        >
          <i class="far fa-square"></i>
        </button>
        <button
          v-tooltip.hover="'円を追加'"
          class="btn btn-outline-secondary btn-sm"
          @click="addCircle"
        >
          <i class="far fa-circle"></i>
        </button>
        <button
          v-tooltip.hover="'線を追加'"
          class="btn btn-outline-secondary btn-sm"
          @click="addLine"
        >
          <i class="fas fa-minus"></i>
        </button>
      </div>

      <!-- Layer Controls -->
      <div class="tool-group">
        <button
          v-tooltip.hover="'前面へ'"
          class="btn btn-outline-secondary btn-sm"
          :disabled="!hasActiveObject"
          @click="bringForward"
        >
          <i class="fas fa-level-up-alt"></i>
        </button>
        <button
          v-tooltip.hover="'背面へ'"
          class="btn btn-outline-secondary btn-sm"
          :disabled="!hasActiveObject"
          @click="sendBackward"
        >
          <i class="fas fa-level-down-alt"></i>
        </button>
      </div>

      <!-- Edit Controls -->
      <div class="tool-group">
        <button
          v-tooltip.hover="'コピー'"
          class="btn btn-outline-secondary btn-sm"
          :disabled="!hasActiveObject"
          @click="copyObject"
        >
          <i class="fas fa-copy"></i>
        </button>
        <button
          v-tooltip.hover="'ペースト'"
          class="btn btn-outline-secondary btn-sm"
          :disabled="!clipboard"
          @click="pasteObject"
        >
          <i class="fas fa-paste"></i>
        </button>
        <button
          v-tooltip.hover="'削除'"
          class="btn btn-outline-danger btn-sm"
          :disabled="!hasActiveObject"
          @click="deleteObject"
        >
          <i class="fas fa-trash"></i>
        </button>
      </div>

      <!-- Undo/Redo -->
      <div class="tool-group">
        <button
          v-tooltip.hover="'元に戻す'"
          class="btn btn-outline-secondary btn-sm"
          :disabled="!canUndo"
          @click="undo"
        >
          <i class="fas fa-undo"></i>
        </button>
        <button
          v-tooltip.hover="'やり直す'"
          class="btn btn-outline-secondary btn-sm"
          :disabled="!canRedo"
          @click="redo"
        >
          <i class="fas fa-redo"></i>
        </button>
      </div>

      <!-- Zoom Controls -->
      <div class="tool-group">
        <button
          v-tooltip.hover="'ズームイン'"
          class="btn btn-outline-secondary btn-sm"
          @click="zoomIn"
        >
          <i class="fas fa-search-plus"></i>
        </button>
        <button
          v-tooltip.hover="'ズームアウト'"
          class="btn btn-outline-secondary btn-sm"
          @click="zoomOut"
        >
          <i class="fas fa-search-minus"></i>
        </button>
        <button
          v-tooltip.hover="'リセット'"
          class="btn btn-outline-secondary btn-sm"
          @click="resetZoom"
        >
          <i class="fas fa-expand"></i>
        </button>
      </div>
    </div>

    <!-- Properties Panel -->
    <div v-if="activeObject" class="properties-panel mt-3">
      <h6 class="toolbar-title">プロパティ</h6>
      
      <div v-if="activeObject.type === 'text'" class="property-group">
        <label>フォントサイズ</label>
        <input
          type="number"
          class="form-control form-control-sm"
          v-model="fontSize"
          min="10"
          max="100"
          @change="updateObjectProperty('fontSize', $event.target.value)"
        />
      </div>

      <div class="property-group">
        <label>透明度</label>
        <input
          type="range"
          class="form-control form-control-sm"
          v-model="opacity"
          min="0"
          max="1"
          step="0.1"
          @input="updateObjectProperty('opacity', $event.target.value)"
        />
      </div>

      <div class="property-group">
        <label>回転</label>
        <input
          type="range"
          class="form-control form-control-sm"
          v-model="angle"
          min="0"
          max="360"
          @input="updateObjectProperty('angle', $event.target.value)"
        />
      </div>
    </div>
  </div>
</template>

<script setup>
import { ref, watch, computed } from 'vue';

// Props
const props = defineProps({
  hasActiveObject: {
    type: Boolean,
    default: false
  },
  activeObject: {
    type: Object,
    default: null
  },
  canUndo: {
    type: Boolean,
    default: false
  },
  canRedo: {
    type: Boolean,
    default: false
  },
  clipboard: {
    type: Object,
    default: null
  }
});

// Emits
const emit = defineEmits([
  'add-text',
  'show-font-size',
  'show-color-picker',
  'add-rectangle',
  'add-circle',
  'add-line',
  'bring-forward',
  'send-backward',
  'copy',
  'paste',
  'delete',
  'undo',
  'redo',
  'zoom-in',
  'zoom-out',
  'reset-zoom',
  'update-property'
]);

// Local state for form inputs
const fontSize = ref(16);
const opacity = ref(1);
const angle = ref(0);

// Watch active object changes
watch(() => props.activeObject, (newVal) => {
  if (newVal) {
    fontSize.value = newVal.fontSize || 16;
    opacity.value = newVal.opacity || 1;
    angle.value = newVal.angle || 0;
  }
});

// Methods
const addText = () => emit('add-text');
const showFontSizeModal = () => emit('show-font-size');
const showColorPicker = () => emit('show-color-picker');
const addRectangle = () => emit('add-rectangle');
const addCircle = () => emit('add-circle');
const addLine = () => emit('add-line');
const bringForward = () => emit('bring-forward');
const sendBackward = () => emit('send-backward');
const copyObject = () => emit('copy');
const pasteObject = () => emit('paste');
const deleteObject = () => emit('delete');
const undo = () => emit('undo');
const redo = () => emit('redo');
const zoomIn = () => emit('zoom-in');
const zoomOut = () => emit('zoom-out');
const resetZoom = () => emit('reset-zoom');

const updateObjectProperty = (property, value) => {
  emit('update-property', { property, value });
};
</script>

<style scoped>
.image-editor-toolbar {
  background: #f8f9fa;
  border: 1px solid #dee2e6;
  border-radius: 4px;
  padding: 1rem;
}

.toolbar-section {
  display: flex;
  flex-direction: column;
  gap: 0.5rem;
}

.toolbar-title {
  font-size: 0.875rem;
  font-weight: 600;
  margin-bottom: 0.5rem;
  color: #495057;
}

.tool-group {
  display: flex;
  gap: 0.25rem;
  padding: 0.25rem;
  background: white;
  border-radius: 4px;
  border: 1px solid #e9ecef;
}

.properties-panel {
  border-top: 1px solid #dee2e6;
  padding-top: 1rem;
}

.property-group {
  margin-bottom: 0.75rem;
}

.property-group label {
  display: block;
  font-size: 0.75rem;
  font-weight: 500;
  margin-bottom: 0.25rem;
  color: #6c757d;
}

.btn-sm {
  padding: 0.25rem 0.5rem;
  font-size: 0.875rem;
}

.form-control-sm {
  font-size: 0.875rem;
}

.form-control[type="range"] {
  padding: 0;
}
</style>