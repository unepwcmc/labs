<template>
  <div class="page--kpi">
    <template v-if="kpiStats">
      <h2>Project vulnerabilities</h2>
      <div class="page--kpi__chart-row">
        <chart-doughnut
          :statistics="kpiStats.project_vulnerability_counts"
          :title="'Number of public repos sorted by vulnerability count'"
          :chart-id="'vuln-counts'"
        />
      </div>
      <h2>Project completeness</h2>
      <div class="page--kpi__chart-row">
        <chart-doughnut
          :statistics="kpiStats.percentage_currently_active_products"
          :title="'% Currently active products'"
          :chart-id="'active-products'"
        />
        <chart-doughnut
          :statistics="kpiStats.percentage_projects_with_kpis"
          :title="'% Projects with KPIs'"
          :chart-id="'kpi-percentages'"
        />
      </div>
      <div class="page--kpi__chart-row">
        <chart-doughnut
          :statistics="kpiStats.percentage_projects_documented"
          :title="'% Projects with documentation'"
          :chart-id="'documentation-percentages'"
        />
        <chart-doughnut
          :statistics="kpiStats.percentage_projects_with_ci"
          :title="'% Projects with CI/CD'"
          :chart-id="'ci-percentages'"
        />
      </div>
      <h2>Bits n Bugs backlog</h2>
      <h4>Backlog size: {{ kpiStats.bugs_backlog_size }}</h4>
      <div class="page--kpi__chart-row">
        <chart-doughnut
          :statistics="kpiStats.bugs_severity"
          :title="'Bits N Bugs open tickets sorted by severity'"
          :chart-id="'bugs-distribution'"
        />
      </div>
      <h2>Total income</h2>
      <h4>{{ kpiStats.total_income | convert_to_gbp }}</h4>
      <h2>Yearly updates</h2>
      <div class="page--kpi__chart-row">
        <chart-doughnut
          :statistics="kpiStats.manual_yearly_updates_overview"
          :title="'Overview of manual yearly updates for our projects'"
          :chart-id="'manual-updates'"
        />
      </div>
    </template>

    <template v-else>
      <div class="page--kpi__overlay">
        <i class="icon--loading-spinner" />
      </div>
    </template>
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
  filters: {
    convert_to_gbp: function (str) {
      if (str === null || str === undefined) { return 'Total income is nil' }

      return '£' + str
    }
  },
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
    },
  }
}
</script>