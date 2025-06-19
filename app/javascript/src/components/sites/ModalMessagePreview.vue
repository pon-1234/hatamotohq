<template>
  <div
    id="modalMessagePreview"
    class="modal fade"
    tabindex="-1"
    role="dialog"
    aria-labelledby="info-header-modalLabel"
    aria-hidden="true"
    ref="modalMessagePreview"
  >
    <div class="modal-dialog">
      <div class="modal-content" :key="contentKey">
        <div class="modal-header">
          <h5 class="modal-title" id="info-header-modalLabel">{{primaryLabel}}プレビュー</h5>
          <button type="button" class="close" data-dismiss="modal" aria-hidden="true">×</button>
        </div>
        <div class="modal-body modal-body-main">
          <div class="message-area">
            <TextMessage :data="`${message.content ? message.content.text : '' }`" />
          </div>
        </div>
        <div class="modal-body">
          <h5>URLクリック測定</h5>
          <table class="table table-striped">
            <thead>
              <tr>
                <th>サイト</th>
                <th>この{{primaryLabel}}</th>
                <th class="hidden-xs"></th>
              </tr>
            </thead>
            <tbody>
              <tr>
                <th>
                  <b>{{message.real_site_name}}</b><br />
                  <small>
                    <a :href="message.real_site_url" target="_blank"
                      >{{message.real_site_url}}</a
                    >
                  </small>
                </th>
                <td>
                  <b>{{message.visitor_count}}</b>人訪問 / <b>{{message.receiver_count}}</b>人<br />
                  <small>(計{{message.click_count}}クリック)</small>
                </td>
                <td class="hidden-xs">
                  <a :href="`/user/sites/${message.site_id}`" class="btn btn-warning btn-sm">サイトCV</a>
                </td>
              </tr>
            </tbody>
          </table>
        </div>
      </div>
    </div>
  </div>
</template>
<script setup>
import { ref, computed, onMounted } from 'vue'

const props = defineProps(['message', 'type'])

const contentKey = ref(0)
const modalMessagePreview = ref(null)

const primaryLabel = computed(() => {
  return props.type === 'scenario' ? 'シナリオ' : '一斉配信'
})

onMounted(() => {
  $(modalMessagePreview.value).on('show.bs.modal', onShow)
})

const forceRerender = () => {
  contentKey.value++
}

const onShow = async () => {
  forceRerender()
}
</script>
<style lang="scss" scoped>
  .modal-body-main {
    background-color: #ddd;
  }
  .message-area {
    background-color: white;
    border-radius: 4px;
    padding: 1em;
    width: 20em;
    margin: 1em auto;
    word-break: break-all;
  }
</style>