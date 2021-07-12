<template>
  <div class="chart--doughnut">
    <h5 class="chart--doughnut__title">
      {{ title }}
    </h5>
    <template v-if="Object.entries(statistics).length > 0">
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

export default {
  name: 'ChartBar',
  props: {
    chartId: {
      type: String,
      required: true
    },
    statistics: {
      type: Array,
      default: () => []
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
          '#088BA5',
          '#00A0D1',
          '#38A38E',
          '#90C352',
          '#7D8DE2',
          '#EA6E8F',
          '#FEB958',
          '#D66F30',
          '#51191C',
          '#AA37BF'
        ]
      },
      generalOptions: {
        legend: { display: false },
        responsive: false,
        scales: { y: { beginAtZero: true } }
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
        type: 'bar',
        data: this.formattedStats,
        options: this.generalOptions
      })
    },
    getStyleOptions() {
      return {
        backgroundColor: this.datasetOptions.backgroundColors,
        borderWidth: '1'
      }
    },
    replaceUnderscores(str) {
      return str.replace(/_/g, ' ').split(' ')
    },
    customiseDataset() {
      this.formattedStats = {
        datasets: [
          {
            label: '',
            data: this.statistics.map(s => s.value),
            ...this.getStyleOptions()
          }
        ],
        labels: this.statistics.map(s => s.label)
      }
    }
  },
}
</script>