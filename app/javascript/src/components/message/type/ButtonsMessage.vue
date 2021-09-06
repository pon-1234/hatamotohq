<template>
  <div>
    <div class="buttons-content">
      <div class="buttons-header">
        <b class="buttons-title">{{data.title}}</b>
        <span class="buttons-text">
          {{data.text}}
        </span>
      </div>

      <div v-for="(item, index) in data.actions" :key="index" class="selector-button">
        {{item.label? item.label :  "&nbsp;"  }}
      </div>
    </div>
  </div>
</template>
<script>
export default {
  props: ['data']
};
</script>
<style lang="scss" scoped>
::v-deep {
  .buttons-content{
    border: thin solid #ccc;
    border-radius: 10px;
    width: 200px;
    background: white;
    display: inline-block;
    word-break: break-word;
    white-space: initial;
    text-align: left;
  }

  .buttons-title{
    display: block;
    padding: 8px 12px;
    line-height: 2em;
    word-wrap: break-word;
  }

  .buttons-text{
    display: block;
    padding: 8px 12px;
    word-wrap: break-word;
  }

  .selector-button{
    color: #3e6292;
    text-align: center;
    line-height: 3;
    overflow: hidden;
    white-space: nowrap;
    text-overflow: ellipsis;
    cursor: pointer;
    border-top: thin solid #ccc;
  }
}
</style>
