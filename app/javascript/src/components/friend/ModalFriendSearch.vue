<template>
  <div
    id="modalFriendSearch"
    ref="modalFriendSearch"
    class="modal fade"
    tabindex="-1"
    role="dialog"
    aria-labelledby="info-header-modalLabel"
    aria-hidden="true"
  >
    <div class="modal-dialog modal-lg" :key="contentKey">
      <div class="modal-content">
        <div class="modal-header">
          <h5 class="modal-title" id="info-header-modalLabel">詳細検索</h5>
          <button type="button" class="close" data-dismiss="modal" aria-hidden="true" @click="closeModal()">×</button>
        </div>
        <div class="modal-body">
          <!-- 名前検索 -->
          <div class="row form-group">
            <div class="col-lg-4">名前</div>
            <div class="col-lg-8">
              <input
                type="text"
                id="name"
                v-model="keyword"
                class="form-control"
                placeholder="LINE登録名、表示名から検索"
                maxlength="64"
              />
            </div>
          </div>
          <!-- タグ検索 -->
          <div class="row form-group">
            <div class="col-lg-4">タグ</div>
            <div class="col-lg-8">
              <input-tag
                ref="inputTag"
                :tags="selectedTags"
                :tagIds="queryParams.tags_id_in"
                @input="onSelectTags"
                :allTags="true"
              />
            </div>
          </div>
          <!-- 登録日時 -->
          <div class="row form-group">
            <div class="col-lg-4">登録日時</div>
            <div class="col-lg-8">
              <daterange-picker class="d-block" :start_date.sync="created_at_gteq" :end_date.sync="created_at_lteq">
              </daterange-picker>
            </div>
          </div>

          <div class="row form-group">
            <div class="col-lg-4">状況</div>
            <div class="col-lg-8">
              <select class="form-control" v-model="status_eq">
                <option value="">すべて</option>
                <option value="active">有効</option>
                <option value="blocked">ブロックされた</option>
              </select>
            </div>
          </div>

          <div class="row form-group">
            <div class="col-lg-4">担当者</div>
            <div class="col-lg-8">
              <staff-selection
                :mode="'filter'"
                :selected="queryParams.channel_assignee_id_eq"
                @select="setAssigneeParam"
              ></staff-selection>
            </div>
          </div>

          <!-- ブロック、非表示した友達 -->
          <div class="mt-2 d-flex">
            <div class="flex-1 custom-control custom-checkbox mr-2">
              <input
                type="checkbox"
                class="custom-control-input"
                id="lockedFriendCheck"
                v-model="locked_eq"
                :true-value="null"
                :false-value="false"
              />
              <label class="custom-control-label" for="lockedFriendCheck">ブロックした人を表示</label>
            </div>

            <div class="flex-1 custom-control custom-checkbox">
              <input
                type="checkbox"
                class="custom-control-input"
                id="hiddenFriendCheck"
                v-model="visible_eq"
                :true-value="null"
                :false-value="true"
              />
              <label class="custom-control-label" for="hiddenFriendCheck">非表示した人を表示</label>
            </div>

          </div>
          <div class="custom-control custom-checkbox mt-2">
            <input
                type="checkbox"
                class="custom-control-input"
                v-model="selectOnlyTester"
                value="true"
                name="tester"
                id="selectOnlyTesterCb"
              />
            <label class="custom-control-label" for="selectOnlyTesterCb">テスターのみ</label>
          </div>
        </div>
        <div class="modal-footer d-flex">
          <button type="button" class="btn btn-sm btn-light" @click="resetSearch()">リセット</button>
          <button type="button" class="btn btn-sm btn-light ml-auto" data-dismiss="modal" @click="closeModal()">
            キャンセル
          </button>
          <button type="button" class="btn btn-sm btn-info" data-dismiss="modal" @click="search">検索</button>
        </div>
      </div>
      <!-- /.modal-content -->
    </div>
    <!-- /.modal-dialog -->
  </div>
  <!-- /.modal -->
</template>
<script setup>
import { ref, computed, watch } from 'vue'
import { useStore } from 'vuex'

const props = defineProps(['selectOnlyTester'])
const emit = defineEmits(['changeSelectOnlyTester'])

const store = useStore()
const contentKey = ref(0)
const selectedTags = ref([])
const params = ref({})
const inputTag = ref(null)

const queryParams = computed(() => store.state.friend.queryParams)
const clearQueryParams = computed(() => store.state.friend.clearQueryParams)

const keyword = computed({
  get() {
    return params.value.line_name_or_display_name_cont
  },
  set(value) {
    params.value.line_name_or_display_name_cont = value
  }
})

const tags = computed({
  get() {
    return params.value.tags_id_in || []
  },
  set(value) {
    const selectedTagIds = value.map(_ => _.id)
    params.value.tags_id_in = selectedTagIds
  }
})

const status_eq = computed({
  get() {
    return params.value.status_eq
  },
  set(value) {
    params.value.status_eq = value
  }
})

const created_at_gteq = computed({
  get() {
    return params.value.created_at_gteq
  },
  set(value) {
    params.value.created_at_gteq = value
  }
})

const created_at_lteq = computed({
  get() {
    return params.value.created_at_lteq
  },
  set(value) {
    params.value.created_at_lteq = value
  }
})

const locked_eq = computed({
  get() {
    return params.value.locked_eq
  },
  set(value) {
    params.value.locked_eq = value
  }
})

const visible_eq = computed({
  get() {
    return params.value.visible_eq
  },
  set(value) {
    params.value.visible_eq = value
  }
})

const forceRerender = () => {
  contentKey.value++
}

const onSelectTags = (tagsData) => {
  tags.value = tagsData
  selectedTags.value = tagsData
}

const search = () => {
  store.commit('friend/setQueryParams', params.value)
  store.dispatch('friend/getFriends')
}

const resetSearch = () => {
  store.commit('friend/resetQueryParams')
  selectedTags.value = []
  forceRerender()
  const resetParams = {
    page: 1,
    status_eq: 'active',
    line_name_or_display_name_cont: null,
    tags_id_in: null,
    created_at_gteq: null,
    created_at_lteq: null,
    visible_eq: true,
    locked_eq: false,
    channel_assignee_id_eq: null
  }
  Object.assign(params.value, resetParams)
  emit('changeSelectOnlyTester', null)
}

const closeModal = () => {
  selectedTags.value = []
}

const showModal = async () => {
  if (clearQueryParams.value) {
    selectedTags.value = []
    store.commit('friend/setClearQueryParams', false)
  }
  forceRerender()
  params.value = JSON.parse(JSON.stringify(queryParams.value))

  if (params.value.tags_id_in) {
    inputTag.value?.initData()
  }
}

const setAssigneeParam = (staffId) => {
  params.value.channel_assignee_id_eq = staffId
}

watch(() => props.selectOnlyTester, (newVal) => {
  emit('changeSelectOnlyTester', newVal)
  if (newVal) {
    params.value.tester_eq = true
  } else {
    params.value.tester_eq = null
  }
})

defineExpose({
  showModal
})
</script>
