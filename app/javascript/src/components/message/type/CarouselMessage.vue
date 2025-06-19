<template>
  <div>
    <div class="carousel-list">
      <div class="d-inline-flex align-items-center">
        <div v-for="(item, index) in data" :key="index" class="carousel-content">
          <div
            class="carousel-thumb"
            :style="{ backgroundImage: 'url(' + item.thumbnailImageUrl + ')' }"
            v-if="item.thumbnailImageUrl"
          ></div>
          <div class="carousel-heading">
            <b>{{ item.title }}</b>
            <p>{{ item.text }}</p>
          </div>
          <div class="carousel-action" v-for="(action, indexAction) in item.actions" :key="indexAction">
            <div class="carousel-action-label">
              {{ action.label }}
            </div>
          </div>
        </div>
      </div>
    </div>
  </div>
</template>
<script setup>
defineProps(['data'])
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

  .carousel-content {
    border: thin solid #ccc;
    border-radius: 4px;
    background-color: white;
    cursor: pointer;
    width: 200px;
    margin-right: 5px;

    .carousel-heading {
      text-align: left;
      b {
        display: block;
        padding: 0 0.5em;
        line-height: 2.5em;
        word-wrap: break-word;
        min-height: 2em;
        white-space: nowrap;
        overflow: hidden;
        text-overflow: ellipsis;
      }

      p {
        display: block;
        padding: 0 0.5em;
        border-bottom: thin solid #ccc;
        word-wrap: break-word;
        white-space: pre-line;
        margin-bottom: 0;
        line-height: 2.5em;
        min-height: 2em;
      }

      .carousel-text {
        // font-weight: bold;
        // color: red;
      }
    }

    .carousel-thumb {
      height: 130px;
      line-height: 159px;
      background-size: cover;
      background-position: center center;
      color: #aaa;
      text-align: center;
    }

    .carousel-thumb-default {
      height: 159px;
      line-height: 159px;
      color: #aaa;
      text-align: center;
    }

    .carousel-action {
      .carousel-action-label-default {
        color: #ccc;
      }
      .carousel-action-label {
        text-align: center;
        line-height: 2em;
        min-height: 2em;
        overflow: hidden;
        white-space: nowrap;
        text-overflow: ellipsis;
      }
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
