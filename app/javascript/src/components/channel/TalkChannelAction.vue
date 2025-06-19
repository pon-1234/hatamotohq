<template>
  <div class="nav-element">
    <ul class="menu">
      <li class="all active" @click="onSearch">
        <button @click="openModal"><i class="fas fa-search"></i> すべて</button
      ></li>
    </ul>
  </div>
</template>
<script setup>
const emit = defineEmits(['input'])

const onSearch = () => {
  emit('input')
}

const openModal = () => {
  $('#TalkModalSearch').modal('show')
}
</script>
