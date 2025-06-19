<template>
  <div
    class="modal fade"
    id="modalSendTemplate"
    tabindex="-1"
    role="dialog"
    aria-labelledby="myModalLabel"
    aria-hidden="true"
  >
    <div class="modal-dialog modal-xl vh-90 modal-dialog-scrollable" role="document">
      <div class="modal-content">
        <div class="modal-header">
          <h5 class="modal-title">テンプレートを選択してください</h5>
          <button type="button" class="close" data-dismiss="modal" aria-label="Close">
            <span aria-hidden="true">×</span>
          </button>
        </div>
        <div class="modal-body">
          <div class="d-flex" v-if="folders && folders.length">
            <folder-left
              type="template_message"
              :isPerview="true"
              :data="folders"
              :isPc="isPc"
              :selectedFolder="selectedFolder"
              @changeSelectedFolder="changeTemplateFolder"
            />
            <div class="flex-grow-1">
              <div class="table-responsive">
                <table class="table table-hover">
                  <thead class="thead-light">
                    <tr>
                      <th>
                        <span v-if="folders[selectedFolder]">{{ folders[selectedFolder].name }}</span>
                      </th>
                    </tr>
                  </thead>
                  <tbody v-if="folders[selectedFolder].templates && folders[selectedFolder].templates.length">
                    <tr
                      v-for="(item, index) in folders[selectedFolder].templates"
                      :key="index"
                      class="folder-item"
                    >
                      <td class="d-flex w-100">
                        <div class="item-name">{{ item.name }}</div>
                        <div
                          class="btn btn-info btn-sm text-nowrap ml-auto"
                          data-dismiss="modal"
                          @click="selectTemplate(item)"
                        >
                          送信
                        </div>
                      </td>
                    </tr>
                  </tbody>
                  <tbody v-else>
                    <tr>
                      <td class="text-center mt-5">
                        <b>登録テンプレートはありません。</b>
                      </td>
                    </tr>
                  </tbody>
                </table>
              </div>
            </div>
          </div>
          <div v-else class="my-5 text-center font-weight-bold">登録したテンプレートはありません。</div>
        </div>
      </div>
    </div>
  </div>
</template>

<script setup>
import { ref, computed, onBeforeMount } from 'vue'
import { useStore } from 'vuex'

const emit = defineEmits(['sendTemplate'])

const store = useStore()

const selectedFolder = ref(0)
const isPc = ref(true)

const folders = computed(() => store.state.template.folders)

onBeforeMount(async () => {
  await store.dispatch('template/getTemplates')
})

const backToFolder = () => {
  isPc.value = false
}

const selectTemplate = (template) => {
  const data = JSON.parse(JSON.stringify(template))
  emit('sendTemplate', data)
}

const changeTemplateFolder = (index) => {
  selectedFolder.value = index
  isPc.value = true
}
</script>
<style style="scss" scoped>
  .item-name {
    width: 85%;
    white-space: nowrap;
    overflow: hidden;
    text-overflow: ellipsis;
  }
</style>