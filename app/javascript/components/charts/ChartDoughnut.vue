<template>
  <div>
    <canvas id="chart-doughnut"></canvas>
  </div>
</template>

<script>
  import Chart from 'chart.js';

  export default {
    name: 'ChartDoughnut',
    props: {
      statistics: {
        type: Object,
        default: () => ({})
      },
    },
    beforeMount() {
      this.correctDataFormat()
      this.createChart('chart-doughnut')
    },
    data() {
      return {
        formattedStats: undefined,
        options: ''
      }
    },
    methods: {
      createChart(chartId) {
        const chartElem = document.getElementById(chartId)
        const chart = new Chart(chartElem, {
          type: 'doughnut',
          data: this.formattedStats,
          // options: this.options,
        });
      },
      correctDataFormat() {
        this.formattedStats = {
          datasets: [{
            data: Object.values(this.statistics)
          }],
          labels: Object.keys(this.statistics)
        }
      }
    },
  }
</script>