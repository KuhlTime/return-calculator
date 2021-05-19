<script>
import 'chart.js'
import { Line } from 'vue-chartjs'

export default {
  name: 'chart',
  extends: Line,
  props: {
    chartdata: {
      type: Object,
      default: null
    },
    options: {
      type: Object,
      default: null
    }
  },
  watch: {
    chartdata: function() {
      this.renderChart(this.chartdata, this.options)
    }
  },
  mounted() {
    this.renderChart(this.chartdata, this.options)
  }
}
</script>
