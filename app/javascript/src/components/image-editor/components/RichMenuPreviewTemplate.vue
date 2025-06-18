<template>
  <div class="rich-menu-preview-template">
    <!-- Template 201: 3x2 Grid -->
    <table v-if="templateId === 201" class="preview-table">
      <tbody>
        <tr v-for="row in 2" :key="`row-${row}`">
          <td v-for="col in 3" :key="`col-${col}`" class="preview-cell">
            <div
              class="preview-area"
              :class="{ active: isActive(getIndex(row, col, 3)) }"
              :id="getObjectName(getIndex(row, col, 3))"
              @click="selectArea(getIndex(row, col, 3))"
            >
              <img :id="`preview_${getObjectName(getIndex(row, col, 3))}`" />
            </div>
          </td>
        </tr>
      </tbody>
    </table>

    <!-- Template 202: 2x2 Grid -->
    <table v-else-if="templateId === 202" class="preview-table">
      <tbody>
        <tr v-for="row in 2" :key="`row-${row}`">
          <td v-for="col in 2" :key="`col-${col}`" class="preview-cell-large">
            <div
              class="preview-area"
              :class="{ active: isActive(getIndex(row, col, 2)) }"
              :id="getObjectName(getIndex(row, col, 2))"
              @click="selectArea(getIndex(row, col, 2))"
            >
              <img :id="`preview_${getObjectName(getIndex(row, col, 2))}`" />
            </div>
          </td>
        </tr>
      </tbody>
    </table>

    <!-- Template 203: 1x3 Grid -->
    <table v-else-if="templateId === 203" class="preview-table">
      <tbody>
        <tr>
          <td v-for="col in 3" :key="`col-${col}`" class="preview-cell">
            <div
              class="preview-area"
              :class="{ active: isActive(col - 1) }"
              :id="getObjectName(col - 1)"
              @click="selectArea(col - 1)"
            >
              <img :id="`preview_${getObjectName(col - 1)}`" />
            </div>
          </td>
        </tr>
      </tbody>
    </table>

    <!-- Template 204: 1x2 Grid -->
    <table v-else-if="templateId === 204" class="preview-table">
      <tbody>
        <tr>
          <td v-for="col in 2" :key="`col-${col}`" class="preview-cell-large">
            <div
              class="preview-area"
              :class="{ active: isActive(col - 1) }"
              :id="getObjectName(col - 1)"
              @click="selectArea(col - 1)"
            >
              <img :id="`preview_${getObjectName(col - 1)}`" />
            </div>
          </td>
        </tr>
      </tbody>
    </table>

    <!-- Template 205: 2x1 Grid -->
    <table v-else-if="templateId === 205" class="preview-table">
      <tbody>
        <tr v-for="row in 2" :key="`row-${row}`">
          <td class="preview-cell-full">
            <div
              class="preview-area"
              :class="{ active: isActive(row - 1) }"
              :id="getObjectName(row - 1)"
              @click="selectArea(row - 1)"
            >
              <img :id="`preview_${getObjectName(row - 1)}`" />
            </div>
          </td>
        </tr>
      </tbody>
    </table>

    <!-- Template 206: Single Area -->
    <div v-else-if="templateId === 206" class="single-preview">
      <div
        class="preview-area active"
        :id="getObjectName(0)"
        @click="selectArea(0)"
      >
        <img :id="`preview_${getObjectName(0)}`" />
      </div>
    </div>
  </div>
</template>

<script>
export default {
  name: 'RichMenuPreviewTemplate',
  props: {
    templateId: {
      type: Number,
      required: true
    },
    objectLists: {
      type: Array,
      required: true
    },
    activeIndex: {
      type: Number,
      default: 0
    }
  },
  methods: {
    getIndex(row, col, cols) {
      return (row - 1) * cols + (col - 1);
    },
    getObjectName(index) {
      return this.objectLists[index]?.name || '';
    },
    isActive(index) {
      return index === this.activeIndex;
    },
    selectArea(index) {
      this.$emit('select', index);
    }
  }
};
</script>

<style scoped>
.rich-menu-preview-template {
  height: 100%;
  display: flex;
  align-items: center;
  justify-content: center;
}

.preview-table {
  width: 300px;
  border-collapse: collapse;
}

.preview-cell {
  width: 100px;
  height: 100px;
  padding: 2px;
}

.preview-cell-large {
  width: 150px;
  height: 100px;
  padding: 2px;
}

.preview-cell-full {
  width: 300px;
  height: 100px;
  padding: 2px;
}

.preview-area {
  width: 100%;
  height: 100%;
  border: 2px solid transparent;
  cursor: pointer;
  position: relative;
  overflow: hidden;
  transition: all 0.2s ease;
}

.preview-area:hover {
  border-color: #007bff;
  opacity: 0.8;
}

.preview-area.active {
  border-color: #28a745;
  box-shadow: 0 0 0 3px rgba(40, 167, 69, 0.25);
}

.preview-area img {
  width: 100%;
  height: 100%;
  object-fit: cover;
}

.single-preview {
  width: 300px;
  height: 200px;
}

.single-preview .preview-area {
  width: 100%;
  height: 100%;
}
</style>