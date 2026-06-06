<script setup lang="ts">
/**
 * LeafletMap.vue — AI 生成的 Leaflet 地图初始化组件
 *
 * 功能：使用 Vue 3 Composition API + TypeScript + Leaflet
 * - 中心点设为北京天安门 [39.9042, 116.3974]，缩放级别 13
 * - OpenStreetMap 底图
 * - 添加标记点
 * - 窗口 resize 自适应
 * - 组件卸载时自动清理
 */
import { onMounted, onUnmounted, shallowRef } from 'vue'
import L from 'leaflet'
import 'leaflet/dist/leaflet.css'

// 地图配置 — 可提取为 props 以增强复用性
const mapCenter: [number, number] = [39.9042, 116.3974]
const zoomLevel = 13
const tileUrl = 'https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png'

// 使用 shallowRef 避免不必要的响应式开销
const mapInstance = shallowRef<L.Map | null>(null)

onMounted(() => {
  // 初始化地图
  const map = L.map('map-container', {
    center: mapCenter,
    zoom: zoomLevel,
    zoomControl: true,
  })

  // 添加 OpenStreetMap 瓦片底图
  L.tileLayer(tileUrl, {
    attribution: '&copy; <a href="https://www.openstreetmap.org/copyright">OpenStreetMap</a>',
    maxZoom: 19,
  }).addTo(map)

  // 添加标记点
  L.marker(mapCenter)
    .addTo(map)
    .bindPopup('<b>北京天安门</b><br>故宫博物院南端')
    .openPopup()

  // 保存地图实例
  mapInstance.value = map

  // 窗口 resize 自适应
  setTimeout(() => map.invalidateSize(), 200)
})

// 组件卸载时清理地图实例，防止内存泄漏
onUnmounted(() => {
  if (mapInstance.value) {
    mapInstance.value.remove()
    mapInstance.value = null
  }
})
</script>

<template>
  <div
    id="map-container"
    style="width: 100%; height: 500px; border: 1px solid #ddd; border-radius: 8px;"
  ></div>
</template>
