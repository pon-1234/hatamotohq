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
      <b-spinner variant="primary" />
      <p class="mt-2 text-muted">{{ loadingText }}</p>
    </div>

    <!-- Empty State -->
    <div v-else-if="!items.length" class="text-center py-5">
      <slot name="empty">
        <i class="fas fa-inbox fa-3x text-muted mb-3"></i>
        <p class="text-muted">{{ emptyText }}</p>
      </slot>
    </div>

    <!-- Table -->
    <div v-else class="table-responsive">
      <b-table
        :items="filteredItems"
        :fields="fields"
        :busy="busy"
        :striped="striped"
        :bordered="bordered"
        :hover="hover"
        :small="small"
        :fixed="fixed"
        :responsive="responsive"
        :sort-by.sync="sortBySync"
        :sort-desc.sync="sortDescSync"
        :per-page="perPage"
        :current-page="currentPage"
        :selectable="selectable"
        :select-mode="selectMode"
        @row-selected="onRowSelected"
        @row-clicked="onRowClicked"
        @sort-changed="onSortChanged"
      >
        <!-- Pass through all slots -->
        <template v-for="(_, slot) of $scopedSlots" v-slot:[slot]="scope">
          <slot :name="slot" v-bind="scope" />
        </template>
      </b-table>
    </div>

    <!-- Pagination -->
    <div v-if="paginate && totalRows > perPage" class="d-flex justify-content-between align-items-center mt-3">
      <div class="text-muted">
        表示 {{ paginationInfo.from }} - {{ paginationInfo.to }} / 全 {{ totalRows }} 件
      </div>
      <b-pagination
        v-model="currentPage"
        :total-rows="totalRows"
        :per-page="perPage"
        :limit="paginationLimit"
        class="mb-0"
        @change="onPageChange"
      />
    </div>
  </div>
</template>

<script>
export default {
  name: 'BaseTable',
  props: {
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
  },
  data() {
    return {
      searchQuery: '',
      currentPage: 1,
      sortBySync: this.sortBy,
      sortDescSync: this.sortDesc
    };
  },
  computed: {
    filteredItems() {
      if (!this.searchable || !this.searchQuery) {
        return this.items;
      }

      const query = this.searchQuery.toLowerCase();
      const searchFields = this.searchFields.length ? this.searchFields : Object.keys(this.items[0] || {});

      return this.items.filter(item => {
        return searchFields.some(field => {
          const value = this.getNestedProperty(item, field);
          return value && value.toString().toLowerCase().includes(query);
        });
      });
    },
    totalRows() {
      return this.filteredItems.length;
    },
    paginationInfo() {
      const from = (this.currentPage - 1) * this.perPage + 1;
      const to = Math.min(this.currentPage * this.perPage, this.totalRows);
      return { from, to };
    }
  },
  watch: {
    sortBy(val) {
      this.sortBySync = val;
    },
    sortDesc(val) {
      this.sortDescSync = val;
    },
    searchQuery() {
      this.currentPage = 1;
    }
  },
  methods: {
    getNestedProperty(obj, path) {
      return path.split('.').reduce((curr, prop) => curr?.[prop], obj);
    },
    onSearch() {
      this.$emit('search', this.searchQuery);
    },
    onRowSelected(items) {
      this.$emit('row-selected', items);
    },
    onRowClicked(item, index, event) {
      this.$emit('row-clicked', item, index, event);
    },
    onSortChanged(ctx) {
      this.$emit('sort-changed', ctx);
      this.$emit('update:sortBy', ctx.sortBy);
      this.$emit('update:sortDesc', ctx.sortDesc);
    },
    onPageChange(page) {
      this.$emit('page-change', page);
    },
    clearSelection() {
      this.$refs.table.clearSelected();
    },
    selectRow(index) {
      this.$refs.table.selectRow(index);
    }
  }
};
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