<template>
  <div class="bg-light d-flex overflow-x-auto">
    <sticker-package
      class="mr-1"
      v-for="(option, index) in options"
      v-bind:data="option"
      :key="index"
      @input="changePackageId"
    ></sticker-package>
  </div>
</template>
<script setup>
import { ref } from 'vue'

const emit = defineEmits(['input'])

const options = ref([
  {
    packageId: null,
    animation: false,
    icon: 'mdi mdi-history icon',
    active: true
  },
  {
    packageId: 11537,
    animation: true,
    active: false
  },
  {
    packageId: 11538,
    animation: true,
    active: false
  },
  {
    packageId: 11539,
    animation: false,
    active: false
  }
])

const defaultActive = () => {
  options.value.forEach(element => {
    element.active = !element.packageId
  })
}

const changePackageId = (packageId) => {
  options.value.forEach(element => {
    element.active = element.packageId === packageId
  })
  const option = options.value.find(item => item.packageId === packageId)
  emit('input', option)
}

defineExpose({
  defaultActive
})
</script>

<style  lang='scss'  scoped>
  :deep() {
    .icon {
      font-size: 1.5rem;
    }

    .sticker-nav {
      overflow: hidden;
      flex: 0 0 40px;
      height: 33px;
      display: flex;
      align-items: center;
      justify-content: center;
      color: #666f86;
      filter: grayscale(100%);
    }

    .sticker-nav.active,
    .sticker-nav.active:not(.disabled) {
      background: rgba(102, 111, 134, 0.25);
      filter: grayscale(0);
    }

    .sticker-nav.sticker-nav-animation:after {
      content: "";
      width: 13px;
      height: 13px;
      -webkit-filter: grayscale(0);
      filter: grayscale(0);
      position: absolute;
      right: 2px;
      top: 2px;
      background: url("data:image/svg+xml;charset=utf-8,%3Csvg xmlns='http://www.w3.org/2000/svg' viewBox='0 0 500 500'%3E%3Ctitle%3Eplay-circle%3C/title%3E%3Cpath d='M250 492.5A242.5 242.5 0 0 1 78.526 78.526a242.5 242.5 0 0 1 342.948 342.948A240.92 240.92 0 0 1 250 492.5z' fill='%23fff'/%3E%3Cpath d='M250 15a235.066 235.066 0 0 1 91.468 451.539A235.065 235.065 0 0 1 158.532 33.461 233.515 233.515 0 0 1 250 15m0-15C111.929 0 0 111.929 0 250s111.929 250 250 250 250-111.929 250-250S388.071 0 250 0z' fill='%23aaa'/%3E%3Cpath d='M359.581 246.114a18.792 18.792 0 0 0-8.713-12.082L189.536 137.5a19.815 19.815 0 0 0-10.2-2.806A19.065 19.065 0 0 0 160 153.412v193.151a18.389 18.389 0 0 0 3.182 10.284 19.51 19.51 0 0 0 16.11 8.458 20 20 0 0 0 10.257-2.847l161.239-96.568a19.459 19.459 0 0 0 5.987-5.612 18.055 18.055 0 0 0 2.806-14.164z' fill='%23464f69'/%3E%3C/svg%3E");
    }
  }
</style>
