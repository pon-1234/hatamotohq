<template>
  <div class="location-content">
      <img
        class="image-location"
        :src="getImageMap()"
      />
    <div class="location-info">
      <div class="location-title">{{data.title}}</div>
      <div class="location-address">{{data.address}}</div>
    </div>
  </div>
</template>

<script setup>
const props = defineProps(['data'])

const getImageMap = () => {
  return 'https://maps.googleapis.com/maps/api/staticmap?center=' + props.data.latitude + ',' + props.data.longitude + '&zoom=10&size=200x120' + '&markers=color:red%7Clabel:C%7C' + props.data.latitude + ',' + props.data.longitude + '&key=' + import.meta.env.VITE_GOOGLE_MAP_KEY
}
</script>
<style lang="scss" scoped>
:deep(){

  .location-title {
    font-weight: bold;
    padding: 10px 0px;
  }

  .location-address{
    font-size: 12px;
  }

  .location-info {
    padding: 10px 8px;
  }
}

.location-content {
  display: inline-flex;
  flex-direction: column;
  width: 200px;
  border: thin solid #ccc;
  border-radius: 10px;
  overflow: hidden;
  background: white;
}
</style>
