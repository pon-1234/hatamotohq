<template>
  <div class="base-table-wrapper">
    <!-- Table Header Actions -->
    <div v-if="$slots.actions || searchable" class="table-header mb-3">
      <div class="row">
        <div class="col-md-6">
          <slot name="actions" />
        </div>
        <div v-if="searchable" class="col-md-6">
          <div class="form-group mb-0">
            <input
              v-model="searchQuery"
              type="text"
              class="form-control"
              :placeholder="searchPlaceholder"
              @input="onSearch"
            >
          </div>
        </div>
      </div>
    </div>

    <!-- Loading State -->
    <div v-if="loading" class="text-center py-5">
      <BaseSpinner variant="primary" />
      <p class="mt-2 text-muted">{{ loadingText }}</p>
    </div>

    <!-- Empty State -->
    <div v-else-if="!paginatedItems.length" class="text-center py-5">
      <slot name="empty">
        <i class="fas fa-inbox fa-3x text-muted mb-3"></i>
        <p class="text-muted">{{ emptyText }}</p>
      </slot>
    </div>

    <!-- Table -->
    <div v-else class="table-responsive">
      <table class="table" :class="tableClasses">
        <thead>
          <tr>
            <th v-if="selectable" class="selection-column">
              <input
                v-if="selectMode === 'multi'"
                type="checkbox"
                class="form-check-input"
                :checked="isAllSelected"
                :indeterminate="isIndeterminate"
                @change="toggleSelectAll"
              >
            </th>
            <th
              v-for="field in normalizedFields"
              :key="field.key"
              :class="getHeaderClass(field)"
              @click="handleSort(field)"
            >
              <div class="d-flex align-items-center">
                <span>{{ field.label }}</span>
                <span v-if="field.sortable" class="sort-icon ms-1">
                  <i v-if="sortBySync === field.key && sortDescSync" class="fas fa-sort-down"></i>
                  <i v-else-if="sortBySync === field.key && !sortDescSync" class="fas fa-sort-up"></i>
                  <i v-else class="fas fa-sort text-muted opacity-50"></i>
                </span>
              </div>
            </th>
          </tr>
        </thead>
        <tbody>
          <tr
            v-for="(item, index) in paginatedItems"
            :key="item.id || index"
            :class="{ 'table-active': isRowSelected(item) }"
            @click="handleRowClick(item, index, $event)"
          >
            <td v-if="selectable" class="selection-column">
              <input
                type="checkbox"
                class="form-check-input"
                :checked="isRowSelected(item)"
                @click.stop
                @change="toggleRowSelection(item)"
              >
            </td>
            <td
              v-for="field in normalizedFields"
              :key="field.key"
              :class="getCellClass(field)"
            >
              <slot :name="`cell(${field.key})`" :value="getFieldValue(item, field)" :item="item" :field="field">
                {{ formatFieldValue(item, field) }}
              </slot>
            </td>
          </tr>
        </tbody>
      </table>
    </div>

    <!-- Pagination -->
    <div v-if="paginate && totalRows > perPage" class="d-flex justify-content-between align-items-center mt-3">
      <div class="text-muted">
        表示 {{ paginationInfo.from }} - {{ paginationInfo.to }} / 全 {{ totalRows }} 件
      </div>
      <nav aria-label="Table pagination">
        <ul class="pagination mb-0">
          <li class="page-item" :class="{ disabled: currentPage === 1 }">
            <button class="page-link" @click="changePage(currentPage - 1)" :disabled="currentPage === 1">
              前へ
            </button>
          </li>
          <li
            v-for="page in visiblePages"
            :key="page"
            class="page-item"
            :class="{ active: page === currentPage }"
          >
            <button class="page-link" @click="changePage(page)">
              {{ page }}
            </button>
          </li>
          <li class="page-item" :class="{ disabled: currentPage === totalPages }">
            <button class="page-link" @click="changePage(currentPage + 1)" :disabled="currentPage === totalPages">
              次へ
            </button>
          </li>
        </ul>
      </nav>
    </div>
  </div>
</template>

<script setup>
import { ref, computed, watch } from 'vue';
import BaseSpinner from './BaseSpinner.vue';

