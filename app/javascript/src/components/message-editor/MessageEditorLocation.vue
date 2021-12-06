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
        v-validate="'required|max:100'"
        data-vv-as="タイトル"
      />
      <error-message :message="errors.first('location-title')"></error-message>
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
            v-validate="'required|max:100'"
            data-vv-as="住所"
            name="location-description"
          ></textarea>
          <error-message :message="errors.first('location-description')"></error-message>
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

<script>
import ErrorMessage from '../common/ErrorMessage.vue';
export default {
  components: { ErrorMessage },
  inject: ['parentValidator'],
  props: ['data'],
  data() {
    return {
      center: { lat: null, lng: null },
      markers: [],
      options: {
        streetViewControl: false,
        mapTypeControl: false,
        zoomControl: true,
        autobindAllEvents: true,
        disableDefaultUI: true
      },
      defaults: {
        type: this.MessageType.Location,
        title: '',
        address: '',
        latitude: '',
        longitude: ''
      },
      rerender: true
    };
  },
  created() {
    this.$validator = this.parentValidator;

    if (this.data) {
      Object.assign(this.defaults, this.data);
      if (this.defaults.latitude && this.defaults.longitude) {
        this.center.lat = parseFloat(this.defaults.latitude);
        this.center.lng = parseFloat(this.defaults.longitude);
        this.markers.push({ position: this.center });
      }
    }
  },

  mounted() {
    if (!this.data.latitude && !this.data.longitude) {
      this.$nextTick(this.geolocate);
    }

    this.$nextTick(() => {
      this.$refs.map.$gmapApiPromiseLazy().then(this.loadControls);
    });
  },

  watch: {
    defaults: {
      handler(val) {
        this.$emit('input', val);
      },
      deep: true
    }
  },

  methods: {
    setPlace(place) {
      if (place) {
        const marker = {
          lat: place.geometry.location.lat(),
          lng: place.geometry.location.lng()
        };
        this.setCurrentMarker(marker);
        this.center = marker;
      }
    },
    getMarker() {
      const theLocations = this.markers;
      const _this = this;
      // eslint-disable-next-line no-undef
      return Promise.all(
        _.map(theLocations, addr => {
          // eslint-disable-next-line no-undef
          var geocoder = new google.maps.Geocoder();

          var locationss = {
            lat: parseFloat(addr.position.lat),
            lng: parseFloat(addr.position.lng)
          };

          return new Promise(function(resolve, reject) {
            geocoder.geocode({ location: locationss }, function(results, status) {
              if (status === 'OK') {
                if (results[0]) {
                  _this.defaults.address = results[0].formatted_address.substring(0, 89);
                  return results[0].formatted_address;
                } else {
                  console.log(status);
                  window.alert('検出できませんでした');
                  return null;
                }
              }
            });
          });
        })
      ).then(data => {
        console.log(data);
      });
    },
    geolocate() {
      navigator.geolocation.getCurrentPosition(position => {
        this.center = {
          lat: position.coords.latitude,
          lng: position.coords.longitude
        };
        this.defaults.latitude = position.coords.latitude;
        this.defaults.longitude = position.coords.longitude;
        this.markers.push({ position: this.center });
      });
    },
    changeCenter(place) {
      const marker = {
        lat: place.lat(),
        lng: place.lng()
      };

      this.setCurrentMarker(marker);
    },

    setCurrentMarker(marker) {
      this.defaults.latitude = marker.lat;
      this.defaults.longitude = marker.lng;
      this.markers = [];
      this.markers.push({ position: marker });
    },

    loadControls(map) {
      var controlDiv = document.createElement('div');
      var firstChild = document.createElement('button');
      firstChild.style.backgroundColor = '#fff';
      firstChild.style.border = 'none';
      firstChild.style.outline = 'none';
      firstChild.style.width = '28px';
      firstChild.style.height = '28px';
      firstChild.style.borderRadius = '2px';
      firstChild.style.boxShadow = '0 1px 4px rgba(0,0,0,0.3)';
      firstChild.style.cursor = 'pointer';
      firstChild.style.marginRight = '10px';
      firstChild.style.padding = '0px';
      firstChild.title = 'Your Location';
      controlDiv.appendChild(firstChild);
      var secondChild = document.createElement('div');
      secondChild.style.margin = '5px';
      secondChild.style.width = '18px';
      secondChild.style.height = '18px';
      secondChild.style.backgroundImage = 'url(https://maps.gstatic.com/tactile/mylocation/mylocation-sprite-1x.png)';
      secondChild.style.backgroundSize = '180px 18px';
      secondChild.style.backgroundPosition = '0px 0px';
      secondChild.style.backgroundRepeat = 'no-repeat';
      secondChild.id = 'you_location_img';
      firstChild.appendChild(secondChild);
      window.google.maps.event.addListener(this.$refs.map.$mapObject, 'center_changed', function() {
        secondChild.style['background-position'] = '0 0';
      });
      var ref = this;
      firstChild.addEventListener('click', function() {
        ref.rerender = false;
        navigator.geolocation.getCurrentPosition(position => {
          const marker = {
            lat: position.coords.latitude,
            lng: position.coords.longitude
          };
          ref.setCurrentMarker(marker);
          ref.center = marker;
          ref.rerender = true;
          ref.$nextTick(() => {
            ref.$refs.map.$gmapApiPromiseLazy().then(ref.loadControls);
          });
        });
      });
      controlDiv.index = 1;
      this.$refs.map.$mapObject.controls[window.google.maps.ControlPosition.RIGHT_BOTTOM].push(controlDiv);
    }
  }
};
</script>
<style lang="scss" scoped>
  ::v-deep {
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
