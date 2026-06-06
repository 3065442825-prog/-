<script setup lang="ts">
import { onMounted, onUnmounted, shallowRef, ref, computed, reactive } from 'vue'
import L from 'leaflet'
import 'leaflet/dist/leaflet.css'

// 类型定义
interface MeasureState {
  isActive: boolean
  points: L.LatLng[]
  totalDistance: number
  segments: number[]
}

// Props 接口
interface Props {
  center?: [number, number]
  zoom?: number
  tileUrl?: string
  lineColor?: string
  markerColor?: string
}

// 默认 Props
const props = withDefaults(defineProps<Props>(), {
  center: () => [39.9042, 116.3974] as [number, number],
  zoom: 13,
  tileUrl: 'https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png',
  lineColor: '#2196F3',
  markerColor: '#F44336'
})

// 状态管理
const mapContainer = ref<HTMLElement | null>(null)
const mapInstance = shallowRef<L.Map | null>(null)
const measureState = reactive<MeasureState>({
  isActive: false,
  points: [],
  totalDistance: 0,
  segments: []
})

// 图层引用
const polyline = shallowRef<L.Polyline | null>(null)
const markers: L.Marker[] = []
const tempMarker = shallowRef<L.Marker | null>(null)
const tooltip = shallowRef<L.Tooltip | null>(null)

// 计算属性：格式化距离显示
const formattedDistance = computed(() => {
  const meters = measureState.totalDistance
  if (meters >= 1000) {
    return `${(meters / 1000).toFixed(2)} 公里`
  }
  return `${meters.toFixed(2)} 米`
})

// 计算属性：按钮文字
const buttonText = computed(() => {
  return measureState.isActive ? '结束测量' : '开始测距'
})

// 计算属性：当前点数量
const pointCount = computed(() => measureState.points.length)

/**
 * 切换测量状态
 */
const toggleMeasure = () => {
  measureState.isActive = !measureState.isActive
  
  if (measureState.isActive) {
    updateCursor('crosshair')
  } else {
    updateCursor('')
    if (tempMarker.value && mapInstance.value) {
      mapInstance.value.removeLayer(tempMarker.value)
      tempMarker.value = null
    }
  }
}

/**
 * 更新地图光标样式
 */
const updateCursor = (cursor: string) => {
  if (mapInstance.value) {
    const container = mapInstance.value.getContainer()
    container.style.cursor = cursor
  }
}

/**
 * 处理地图点击事件 - 添加测量点
 */
const handleMapClick = (e: L.LeafletMouseEvent) => {
  if (!measureState.isActive || !mapInstance.value) return
  
  const newPoint = e.latlng
  measureState.points.push(newPoint)
  
  // 添加标记点
  const markerIcon = L.divIcon({
    className: 'measure-marker',
    html: `<div style="background:${props.markerColor};width:12px;height:12px;border-radius:50%;border:2px solid white;box-shadow:0 2px 4px rgba(0,0,0,0.3);"></div>`,
    iconSize: [12, 12],
    iconAnchor: [6, 6]
  })
  
  const marker = L.marker(newPoint, { icon: markerIcon }).addTo(mapInstance.value)
  markers.push(marker)
  
  // 计算并更新距离
  if (measureState.points.length > 1) {
    const lastTwo = measureState.points.slice(-2)
    const segmentDistance = lastTwo[0].distanceTo(lastTwo[1])
    measureState.segments.push(segmentDistance)
    measureState.totalDistance += segmentDistance
    
    // 更新线段
    if (polyline.value) {
      polyline.value.setLatLngs(measureState.points)
    } else {
      polyline.value = L.polyline(measureState.points, {
        color: props.lineColor,
        weight: 3,
        opacity: 0.8
      }).addTo(mapInstance.value)
    }
  }
}

/**
 * 处理鼠标移动 - 显示临时标记和距离预览
 */
const handleMouseMove = (e: L.LeafletMouseEvent) => {
  if (!measureState.isActive || !mapInstance.value || measureState.points.length === 0) return
  
  const lastPoint = measureState.points[measureState.points.length - 1]
  const tempDistance = lastPoint.distanceTo(e.latlng)
  
  // 更新临时标记
  if (tempMarker.value) {
    tempMarker.value.setLatLng(e.latlng)
  } else {
    tempMarker.value = L.circleMarker(e.latlng, {
      radius: 4,
      fillColor: props.lineColor,
      color: props.lineColor,
      weight: 1,
      opacity: 0.7,
      fillOpacity: 0.3
    }).addTo(mapInstance.value)
  }
  
  // 更新临时线段
  const tempPoints = [...measureState.points, e.latlng]
  if (tooltip.value) {
    tooltip.value.setLatLng(e.latlng)
    tooltip.value.setContent(formatDistance(tempDistance))
  } else {
    tooltip.value = L.tooltip({
      permanent: true,
      direction: 'top',
      offset: [0, -10]
    }).setLatLng(e.latlng).setContent(formatDistance(tempDistance)).addTo(mapInstance.value)
  }
}

/**
 * 处理双击事件 - 结束测量
 */
