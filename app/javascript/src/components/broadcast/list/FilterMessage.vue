<template>
  <div class="row-ttl01 d-flex ai_center mb40 flex-wrap justify-content-between align-items-center">
    <h3 class="hdg3">メッセージ一覧</h3>
    <div class="row-ttl02 flex">
      <div class="btn-group btn-sort01" v-if="type !=='template'">
        <button type="button" class="btn dropdown-toggle" data-toggle="dropdown" aria-expanded="false">{{selected.text}}<span class="caret"></span></button>
        <ul class="dropdown-menu dropdown-common01" role="menu">
          <li role="presentation" v-for="(item, index) in options" :key="index" @click="changeSelected(item)">
            <a role="menuitem" tabindex="-1" href="#" :class="selected.value === item.value  ? 'active': ''">{{item.text}}</a>
          </li>
        </ul>
      </div>
      <div class="btn-detail fz14">
        <a href="javascript:void(0);"><span>検索</span></a>
      </div>
      <div class="btn-common02 fz14">

        <a :href="`${MIX_ROOT_PATH}/template/streams/create?folder_id=${folderId}`" v-if="type=='template'">新規作成</a>
        <a :href="`${MIX_ROOT_PATH}/streams/create`" v-else>新規作成</a>
      </div>
    </div>
    <div class="box-detail">
      <div class="form-setting">
        <div class="form-group">
          <label>名前</label>
          <input type="text" class="form-control" placeholder="名前を入力してください" v-model="keyword">
        </div>
        <div class="form-group"  v-if="type !='template'">
          <label>タグ</label>
          <div>
            <input-tag @input="selectTags" :allTags="true"/>
          </div>
        </div>
      </div>
      <button type="submit" class="btn btn-save btn-block" @click="changeFilter">検索する</button>
    </div>
  </div>
</template>
<script>
import { mapState } from 'vuex';

export default {
  props: ['type', 'folderId'],
  data() {
    return {
      MIX_ROOT_PATH: process.env.MIX_ROOT_PATH,
      options: this.MessageDeliveriesStatusFilter,
      selected: this.MessageDeliveriesStatusFilter[0],
      keyword: '',
      list_tag: []
    };
  },
  computed: {
    ...mapState('global', {
      tags: state => state.tags
    })
  },
  methods: {
    changeSelected(value) {
      this.selected = value;
      this.$emit('input', { status: value.value });
    },

    changeFilter() {
      this.$emit('input', { keyword: this.keyword, tags: this.list_tag });
    },

    selectTags(tags) {
      this.list_tag = tags.map(item => item.id);
    }
  }
};
</script>

<style lang="scss" scoped>
    ::v-deep{
        .hdg3{
            margin: 15px 0;
        }
        @media (max-width: 991px){
            .hdg3{
                flex: auto;
            }

        }
    }
</style>