// Props
const props = defineProps({
  items: {
    type: Array,
    required: true
  },
  fields: {
    type: Array,
    required: true
  },
  loading: {
    type: Boolean,
    default: false
  },
  busy: {
    type: Boolean,
    default: false
  },
  striped: {
    type: Boolean,
    default: true
  },
  bordered: {
    type: Boolean,
    default: false
  },
  hover: {
    type: Boolean,
    default: true
  },
  small: {
    type: Boolean,
    default: false
  },
  fixed: {
    type: Boolean,
    default: false
  },
  responsive: {
    type: Boolean,
    default: true
  },
  selectable: {
    type: Boolean,
    default: false
  },
  selectMode: {
    type: String,
    default: 'multi',
    validator: (value) => ['single', 'multi', 'range'].includes(value)
  },
  searchable: {
    type: Boolean,
    default: false
  },
  searchPlaceholder: {
    type: String,
    default: '検索...'
  },
  searchFields: {
    type: Array,
    default: () => []
  },
  paginate: {
    type: Boolean,
    default: true
  },
  perPage: {
    type: Number,
    default: 20
  },
  paginationLimit: {
    type: Number,
    default: 5
  },
  sortBy: {
    type: String,
    default: null
  },
  sortDesc: {
    type: Boolean,
    default: false
  },
  emptyText: {
    type: String,
    default: 'データがありません'
  },
  loadingText: {
    type: String,
    default: '読み込み中...'
  }
});

// Emits
const emit = defineEmits([
  'search',
  'row-selected',
  'row-clicked',
  'sort-changed',
  'update:sortBy',
  'update:sortDesc',
  'page-change'
]);

// State
const searchQuery = ref('');
const currentPage = ref(1);
const sortBySync = ref(props.sortBy);
const sortDescSync = ref(props.sortDesc);
const selectedRows = ref([]);

// Computed
const normalizedFields = computed(() => {
  return props.fields.map(field => {
    if (typeof field === 'string') {
      return { key: field, label: field, sortable: true };
    }
    return {
      key: field.key,
      label: field.label || field.key,
      sortable: field.sortable !== false,
      thClass: field.thClass || '',
      tdClass: field.tdClass || '',
      formatter: field.formatter
    };
  });
});

const tableClasses = computed(() => ({
  'table-striped': props.striped,
  'table-bordered': props.bordered,
  'table-hover': props.hover,
  'table-sm': props.small
}));

const filteredItems = computed(() => {
  if (!props.searchable || !searchQuery.value) {
    return props.items;
  }

  const query = searchQuery.value.toLowerCase();
  const searchFields = props.searchFields.length ? props.searchFields : normalizedFields.value.map(f => f.key);

  return props.items.filter(item => {
    return searchFields.some(field => {
      const value = getNestedProperty(item, field);
      return value && value.toString().toLowerCase().includes(query);
    });
  });
});

const sortedItems = computed(() => {
  if (!sortBySync.value) {
    return filteredItems.value;
  }

  const sorted = [...filteredItems.value].sort((a, b) => {
    const aVal = getNestedProperty(a, sortBySync.value);
    const bVal = getNestedProperty(b, sortBySync.value);
    
    if (aVal === bVal) return 0;
    if (aVal === null || aVal === undefined) return 1;
    if (bVal === null || bVal === undefined) return -1;
    
    if (typeof aVal === 'string') {
      return aVal.localeCompare(bVal);
    }
    
    return aVal < bVal ? -1 : 1;
  });

  return sortDescSync.value ? sorted.reverse() : sorted;
});

const totalRows = computed(() => sortedItems.value.length);
const totalPages = computed(() => Math.ceil(totalRows.value / props.perPage));

const paginatedItems = computed(() => {
  if (!props.paginate) {
    return sortedItems.value;
  }
  
  const start = (currentPage.value - 1) * props.perPage;
  const end = start + props.perPage;
  return sortedItems.value.slice(start, end);
});

const paginationInfo = computed(() => {
  const from = (currentPage.value - 1) * props.perPage + 1;
  const to = Math.min(currentPage.value * props.perPage, totalRows.value);
  return { from, to };
});

const visiblePages = computed(() => {
  const pages = [];
  const half = Math.floor(props.paginationLimit / 2);
  let start = Math.max(1, currentPage.value - half);
  let end = Math.min(totalPages.value, start + props.paginationLimit - 1);
  
  if (end - start < props.paginationLimit - 1) {
    start = Math.max(1, end - props.paginationLimit + 1);
  }
  
  for (let i = start; i <= end; i++) {
    pages.push(i);
  }
  
  return pages;
});

const isAllSelected = computed(() => {
  return paginatedItems.value.length > 0 && paginatedItems.value.every(item => isRowSelected(item));
});

