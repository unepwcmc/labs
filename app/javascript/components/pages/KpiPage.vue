<template>
  <div class="page--kpi">
    <div class="page--kpi__vulnerabilities">
      <h2>Project vulnerabilities</h2>
      <div class="page--kpi__chart-row">
        <template v-if="kpiStats">
          <chart-doughnut
            :statistics="kpiStats.project_vulnerability_counts"
            :title="'Number of public repos sorted by vulnerability count'"
            :chart-id="'vuln-counts'"
          ></chart-doughnut>
        </template>
      </div>
      <h2>Project completeness</h2>
      <template v-if="kpiStats">
        <div class="page--kpi__chart-row">
          <chart-doughnut
            :statistics="kpiStats.percentage_currently_active_products"
            :title="'% Currently active products'"
            :chart-id="'active-products'"
          ></chart-doughnut>
          <chart-doughnut
            :statistics="kpiStats.percentage_projects_with_kpis"
            :title="'% Projects with KPIs'"
            :chart-id="'kpi-percentages'"
          ></chart-doughnut>
        </div>
        <div class="page--kpi__chart-row">
          <chart-doughnut
            :statistics="kpiStats.percentage_projects_documented"
            :title="'% Projects with documentation'"
            :chart-id="'documentation-percentages'"
          ></chart-doughnut>
          <chart-doughnut
            :statistics="kpiStats.percentage_projects_with_ci"
            :title="'% Projects with CI/CD'"
            :chart-id="'ci-percentages'"
          ></chart-doughnut>
        </div>
      </template>
      <h2>Bits n Bugs backlog</h2>
      <template v-if="kpiStats">
        <h4>Backlog size: {{ kpiStats.bugs_backlog_size }}</h4>
        <div class="page--kpi__chart-row">
          <chart-doughnut
            :statistics="kpiStats.bugs_severity"
            :title="'Bits N Bugs open tickets sorted by severity'"
            :chart-id="'bugs-distribution'"
          ></chart-doughnut>
        </div>
      </template>
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