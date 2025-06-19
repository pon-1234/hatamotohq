<template>
  <div class="mt-2">
    <div class="d-flex align-items-center">
      <button :disabled="notUseShorternUrl" @click="searchSites" class="btn btn-primary mw-200">読み込み</button>
      <div class="checkbox-inline ml-3">
        <div class="custom-control custom-checkbox mr-4" @click="changeShortenUrlUsage">
          <input
            type="checkbox"
            :value="true"
            v-model="notUseShorternUrl"
            class="custom-control-input"
          />
          <label class="custom-control-label text-nowrap">このメッセージではURLを短縮しない</label>
        </div>
      </div>
    </div>
    <div class="row" v-show="sitesInMessageContent && sitesInMessageContent.length">
      <div :class="`mt-2 ${showConfigUrlPanel ? 'col-sm-6' : 'col'}`" v-show="!notUseShorternUrl">
        <table class="table table-centered mb-0">
          <thead>
            <tr>
              <th style="width: 50%">サイト名</th>
              <th style="width: 30%" :class="`d-none ${showConfigUrlPanel ? '' : 'd-md-table-cell'}`" v-show="!showConfigUrlPanel">訪問時</th>
              <th></th>
            </tr>
          </thead>
          <tbody>
            <tr v-for="(site, index) in sitesInMessageContent" :key="site.id" :class="`site-row ${selectedSiteIndex === index ? 'selected' : ''}`">
              <td>
                <p class="mxw-400"><strong>{{site.name}}</strong></p>
                <span>{{site.url}}</span>
              </td>
              <td :class="`d-none ${showConfigUrlPanel ? '' : 'd-md-table-cell'}`" v-show="!showConfigUrlPanel">
                <ChoseActionsPresentor :actions="getActionOfSite(site)"></ChoseActionsPresentor>
              </td>
              <td>
                <div class="float-right d-flex flex-column" v-if="!showConfigUrlPanel">
                  <button @click="selectSite(index)" v-if="!mutationSiteMeasurements.find((siteMeasurement) => siteMeasurement.site_id === site.id)" class="btn btn-sm btn-secondary mw-100 mb-1">登録</button>
                  <span v-else>
                    <button @click="selectSite(index)" class="btn btn-sm btn-primary mw-100">設定</button>
                    <button data-toggle="modal" :data-target="`#modalDeleteSiteMeasurement_${site.id}`" class="btn btn-sm btn-outline-danger mw-100">削除</button>
                  </span>
                </div>
              </td>

              <modal-confirm
                title="このサイト設定を削除してもよろしいですか？"
                :id="`modalDeleteSiteMeasurement_${site.id}`"
                type="delete"
                @confirm="removeSite(site)"
              >
              </modal-confirm>

            </tr>
          </tbody>
        </table>
      </div>
      <div class="col-sm-6" v-show="showConfigUrlPanel" v-if="sitesInMessageContent[selectedSiteIndex]">
        <ValidationObserver ref="observer" v-slot="{ validate }">
          <div class="panel panel-default border p-2 rounded">
            <div class="mb-2">
              <b>サイト設定</b> <small>URL:<span>{{sitesInMessageContent[selectedSiteIndex].url}}</span></small>
            </div>
            <div class="panel-body">
              <div>
                <ValidationProvider
                    :name="'サイト登録名'"
                    :rules="'max:255'"
                    v-slot="{ errors }"
                >
                  <div class="form-group">
                    <b>サイト登録名</b>
                    <input v-model="siteName" type="text" class="form-control" maxlength="255">
                    <span class="error-explanation">{{ errors[0] }}</span>
                  </div>
                </ValidationProvider>
                <div class="form-group"><b>リダイレクト設定</b> <br>
                  (元)
                  <a target="_blank" :href="sitesInMessageContent[selectedSiteIndex].url">{{sitesInMessageContent[selectedSiteIndex].url}}</a>
                  <ValidationProvider
                    :name="'リダイレクトURL'"
                    :rules="'url'"
                    v-slot="{ errors }"
                  >
                    <div class="input-group">
                      <span class="input-group-text">(変更) -&gt;</span>
                      <input v-model="redirectUrl" type="text" placeholder="http://example.com" class="form-control">
                    </div>
                    <span class="error-explanation">{{ errors[0] }}</span>
                  </ValidationProvider>
                  <p><small class="form-help">
                    転送先を変更します。<br><b style="color: red;">記録は元(変更前)のURLへのアクセスとしてカウントされます</b>
                  </small></p>
                </div>
                <div class="form-group">
                  <div class="has-modal-xl">
                    <div class="row">
                      <div class="col">
                        <action-editor-custom
                          :requiredLabel="requiredLabel"
                          :showTitle="showTitle"
                          :showLaunchMessage="false"
                          :value="actionData"
                          :key="contentKey"
                          @input="updateAction"
                        />
                      </div>
                    </div>
                  </div>
                </div>
              </div>
            </div>
            <div class="panel-footer">
              <button @click="showConfigUrlPanel = false; selectedSiteIndex = null" type="button" class="btn btn-danger float-left">閉じる</button>
              <button type="button" class="btn btn-success float-right" @click="validate().then(configUrl)">設定する</button>
              <div class="clearfix"></div>
            </div>
          </div>
        </ValidationObserver>
      </div>
    </div>
  </div>
