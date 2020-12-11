<template>
  <div class="chart--doughnut">
    <p>{{ title }}</p>
    <canvas :id="chartId"></canvas>
    <p v-if="this.statistics === undefined">No data is currently available</p>
  </div>
</template>

<script>
import Chart from 'chart.js'

export default {
  name: 'ChartDoughnut',
  props: {
    chartId: {
      type: String,
      required: true
    },
    statistics: {
      type: Object,
      default: () => ({})
    },
    title: {
      type: String,
      default: ''
    }
  },
  mounted() {
    this.customiseDataset()
    this.createChart(this.chartId)
  },
  data() {
    return {
      formattedStats: undefined,
      datasetOptions: {
        backgroundColors: [
          'rgba(255, 0, 0, 0.5)', 
          'rgba(0, 255, 0, 0.5)',
          'rgba(0, 0, 255, 0.5)',
          'rgba(255, 255, 0, 0.5)'
        ]
      }
    }
  },
  methods: {
    createChart(chartId) {
      const chartElem = document.getElementById(chartId)
      const chart = new Chart(chartElem, {
        type: 'doughnut',
        data: this.formattedStats
      })
    },
    setStyleOptions() {
      return {
        backgroundColor: this.datasetOptions.backgroundColors,
        borderAlign: 'left',
        borderWidth: '1'
      }
    },
    customiseDataset() {
      const correctedLabels = Object.keys(this.statistics).map((key) => {
        return key.replace(/_/g, ' ').split(' ').map((s) => {
          return s.charAt(0).toUpperCase() + s.substring(1)
        }).join(' ')
      })

      this.formattedStats = {
        datasets: [
          {
            data: Object.values(this.statistics),
            ...this.setStyleOptions()
          }
        ],
        labels: correctedLabels
      }
    }
  },
}
</script>