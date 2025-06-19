<template>
  <div>
    <div class="confirm-content">
      <div class="confirm-header">
        <b class="buttons-title">{{data.text}}&nbsp;</b>
      </div>

      <div class="d-flex">
        <div v-for="(item, index) in data.actions" :key="index" class="d-flex button-item align-items-center justify-content-center btn-content-break">
          {{item.label}}&nbsp;
        </div>
      </div>
    </div>
  </div>
</template>
<script setup>
defineProps(['data'])
</script>
<style lang="scss" scoped>
.confirm-content{
  border-radius: 10px;
  width: 200px;
  background: white;
  border: thin solid #ccc;
  display: inline-block;
}

.confirm-header{
  padding: 8px 12px;
  line-height: 1.5;
  font-size: 1.2em;
  word-break: break-word;
  white-space: initial;
  text-align: left;
}

.button-item {
  cursor: pointer;
  flex-grow: 1;
  padding: 10px;
  border-top: 1px solid #ccc;
  width: 50%;
}

.button-item:first-child {
  border-right: 1px solid #ccc;
}

.btn-content-break {
  word-break: break-all;
}

</style>
