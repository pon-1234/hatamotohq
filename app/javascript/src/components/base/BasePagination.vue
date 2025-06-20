<template>
  <nav v-if="totalPages > 1" :aria-label="ariaLabel">
    <ul class="pagination" :class="sizeClass">
      <!-- First page button -->
      <li class="page-item" :class="{ disabled: isFirstPage }" v-if="firstLastButtons">
        <a
          class="page-link"
          href="#"
          @click.prevent="changePage(1)"
          :aria-disabled="isFirstPage"
          aria-label="Go to first page"
        >
          <span aria-hidden="true">{{ firstText }}</span>
        </a>
      </li>

      <!-- Previous page button -->
      <li class="page-item" :class="{ disabled: isFirstPage }" v-if="prevNextButtons">
        <a
          class="page-link"
          href="#"
          @click.prevent="changePage(currentPage - 1)"
          :aria-disabled="isFirstPage"
          aria-label="Go to previous page"
        >
          <span aria-hidden="true">{{ prevText }}</span>
        </a>
      </li>

      <!-- Page numbers with ellipsis -->
      <li
        v-for="page in pages"
        :key="page.number"
        class="page-item"
        :class="{
          active: page.number === currentPage,
          disabled: page.disabled
        }"
      >
        <span v-if="page.disabled" class="page-link">{{ ellipsisText }}</span>
        <a
          v-else
          class="page-link"
          href="#"
          @click.prevent="changePage(page.number)"
          :aria-label="`Go to page ${page.number}`"
          :aria-current="page.number === currentPage ? 'page' : null"
        >
          {{ page.number }}
        </a>
      </li>

      <!-- Next page button -->
      <li class="page-item" :class="{ disabled: isLastPage }" v-if="prevNextButtons">
        <a
          class="page-link"
          href="#"
          @click.prevent="changePage(currentPage + 1)"
          :aria-disabled="isLastPage"
          aria-label="Go to next page"
        >
          <span aria-hidden="true">{{ nextText }}</span>
        </a>
      </li>

      <!-- Last page button -->
      <li class="page-item" :class="{ disabled: isLastPage }" v-if="firstLastButtons">
        <a
          class="page-link"
          href="#"
          @click.prevent="changePage(totalPages)"
          :aria-disabled="isLastPage"
          aria-label="Go to last page"
        >
          <span aria-hidden="true">{{ lastText }}</span>
        </a>
      </li>
    </ul>
  </nav>
</template>

<script setup>
import { computed } from 'vue'

const props = defineProps({
  modelValue: {
    type: Number,
    default: 1
  },
  totalRows: {
    type: Number,
    required: true
  },
  perPage: {
    type: Number,
    default: 20
  },
  limit: {
    type: Number,
    default: 5
  },
  firstLastButtons: {
    type: Boolean,
    default: false
  },
  prevNextButtons: {
    type: Boolean,
    default: true
  },
  ellipsisText: {
    type: String,
    default: '…'
  },
  firstText: {
    type: String,
    default: '«'
  },
  prevText: {
    type: String,
    default: '‹'
  },
  nextText: {
    type: String,
    default: '›'
  },
  lastText: {
    type: String,
    default: '»'
  },
  size: {
    type: String,
    default: null,
    validator: (value) => ['sm', 'lg', null].includes(value)
  },
  ariaLabel: {
    type: String,
    default: 'Pagination'
  },
  align: {
    type: String,
    default: null,
    validator: (value) => ['left', 'center', 'right', 'fill', null].includes(value)
  }
})

const emit = defineEmits(['update:modelValue', 'change'])

const currentPage = computed({
  get: () => props.modelValue,
  set: (value) => {
    emit('update:modelValue', value)
    emit('change', value)
  }
})

const totalPages = computed(() => {
  return Math.ceil(props.totalRows / props.perPage)
})

const isFirstPage = computed(() => currentPage.value === 1)
const isLastPage = computed(() => currentPage.value === totalPages.value)

const sizeClass = computed(() => {
  const classes = []
  if (props.size === 'sm') classes.push('pagination-sm')
  if (props.size === 'lg') classes.push('pagination-lg')
  
  if (props.align) {
    const alignMap = {
      left: 'justify-content-start',
      center: 'justify-content-center',
      right: 'justify-content-end',
      fill: 'justify-content-between'
    }
    classes.push(alignMap[props.align])
  }
  
  return classes
})

const pages = computed(() => {
  const pages = []
  const total = totalPages.value
  const current = currentPage.value
  const limit = props.limit

  if (total <= limit + 2) {
    // Show all pages if total is small
    for (let i = 1; i <= total; i++) {
      pages.push({ number: i, disabled: false })
    }
  } else {
    // Always show first page
    pages.push({ number: 1, disabled: false })

    const half = Math.floor(limit / 2)
    let start = current - half
    let end = current + half

    // Adjust if near the beginning
    if (start <= 2) {
      start = 2
      end = Math.min(limit + 1, total - 1)
    }
    // Adjust if near the end
    else if (end >= total - 1) {
      end = total - 1
      start = Math.max(total - limit, 2)
    }

    // Add ellipsis if needed at the beginning
    if (start > 2) {
      pages.push({ number: '...', disabled: true })
    }

    // Add page numbers
    for (let i = start; i <= end; i++) {
      pages.push({ number: i, disabled: false })
    }

    // Add ellipsis if needed at the end
    if (end < total - 1) {
      pages.push({ number: '...', disabled: true })
    }

    // Always show last page
    if (total > 1) {
      pages.push({ number: total, disabled: false })
    }
  }

  return pages
})

const changePage = (page) => {
  if (page < 1 || page > totalPages.value || page === currentPage.value) {
    return
  }
  currentPage.value = page
}
</script>

<style scoped>
.page-item.disabled .page-link {
  cursor: not-allowed;
}

.page-item.active .page-link {
  z-index: 1;
}
</style> 