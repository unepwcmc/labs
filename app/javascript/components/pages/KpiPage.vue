<template>
  <div class="page--kpi">
    <div class="page--kpi__vulnerabilities">
      <h2>Project vulnerabilities</h2>
      <div class="page--kpi__chart-row">
        <template v-if="kpiStats">
          <chart-doughnut :statistics="kpiStats.project_vulnerability_counts"></chart-doughnut>
        </template>
      </div>
      <h2>Active projects</h2>
      <div class="page--kpi__chart-row">
        <template v-if="kpiStats">
          <chart-doughnut :statistics="kpiStats.active_products"></chart-doughnut>
        </template>
      </div>
    </div>
  </div>
</template>

<script>
import axios from 'axios'
import { setAxiosHeaders } from '../../helpers/axios-helpers'
import ChartDoughnut from '../charts/ChartDoughnut.vue'

setAxiosHeaders(axios)

export default {
  name: 'KpiPage',
  components: { ChartDoughnut },
  props: {
    endpoint: {
      required: true,
      type: String
    },
  },
  data() {
    return {
      kpiStats: undefined
    }
  },
  mounted() {
    this.getKpi()
  },
  methods: {
    getKpi() {
      axios.get(this.endpoint).then(response => {
        this.kpiStats = response.data
      }).catch(error => {
        console.log(error)
      })
    }
  },
}
</script>