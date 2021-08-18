<template>
  <div :class="className ? className+' chat-log-content': 'chat-log-content'">
    <span>{{time}}</span>
    <br>
    <span>{{data}}</span>
  </div>
</template>
<script>
export default {
  props: ['data', 'time', 'className']
};
</script>

<style lang='scss' >
.chat-log-content {
    background: #f0f0f0;
    color: #7d7c7c;
    border-radius: 0.75rem;
    padding: 5px;
    text-align: center;
}
</style>