</template>
<script setup>
import { ref, computed, onMounted } from 'vue'
import { useStore } from 'vuex'
import { flatten, cloneDeep, find, remove } from 'lodash'

const props = defineProps({
  messageContent: Object,
  index: Number,
  siteMeasurements: Array
})

const emit = defineEmits(['changeShortenUrlUsage', 'configured'])

const store = useStore()

const notUseShorternUrl = ref(false)
const showConfigUrlPanel = ref(false)
const selectedSiteIndex = ref(null)
const siteName = ref(null)
const redirectUrl = ref(null)
const currentSiteMeasurementId = ref(null)
const actionData = ref(null)
const mutationSiteMeasurements = ref([])
const contentKey = ref(0)
const requiredLabel = ref(false)
const showTitle = ref(false)

const sites = computed(() => flatten(store.state.site.folders.map((folder) => folder.sites)))
const sitesInMessageContent = computed(() => {
  return sites.value.filter(site => props.messageContent.text.includes(site.url)) || []
})

onMounted(() => {
  if (props.siteMeasurements) mutationSiteMeasurements.value = cloneDeep(props.siteMeasurements)
})
const changeShortenUrlUsage = () => {
  notUseShorternUrl.value = !notUseShorternUrl.value
  if (notUseShorternUrl.value) { showConfigUrlPanel.value = false }
  emit('changeShortenUrlUsage', { index: props.index, notUseShorternUrl: notUseShorternUrl.value })
}

const searchSites = async () => {
  await store.dispatch('site/getSites')
}

const selectSite = (index) => {
  showConfigUrlPanel.value = true
  selectedSiteIndex.value = index
  if (mutationSiteMeasurements.value && mutationSiteMeasurements.value.length) {
    const currentSiteMeasurement = find(mutationSiteMeasurements.value, siteMeasurement => siteMeasurement.site_id === sitesInMessageContent.value[selectedSiteIndex.value].id)
    if (!currentSiteMeasurement) {
      siteName.value = sitesInMessageContent.value[selectedSiteIndex.value].name
      return
    }
    currentSiteMeasurementId.value = currentSiteMeasurement.id
    siteName.value = currentSiteMeasurement.site_name
    redirectUrl.value = currentSiteMeasurement.redirect_url
    actionData.value = currentSiteMeasurement.actions
    if (currentSiteMeasurement.actions && currentSiteMeasurement.actions.length) {
      actionData.value = currentSiteMeasurement.actions[0]
      forceRerenderActionForm()
    }
  } else {
    siteName.value = sitesInMessageContent.value[selectedSiteIndex.value].name
  }
}

const removeSite = (site) => {
  const siteMeasurements = cloneDeep(mutationSiteMeasurements.value)
  remove(siteMeasurements, (siteMeasurement) => siteMeasurement.site_id.toString() === site.id.toString())
  currentSiteMeasurementId.value = null
  siteName.value = null
  redirectUrl.value = null
  actionData.value = null
  mutationSiteMeasurements.value = siteMeasurements
  emit('configured', { index: props.index, content: mutationSiteMeasurements.value })
}

const configUrl = async () => {
  // Since we're removing vee-validate, we'll skip validation for now
  showConfigUrlPanel.value = false
  const urlConfigObject = { 
    id: currentSiteMeasurementId.value, 
    site_name: siteName.value, 
    redirect_url: redirectUrl.value, 
    site_id: sitesInMessageContent.value[selectedSiteIndex.value].id, 
    actions: [actionData.value] 
  }
  const currentSiteMeasurement = find(mutationSiteMeasurements.value, siteMeasurement => siteMeasurement.site_id === sitesInMessageContent.value[selectedSiteIndex.value].id)
  if (currentSiteMeasurement) {
    Object.assign(currentSiteMeasurement, urlConfigObject)
  } else {
    mutationSiteMeasurements.value.push(urlConfigObject)
  }

  emit('configured', { index: props.index, content: mutationSiteMeasurements.value })
  actionData.value = null
  forceRerenderActionForm()
}

const updateAction = (actions) => {
  actionData.value = actions
}

const getActionOfSite = (site) => {
  const siteMeasurement = find(mutationSiteMeasurements.value, siteMeasurement => siteMeasurement.site_id === site.id)
  if (!siteMeasurement || !siteMeasurement.actions.length || siteMeasurement.actions[0] === null) return []
  return siteMeasurement.actions[0].data.actions
}

const forceRerenderActionForm = () => {
  contentKey.value++
}
</script>

<style lang="scss" scoped>
  .site-row.selected {
    background-color: #fcf8e3;
  }
  :deep() {
    .config-score-container {
      overflow-x: scroll;
    }
  }
</style>
