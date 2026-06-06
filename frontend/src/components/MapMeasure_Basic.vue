<script setup lang="ts">
import { onMounted, onUnmounted, shallowRef, ref } from 'vue'
import L from 'leaflet'
import 'leaflet/dist/leaflet.css'

const mapContainer = ref<HTMLElement | null>(null)
const mapInstance = shallowRef<L.Map | null>(null)
const isMeasuring = ref(false)
const points: L.LatLng[] = []
const polyline = shallowRef<L.Polyline | null>(null)
const markers: L.Marker[] = []

let distance = 0

const toggleMeasure = () => {
  isMeasuring.value = !isMeasuring.value
}

const handleMapClick = (e: L.LeafletMouseEvent) => {
  if (!isMeasuring.value || !mapInstance.value) return
  
  points.push(e.latlng)
  
  const marker = L.marker(e.latlng).addTo(mapInstance.value)
  markers.push(marker)
  
  if (points.length > 1) {
    const lastTwo = points.slice(-2)
    distance += lastTwo[0].distanceTo(lastTwo[1])
    
    if (polyline.value) {
      polyline.value.setLatLngs(points)
    } else {
      polyline.value = L.polyline(points, { color: 'red' }).addTo(mapInstance.value)
    }
  }
}

const clearMeasure = () => {
  points.length = 0
  distance = 0
  if (polyline.value && mapInstance.value) {
    mapInstance.value.removeLayer(polyline.value)
    polyline.value = null
  }
  markers.forEach(m => mapInstance.value?.removeLayer(m))
  markers.length = 0
}

onMounted(() => {
  if (!mapContainer.value) return
  
  const map = L.map(mapContainer.value, {
    center: [39.9042, 116.3974],
    zoom: 13
  })
  
  L.tileLayer('https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png', {
    attribution: '&copy; OpenStreetMap'
  }).addTo(map)
  
  map.on('click', handleMapClick)
  
  mapInstance.value = map
})

onUnmounted(() => {
  mapInstance.value?.remove()
})
</script>

<template>
  <div>
    <div ref="mapContainer" style="width: 100%; height: 500px;"></div>
    <div>
      <button @click="toggleMeasure">开始/停止测量</button>
      <button @click="clearMeasure">清除</button>
      <div>距离: {{ distance }} 米</div>
    </div>
  </div>
</template>
