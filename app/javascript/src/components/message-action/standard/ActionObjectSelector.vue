<template>
  <div>
    <select v-model="selected" class="form-control w-100" @change="changeSelected">
      <option value="none" :disabled="!isNone">- 選択してください -</option>
      <option v-for="(item, index) in actionTypes" :key="index" :value="item.id">
        {{ item.title }}
      </option>
    </select>
  </div>
</template>
<script>
import Util from '../../../core/util';

export default {
  props: {
    data: Object,

    isNone: {
      type: Boolean,
      default: false
    },
    supports: {
      type: Array,
      default: () => []
    }
  },

  data() {
    return {
      selected: this.data.id || 'none'
    };
  },

  created() {
    if (this.data.type === 'uri') {
      this.selected = this.data.id || (Util.validateUrl(this.data.uri) ? 1 : 2);
    } else {
      const val = _.find(this.actionTypes, item => {
        return item.type === this.data.type;
      });
      this.selected = val ? val.id : 'none';
      this.emitObj(this.selected);
    }
  },

  beforeMount() {
    this.$store.dispatch('global/getActionObjectConfigs');
  },

  methods: {
    changeSelected() {
      this.emitObj(this.selected);
    },

    emitObj(value) {
      let val = this.actionTypes.find(item => item.id === value);

      if (!val) {
        val = { type: 'none' };
      }
      if (val.type === this.data.type) {
        if (!(val.type === 'uri' && val.id !== this.data.id)) {
          return;
        }
      }

      let option = null;
      switch (val.type) {
      case 'none':
        option = { type: 'none' };
        break;
      case this.ActionObjectsType.Postback:
        option = {
          type: this.ActionObjectsType.Postback,
          label: null,
          data: {
            type: 'text',
            content: {
              text: null
            }
          }
        };
        break;

      case this.ActionObjectsType.Message:
        option = {
          type: this.ActionObjectsType.Message,
          label: '',
          text: ''
        };
        break;

      case this.ActionObjectsType.Uri:
        if (val.id === 1) {
          option = {
            id: 1,
            type: this.ActionObjectsType.Uri,
            label: '',
            uri: '',
            linkUri: ''
          };
        } else {
          option = {
            id: 2,
            type: this.ActionObjectsType.Uri,
            label: '',
            uri: '',
            linkUri: ''
          };
        }
        break;

      case this.ActionObjectsType.Datetimepicker:
        option = {
          type: this.ActionObjectsType.Datetimepicker,
          label: '',
          data: '',
          mode: 'date'
        };
        break;
      case this.ActionObjectsType.Camera:
        option = {
          type: this.ActionObjectsType.Camera,
          label: ''
        };
        break;
      case this.ActionObjectsType.CameraRoll:
        option = {
          type: this.ActionObjectsType.CameraRoll,
          label: ''
        };
        break;
      case this.ActionObjectsType.Location:
        option = {
          type: this.ActionObjectsType.Location,
          label: ''
        };
        break;
      case this.ActionObjectsType.Survey:
        option = {
          type: this.ActionObjectsType.Survey,
          label: '',
          content: {
            name: '',
            id: null
          }
        };
        break;
      }
      this.$emit('input', option);
    }
  },

  computed: {
    actionTypes() {
      const objects = this.$store.getters['global/actionObjects'];
      return objects != null
        ? objects.filter(
          item =>
            (this.supports.length > 0 ? this.supports.indexOf(item.type) >= 0 : true) && item.type !== 'postback'
        )
        : null;
    }
  }
};
</script>