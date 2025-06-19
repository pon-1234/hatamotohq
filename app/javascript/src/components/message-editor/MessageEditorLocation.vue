<template>
  <div>
    <div class="form-group">
      <label>タイトル<required-mark /></label>
      <input
        type="text"
        placeholder="タイトルを入力してください"
        name="location-title"
        class="form-control"
        maxlength="101"
        v-model.trim="defaults.title"
        data-vv-as="タイトル"
      />
      <error-message :message="errors.first('location-title')" />
    </div>
    <div class="form-group">
      <label>住所<required-mark /></label>
      <div class="d-flex" style="align-items: flex-start">
        <div class="flex column flex-grow-1">
          <textarea
            class="form-control"
            rows="2"
            maxlength="101"
            placeholder="住所を入力してください"
            v-model.trim="defaults.address"
                data-vv-as="住所"
            name="location-description"
          ></textarea>
          <error-message :message="errors.first('location-description')" />
        </div>
        <div class="btn btn-primary ml-2" style="" @click="getMarker">ピンの住所を検出</div>
      </div>
    </div>
    <br />
    <gmap-map
      v-if="rerender"
      ref="map"
      :center="center"
      :zoom="17"
      :options="options"
      style="width: 100%; height: 400px"
      @center_changed="changeCenter"
    >
      <div slot="visible">
        <div class="box-search" style="top: 10px; left: 12px; width: 300px; position: absolute; z-index: 0">
          <gmap-autocomplete @place_changed="setPlace" :options="{ fields: ['geometry'] }" class="form-control">
          </gmap-autocomplete>
        </div>
      </div>
      <gmap-marker
        :key="index"
        v-for="(m, index) in markers"
        :position="m.position"
        @click="center = m.position"
      ></gmap-marker>
    </gmap-map>
  </div>
</template>

<script setup>
import { ref, watch, onMounted, nextTick } from 'vue'
import { MessageType } from '@/core/constant'
import ErrorMessage from '../common/ErrorMessage.vue'

const props = defineProps({
  data: Object
})

const emit = defineEmits(['input'])

const map = ref(null)
const center = ref({ lat: null, lng: null })
const markers = ref([])
const options = ref({
  streetViewControl: false,
  mapTypeControl: false,
  zoomControl: true,
  autobindAllEvents: true,
  disableDefaultUI: true
})
const defaults = ref({
  type: MessageType.Location,
  title: '',
  address: '',
  latitude: '',
  longitude: ''
})
const rerender = ref(true)

const errors = ref({ items: [], first: () => null })

if (props.data) {
  Object.assign(defaults.value, props.data)
  if (defaults.value.latitude && defaults.value.longitude) {
    center.value.lat = parseFloat(defaults.value.latitude)
    center.value.lng = parseFloat(defaults.value.longitude)
    markers.value.push({ position: center.value })
  }
}

onMounted(() => {
  if (!props.data.latitude && !props.data.longitude) {
    nextTick(geolocate)
  }

  nextTick(() => {
    map.value.$gmapApiPromiseLazy().then(loadControls)
  })
})

watch(defaults, (val) => {
  emit('input', val)
}, { deep: true })

const setPlace = (place) => {
  if (place) {
    const marker = {
      lat: place.geometry.location.lat(),
      lng: place.geometry.location.lng()
    }
    setCurrentMarker(marker)
    center.value = marker
  }
}

const getMarker = () => {
  const theLocations = markers.value
  return Promise.all(
    theLocations.map(addr => {
      var geocoder = new google.maps.Geocoder()

      var locationss = {
        lat: parseFloat(addr.position.lat),
        lng: parseFloat(addr.position.lng)
      }

      return new Promise(function(resolve, reject) {
        geocoder.geocode({ location: locationss }, function(results, status) {
          if (status === 'OK') {
            if (results[0]) {
              defaults.value.address = results[0].formatted_address.substring(0, 89)
              return results[0].formatted_address
            } else {
              console.log(status)
              window.alert('検出できませんでした')
              return null
            }
          }
        })
      })
    })
  ).then(data => {
    console.log(data)
  })
}

const geolocate = () => {
  navigator.geolocation.getCurrentPosition(position => {
    center.value = {
      lat: position.coords.latitude,
      lng: position.coords.longitude
    }
    defaults.value.latitude = position.coords.latitude
    defaults.value.longitude = position.coords.longitude
    markers.value.push({ position: center.value })
  })
}

const changeCenter = (place) => {
  const marker = {
    lat: place.lat(),
    lng: place.lng()
  }

  setCurrentMarker(marker)
}

const setCurrentMarker = (marker) => {
  defaults.value.latitude = marker.lat
  defaults.value.longitude = marker.lng
  markers.value = []
  markers.value.push({ position: marker })
}

const loadControls = (mapObj) => {
  var controlDiv = document.createElement('div')
  var firstChild = document.createElement('button')
  firstChild.style.backgroundColor = '#fff'
  firstChild.style.border = 'none'
  firstChild.style.outline = 'none'
  firstChild.style.width = '28px'
  firstChild.style.height = '28px'
  firstChild.style.borderRadius = '2px'
  firstChild.style.boxShadow = '0 1px 4px rgba(0,0,0,0.3)'
  firstChild.style.cursor = 'pointer'
  firstChild.style.marginRight = '10px'
  firstChild.style.padding = '0px'
  firstChild.title = 'Your Location'
  controlDiv.appendChild(firstChild)
  var secondChild = document.createElement('div')
  secondChild.style.margin = '5px'
  secondChild.style.width = '18px'
  secondChild.style.height = '18px'
  secondChild.style.backgroundImage = 'url(https://maps.gstatic.com/tactile/mylocation/mylocation-sprite-1x.png)'
  secondChild.style.backgroundSize = '180px 18px'
  secondChild.style.backgroundPosition = '0px 0px'
  secondChild.style.backgroundRepeat = 'no-repeat'
  secondChild.id = 'you_location_img'
  firstChild.appendChild(secondChild)
  window.google.maps.event.addListener(map.value.$mapObject, 'center_changed', function() {
    secondChild.style['background-position'] = '0 0'
  })
  firstChild.addEventListener('click', function() {
    rerender.value = false
    navigator.geolocation.getCurrentPosition(position => {
      const marker = {
        lat: position.coords.latitude,
        lng: position.coords.longitude
      }
      setCurrentMarker(marker)
      center.value = marker
      rerender.value = true
      nextTick(() => {
        map.value.$gmapApiPromiseLazy().then(loadControls)
      })
    })
  })
  controlDiv.index = 1
  map.value.$mapObject.controls[window.google.maps.ControlPosition.RIGHT_BOTTOM].push(controlDiv)
}
</script>
<style lang="scss" scoped>
  :deep() {
    .btn-add {
      display: block;
      color: white;
      background: linear-gradient(90deg, #04dc04 0%, #00b900 50%, #00af00 100%);
      border-radius: 5px;
      padding: 9px 10px;
      line-height: 1;
      white-space: nowrap;
      margin-left: 10px;
      cursor: pointer;
      height: 30px;
    }
  }
</style>