const handleDoubleClick = (e: L.LeafletMouseEvent) => {
  if (!measureState.isActive) return
  e.originalEvent.preventDefault()
  toggleMeasure()
}

/**
 * 格式化距离显示
 */
const formatDistance = (meters: number): string => {
  if (meters >= 1000) {
    return `${(meters / 1000).toFixed(2)} km`
  }
  return `${meters.toFixed(1)} m`
}

/**
 * 清除所有测量
 */
const clearMeasure = () => {
  // 重置状态
  measureState.points = []
  measureState.totalDistance = 0
  measureState.segments = []
  
  // 清除图层
  if (polyline.value && mapInstance.value) {
    mapInstance.value.removeLayer(polyline.value)
    polyline.value = null
  }
  
  if (tempMarker.value && mapInstance.value) {
    mapInstance.value.removeLayer(tempMarker.value)
    tempMarker.value = null
  }
  
  if (tooltip.value && mapInstance.value) {
    mapInstance.value.removeLayer(tooltip.value)
    tooltip.value = null
  }
  
  markers.forEach(m => mapInstance.value?.removeLayer(m))
  markers.length = 0
  
  // 停止测量
  if (measureState.isActive) {
    toggleMeasure()
  }
}

// 生命周期：组件挂载
onMounted(() => {
  try {
    if (!mapContainer.value) {
      console.error('Map container not found')
      return
    }
    
    // 初始化地图
    const map = L.map(mapContainer.value, {
      center: props.center,
      zoom: props.zoom,
      zoomControl: true
    })
    
    // 添加底图
    L.tileLayer(props.tileUrl, {
      attribution: '&copy; <a href="https://www.openstreetmap.org/copyright">OpenStreetMap</a>',
      maxZoom: 19
    }).addTo(map)
    
    // 绑定事件
    map.on('click', handleMapClick)
    map.on('mousemove', handleMouseMove)
    map.on('dblclick', handleDoubleClick)
    
    mapInstance.value = map
    
    // 修正尺寸
    setTimeout(() => map.invalidateSize(), 200)
  } catch (error) {
    console.error('Failed to initialize map measure:', error)
  }
})

// 生命周期：组件卸载 - 清理资源
onUnmounted(() => {
  if (mapInstance.value) {
    mapInstance.value.off('click', handleMapClick)
    mapInstance.value.off('mousemove', handleMouseMove)
    mapInstance.value.off('dblclick', handleDoubleClick)
    clearMeasure()
    mapInstance.value.remove()
    mapInstance.value = null
  }
})

// 暴露给父组件
defineExpose({
  getMapInstance: () => mapInstance.value,
  getMeasureState: () => ({ ...measureState }),
  clearMeasure
})
</script>

<template>
  <div class="map-measure-container">
    <!-- 工具栏 -->
    <div class="measure-toolbar">
      <button 
        class="measure-btn"
        :class="{ active: measureState.isActive }"
        @click="toggleMeasure"
      >
        {{ buttonText }}
      </button>
      <button 
        class="measure-btn clear-btn"
        @click="clearMeasure"
        :disabled="pointCount === 0"
      >
        清除
      </button>
    </div>
    
    <!-- 距离显示 -->
    <div class="distance-display" v-if="pointCount > 0">
      <span class="distance-label">总距离：</span>
      <span class="distance-value">{{ formattedDistance }}</span>
      <span class="point-count">({{ pointCount }} 个点)</span>
    </div>
    
    <!-- 提示信息 -->
    <div class="measure-hint" v-if="measureState.isActive">
      💡 点击地图添加点，双击结束测量
    </div>
    
    <!-- 地图容器 -->
    <div ref="mapContainer" class="map-container"></div>
  </div>
</template>

<style scoped>
.map-measure-container {
  position: relative;
  width: 100%;
}

.measure-toolbar {
  display: flex;
  gap: 10px;
  margin-bottom: 12px;
}

.measure-btn {
  padding: 8px 16px;
  border: 1px solid #ddd;
  border-radius: 6px;
  background: white;
  cursor: pointer;
  font-size: 14px;
  transition: all 0.2s;
}

.measure-btn:hover {
  background: #f5f5f5;
  border-color: #bbb;
}

.measure-btn.active {
  background: #2196F3;
  color: white;
  border-color: #2196F3;
}

.clear-btn:disabled {
  opacity: 0.5;
  cursor: not-allowed;
}

.distance-display {
  padding: 10px 16px;
  background: #f8f9fa;
  border-radius: 6px;
  margin-bottom: 12px;
  font-size: 14px;
}

.distance-label {
  color: #666;
}

.distance-value {
  font-weight: 600;
  color: #2196F3;
  font-size: 16px;
}

.point-count {
  color: #999;
  margin-left: 8px;
}

.measure-hint {
  padding: 8px 12px;
  background: #fff3cd;
  border-radius: 4px;
  color: #856404;
  font-size: 13px;
  margin-bottom: 12px;
}

.map-container {
  width: 100%;
  height: 500px;
  border: 1px solid #e0e0e0;
  border-radius: 8px;
  overflow: hidden;
}
</style>
