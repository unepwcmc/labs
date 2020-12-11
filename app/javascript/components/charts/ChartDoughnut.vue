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
    mounted() {
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
        const renamedLabels = Object.keys(this.statistics).map((key)=> {
          return key.replace(/_/g, ' ').split(' ').map((s) => {
            return s.charAt(0).toUpperCase() + s.substring(1)
          }).join(' ')
        })
        
        this.formattedStats = {
          datasets: [{
            data: Object.values(this.statistics)
          }],
          labels: renamedLabels
        }
      }
    },
  }
</script>