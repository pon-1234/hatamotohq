<template>
  <div>
     <div class="carousel-list">
      <div class="d-inline-flex align-items-center">
        <div v-for="(item, index) in data" :key="index" class="carousel-content">
          <div class="carousel-thumb" :style="{ backgroundImage: 'url(' + item.imageUrl + ')'}" v-if="item.imageUrl"></div>
          <div class="carousel-thumb-default" v-else>(画像未登録)</div>
          <div v-if="item.action && item.action.label" class="carousel-label">{{item.action.label}}</div>
        </div>
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
.carousel-list {
  max-width: 400px;
  overflow-x: auto;
  overflow-y: hidden;
  white-space: nowrap;
  margin: 0 0;
}

@media (max-width: 768px) {
  .carousel-list {
      max-width: 200px;
  }
}

.carousel-content{
  border-radius: 4px;
  background-color: white;
  cursor: pointer;
  width: 200px;
  margin-right: 5px;
  position: relative;

  .carousel-thumb {
    height: 200px;
    line-height: 159px;
    background-size: cover;
    background-position: center center;
    color: #aaa;
    text-align: center;
  }

  .carousel-thumb-default {
      height: 200px;
      line-height: 159px;
      color: #aaa;
      text-align: center;
  }

  .carousel-label {
    position: absolute;
    left: 50%;
    bottom: 5px;
    transform: translate(-50%,-50%);
    -webkit-transform: translate(-50%,-50%);
    -ms-transform: translate(-50%,-50%);
    background-color: black;
    opacity: 0.6;
    color: white;
    padding: 6px;
    border-radius: 12px;
    font-weight: bold;
  }
}

::-webkit-scrollbar {
  height: 5px;
}

/* Track */
::-webkit-scrollbar-track {
  background: #f1f1f1;
}

/* Handle */
::-webkit-scrollbar-thumb {
  background: #888;
}

/* Handle on hover */
::-webkit-scrollbar-thumb:hover {
  background: #555;
}
</style>
