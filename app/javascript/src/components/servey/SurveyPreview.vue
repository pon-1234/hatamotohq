<template>
    <section style="padding: 20px; position: fixed; top: 0; right: 0; z-index: 100000; background: #ededed; overflow: auto; height: 200px; width: 100%">
        {{data}}
    </section>
</template>

<script>
export default {
  props: ['data']
};
</script>
<style lang="scss" scoped>
    ::v-deep {
    }
</style>