const isIndeterminate = computed(() => {
  return selectedRows.value.length > 0 && !isAllSelected.value;
});

// Methods
const getNestedProperty = (obj, path) => {
  return path.split('.').reduce((curr, prop) => curr?.[prop], obj);
};

const getFieldValue = (item, field) => {
  return getNestedProperty(item, field.key);
};

const formatFieldValue = (item, field) => {
  const value = getFieldValue(item, field);
  if (field.formatter) {
    return field.formatter(value, field.key, item);
  }
  return value ?? '';
};

const getHeaderClass = (field) => {
  return {
    [field.thClass]: field.thClass,
    'sortable': field.sortable,
    'cursor-pointer': field.sortable
  };
};

const getCellClass = (field) => {
  return field.tdClass || '';
};

const handleSort = (field) => {
  if (!field.sortable) return;
  
  if (sortBySync.value === field.key) {
    sortDescSync.value = !sortDescSync.value;
  } else {
    sortBySync.value = field.key;
    sortDescSync.value = false;
  }
  
  emit('sort-changed', {
    sortBy: sortBySync.value,
    sortDesc: sortDescSync.value
  });
  emit('update:sortBy', sortBySync.value);
  emit('update:sortDesc', sortDescSync.value);
};

const onSearch = () => {
  currentPage.value = 1;
  emit('search', searchQuery.value);
};

const isRowSelected = (item) => {
  return selectedRows.value.some(selected => {
    return JSON.stringify(selected) === JSON.stringify(item);
  });
};

const toggleRowSelection = (item) => {
  if (props.selectMode === 'single') {
    selectedRows.value = isRowSelected(item) ? [] : [item];
  } else {
    const index = selectedRows.value.findIndex(selected => 
      JSON.stringify(selected) === JSON.stringify(item)
    );
    if (index > -1) {
      selectedRows.value.splice(index, 1);
    } else {
      selectedRows.value.push(item);
    }
  }
  emit('row-selected', selectedRows.value);
};

const toggleSelectAll = () => {
  if (isAllSelected.value) {
    paginatedItems.value.forEach(item => {
      const index = selectedRows.value.findIndex(selected => 
        JSON.stringify(selected) === JSON.stringify(item)
      );
      if (index > -1) {
        selectedRows.value.splice(index, 1);
      }
    });
  } else {
    paginatedItems.value.forEach(item => {
      if (!isRowSelected(item)) {
        selectedRows.value.push(item);
      }
    });
  }
  emit('row-selected', selectedRows.value);
};

const handleRowClick = (item, index, event) => {
  emit('row-clicked', item, index, event);
};

const changePage = (page) => {
  if (page < 1 || page > totalPages.value) return;
  currentPage.value = page;
  emit('page-change', page);
};

// Watchers
watch(() => props.sortBy, (val) => {
  sortBySync.value = val;
});

watch(() => props.sortDesc, (val) => {
  sortDescSync.value = val;
});

watch(searchQuery, () => {
  currentPage.value = 1;
});

// Expose methods
defineExpose({
  clearSelection: () => {
    selectedRows.value = [];
    emit('row-selected', []);
  },
  selectRow: (index) => {
    if (index >= 0 && index < paginatedItems.value.length) {
      toggleRowSelection(paginatedItems.value[index]);
    }
  }
});
</script>

<style scoped>
.base-table-wrapper {
  background: white;
  border-radius: 8px;
  padding: 1.5rem;
  box-shadow: 0 1px 3px rgba(0, 0, 0, 0.1);
}

.table-header {
  border-bottom: 1px solid #dee2e6;
  padding-bottom: 1rem;
}

.table-responsive {
  margin: -1.5rem;
  padding: 1.5rem;
  overflow-x: auto;
}

.table {
  margin-bottom: 0;
}

.sortable {
  user-select: none;
}

.sort-icon {
  display: inline-flex;
  align-items: center;
}

.selection-column {
  width: 40px;
  text-align: center;
}

.cursor-pointer {
  cursor: pointer;
}

.opacity-50 {
  opacity: 0.5;
}

.page-link {
  cursor: pointer;
}

.page-item.disabled .page-link {
  cursor: not-allowed;
}

@media (max-width: 768px) {
  .base-table-wrapper {
    padding: 1rem;
  }
  
  .table-responsive {
    margin: -1rem;
    padding: 1rem;
  }
}
</style>