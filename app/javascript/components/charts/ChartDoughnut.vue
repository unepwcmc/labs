<template>
  <div class="chart--doughnut">
    <h5 class="chart--doughnut__title">
      {{ title }}
    </h5>
    <template v-if="Object.entries(this.statistics).length > 0">
      <canvas
        :id="chartId"
        class="chart--doughnut__chartarea"
      />
    </template>
    <template v-else>
      <p>No data currently available for this property</p>
    </template>
  </div>
</template>

<script>
import Chart from 'chart.js'
import { capitalize } from 'lodash-es'

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
      },
      generalOptions: {
        responsive: false
      }
    }
  },
  mounted() {
    this.customiseDataset()
    this.createChart(this.chartId)
  },
  methods: {
    createChart(chartId) {
      const chartElem = document.getElementById(chartId)

      return new Chart(chartElem, {
        type: 'doughnut',
        data: this.formattedStats,
        options: this.generalOptions
      })
    },
    getStyleOptions() {
      return {
        backgroundColor: this.datasetOptions.backgroundColors,
        borderAlign: 'left',
        borderWidth: '1'
      }
    },
    replaceUnderscores(str) {
      return str.replace(/_/g, ' ').split(' ')
    },
    customiseDataset() {
      const correctedLabels = Object.keys(this.statistics).map((key) =>
        this.replaceUnderscores(key).map((str) => capitalize(str)).join(' ')
      )

      this.formattedStats = {
        datasets: [
          {
            data: Object.values(this.statistics),
            ...this.getStyleOptions()
          }
        ],
        labels: correctedLabels
      }
    }
  },
}
</script>