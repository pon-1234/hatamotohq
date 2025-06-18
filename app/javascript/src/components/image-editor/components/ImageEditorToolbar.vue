<template>
  <div class="image-editor-toolbar">
    <div class="toolbar-section">
      <h6 class="toolbar-title">画像編集ツール</h6>
      
      <!-- Text Tools -->
      <div class="tool-group">
        <b-button
          v-b-tooltip.hover
          title="テキストを追加"
          variant="outline-secondary"
          size="sm"
          @click="addText"
        >
          <i class="fas fa-font"></i>
        </b-button>
        <b-button
          v-b-tooltip.hover
          title="フォントサイズ"
          variant="outline-secondary"
          size="sm"
          :disabled="!hasActiveObject"
          @click="showFontSizeModal"
        >
          <i class="fas fa-text-height"></i>
        </b-button>
        <b-button
          v-b-tooltip.hover
          title="フォントカラー"
          variant="outline-secondary"
          size="sm"
          :disabled="!hasActiveObject"
          @click="showColorPicker"
        >
          <i class="fas fa-palette"></i>
        </b-button>
      </div>

      <!-- Shape Tools -->
      <div class="tool-group">
        <b-button
          v-b-tooltip.hover
          title="四角形を追加"
          variant="outline-secondary"
          size="sm"
          @click="addRectangle"
        >
          <i class="far fa-square"></i>
        </b-button>
        <b-button
          v-b-tooltip.hover
          title="円を追加"
          variant="outline-secondary"
          size="sm"
          @click="addCircle"
        >
          <i class="far fa-circle"></i>
        </b-button>
        <b-button
          v-b-tooltip.hover
          title="線を追加"
          variant="outline-secondary"
          size="sm"
          @click="addLine"
        >
          <i class="fas fa-minus"></i>
        </b-button>
      </div>

      <!-- Layer Controls -->
      <div class="tool-group">
        <b-button
          v-b-tooltip.hover
          title="前面へ"
          variant="outline-secondary"
          size="sm"
          :disabled="!hasActiveObject"
          @click="bringForward"
        >
          <i class="fas fa-level-up-alt"></i>
        </b-button>
        <b-button
          v-b-tooltip.hover
          title="背面へ"
          variant="outline-secondary"
          size="sm"
          :disabled="!hasActiveObject"
          @click="sendBackward"
        >
          <i class="fas fa-level-down-alt"></i>
        </b-button>
      </div>

      <!-- Edit Controls -->
      <div class="tool-group">
        <b-button
          v-b-tooltip.hover
          title="コピー"
          variant="outline-secondary"
          size="sm"
          :disabled="!hasActiveObject"
          @click="copyObject"
        >
          <i class="fas fa-copy"></i>
        </b-button>
        <b-button
          v-b-tooltip.hover
          title="ペースト"
          variant="outline-secondary"
          size="sm"
          :disabled="!clipboard"
          @click="pasteObject"
        >
          <i class="fas fa-paste"></i>
        </b-button>
        <b-button
          v-b-tooltip.hover
          title="削除"
          variant="outline-danger"
          size="sm"
          :disabled="!hasActiveObject"
          @click="deleteObject"
        >
          <i class="fas fa-trash"></i>
        </b-button>
      </div>

      <!-- Undo/Redo -->
      <div class="tool-group">
        <b-button
          v-b-tooltip.hover
          title="元に戻す"
          variant="outline-secondary"
          size="sm"
          :disabled="!canUndo"
          @click="undo"
        >
          <i class="fas fa-undo"></i>
        </b-button>
        <b-button
          v-b-tooltip.hover
          title="やり直す"
          variant="outline-secondary"
          size="sm"
          :disabled="!canRedo"
          @click="redo"
        >
          <i class="fas fa-redo"></i>
        </b-button>
      </div>

      <!-- Zoom Controls -->
      <div class="tool-group">
        <b-button
          v-b-tooltip.hover
          title="ズームイン"
          variant="outline-secondary"
          size="sm"
          @click="zoomIn"
        >
          <i class="fas fa-search-plus"></i>
        </b-button>
        <b-button
          v-b-tooltip.hover
          title="ズームアウト"
          variant="outline-secondary"
          size="sm"
          @click="zoomOut"
        >
          <i class="fas fa-search-minus"></i>
        </b-button>
        <b-button
          v-b-tooltip.hover
          title="リセット"
          variant="outline-secondary"
          size="sm"
          @click="resetZoom"
        >
          <i class="fas fa-expand"></i>
        </b-button>
      </div>
    </div>

    <!-- Properties Panel -->
    <div v-if="activeObject" class="properties-panel mt-3">
      <h6 class="toolbar-title">プロパティ</h6>
      
      <div v-if="activeObject.type === 'text'" class="property-group">
        <label>フォントサイズ</label>
        <b-form-input
          type="number"
          v-model="activeObject.fontSize"
          size="sm"
          min="10"
          max="100"
          @change="updateObjectProperty('fontSize', $event)"
        />
      </div>

      <div class="property-group">
        <label>透明度</label>
        <b-form-input
          type="range"
          v-model="activeObject.opacity"
          min="0"
          max="1"
          step="0.1"
          @change="updateObjectProperty('opacity', $event)"
        />
      </div>

      <div class="property-group">
        <label>回転</label>
        <b-form-input
          type="range"
          v-model="activeObject.angle"
          min="0"
          max="360"
          @change="updateObjectProperty('angle', $event)"
        />
      </div>
    </div>
  </div>
</template>

<script>
export default {
  name: 'ImageEditorToolbar',
  props: {
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
  },
  methods: {
    addText() {
      this.$emit('add-text');
    },
    showFontSizeModal() {
      this.$emit('show-font-size');
    },
    showColorPicker() {
      this.$emit('show-color-picker');
    },
    addRectangle() {
      this.$emit('add-rectangle');
    },
    addCircle() {
      this.$emit('add-circle');
    },
    addLine() {
      this.$emit('add-line');
    },
    bringForward() {
      this.$emit('bring-forward');
    },
    sendBackward() {
      this.$emit('send-backward');
    },
    copyObject() {
      this.$emit('copy');
    },
    pasteObject() {
      this.$emit('paste');
    },
    deleteObject() {
      this.$emit('delete');
    },
    undo() {
      this.$emit('undo');
    },
    redo() {
      this.$emit('redo');
    },
    zoomIn() {
      this.$emit('zoom-in');
    },
    zoomOut() {
      this.$emit('zoom-out');
    },
    resetZoom() {
      this.$emit('reset-zoom');
    },
    updateObjectProperty(property, value) {
      this.$emit('update-property', { property, value });
    }
  }
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

:deep(.btn-sm) {
  padding: 0.25rem 0.5rem;
  font-size: 0.875rem;
}

:deep(.form-control-sm) {
  font-size: 0.875rem;
}
</style>