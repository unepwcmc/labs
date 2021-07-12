<template>
  <div class="page--kpi">
    <h3>Last updated: {{ lastRegeneratedDate }}</h3>
    <template v-if="kpiStats">
      <h2>Product vulnerabilities</h2>
      <div class="page--kpi__chart-row">
        <chart-doughnut
          :statistics="kpiStats.product_vulnerability_counts"
          :title="'Number of repos sorted by vulnerability count'"
          :chart-id="'vuln-counts'"
        />
      </div>
      <h2>Product completeness</h2>
      <div class="page--kpi__chart-row">
        <chart-doughnut
          :statistics="kpiStats.percentage_currently_active_products"
          :title="'% Currently active products'"
          :chart-id="'active-products'"
        />
        <chart-doughnut
          :statistics="kpiStats.percentage_products_with_kpis"
          :title="'% Products with KPIs'"
          :chart-id="'kpi-percentages'"
        />
      </div>
      <div class="page--kpi__chart-row">
        <chart-doughnut
          :statistics="kpiStats.percentage_products_documented"
          :title="'% Products with documentation'"
          :chart-id="'documentation-percentages'"
        />
        <chart-doughnut
          :statistics="kpiStats.percentage_products_with_ci"
          :title="'% Products with CI/CD'"
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
      <h2>Admin and Finance</h2>
      <div class="page--kpi__chart-row">
        <h4>{{ kpiStats.total_income | convert_to_gbp }}</h4>
        <chart-doughnut
          :statistics="kpiStats.level_of_involvement"
          :title="'Level of involvement of Informatics'"
          :chart-id="'level-of-involvement'"
        />
      </div>
      <h2>Yearly updates</h2>
      <div class="page--kpi__chart-row">
        <chart-doughnut
          :statistics="kpiStats.manual_yearly_updates_overview"
          :title="'Overview of manual updates for our products'"
          :chart-id="'manual-updates'"
        />
      </div>
      <h2>Google Analytics</h2>
      <div class="page--kpi__chart-row">
        <chart-bar
          :statistics="kpiStats.google_analytics_overview.top_10_products"
          :title="'Overview of top 10 Google Analytics user counts in the last 90 days (amongst active products)'"
          :chart-id="'google-analytics-top-10-overview'"
        />
      </div>
      <div class="page--kpi__chart-row">
        <chart-bar
          :statistics="kpiStats.google_analytics_overview.bottom_10_products"
          :title="'Overview of bottom 10 Google Analytics user counts in the last 90 days (amongst active products)'"
          :chart-id="'google-analytics-bottom-10-overview'"
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
import ChartBar from '../charts/ChartBar.vue'
import ChartDoughnut from '../charts/ChartDoughnut.vue'

setAxiosHeaders(axios)

export default {
  name: 'KpiPage',
  components: { ChartBar, ChartDoughnut },
  filters: {
    convert_to_gbp: function (str) {
      if (str === null || str === undefined) { return 'Total income is nil' }

      return 'Total income is: £' + str
    }
  },
  props: {
    endpoint: {
      required: true,
      type: String
    },
    endpointPoll: {
      required: true,
      type: String
    }
  },
  data() {
    return {
      kpiStats: undefined,
      lastRegeneratedDate: ''
    }
  },
  mounted() {
    this.getKpi()
  },
  beforeDestroy() {
    window.clearInterval(this.pollKpi)
  },
  methods: {
    getKpi() {
      axios.get(this.endpoint).then(response => {
        this.kpiStats = response.data
        this.updateDate(this.kpiStats.updated_at)
        this.lastRegeneratedDate = new Date(this.kpiStats.updated_at)
      }).catch(error => {
        console.log(error)
      })

      this.startPolling()
    },
    updateDate(date) {
      this.$store.commit('updateLastUpdated', date)
    },
    pollKpi() {
      axios.get(this.endpointPoll).then(response => {
        const date = response.data.updated_at

        if (date > this.$store.state.lastUpdated) {
          this.getKpi()
          this.updateDate(date)
        }
      }).catch(error => {
        console.log(error)
      })
    },
    startPolling() {
      // Refreshes every 5 minutes
      window.setInterval(this.pollKpi, 300000)
    }
  }
}
</script>