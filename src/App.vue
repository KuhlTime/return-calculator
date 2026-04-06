<!-- @KuhlTime -->
<template>
  <v-app id="app">
    <v-main id="content">
      <h1>{{ $t('title') }}</h1>

      <select v-model="$i18n.locale" class="lang-selection">
        <option v-for="(lang, i) in langs" :key="`Lang${i}`" :value="lang">{{ lang }}</option>
      </select>

      <div class="toggles">
        <div class="toggle-row">
          <input type="checkbox" class="switch" v-model="removeTaxes" />
          <span>{{ $t('tax_switch') }}</span>
        </div>
        <div class="toggle-row">
          <input type="checkbox" class="switch" v-model="inflationEnabled" />
          <span>{{ $t('inflation_toggle') }}</span>
        </div>
      </div>

      <v-form>
        <v-container fluid>
          <v-row>
            <v-col cols="12" sm="3">
              <v-text-field
                v-model="capitalString"
                :label="$t('capital_input')"
                append-icon="account_balance"
                outlined
                :prefix="moneyUnit"
                :hint="`${capital} ${moneyUnit}`"
                :persistent-hint="showHint"
              ></v-text-field>
            </v-col>
            <v-col cols="12" sm="3">
              <v-text-field
                v-model="monthlyDepositString"
                :label="$t('monthly_input')"
                append-icon="toll"
                outlined
                :prefix="moneyUnit"
                :hint="`${monthlyDeposit} ${moneyUnit}`"
                :persistent-hint="showHint"
              ></v-text-field>
            </v-col>
            <v-col cols="12" sm="2">
              <v-text-field
                v-model="avgYieldPercentString"
                :label="$t('earnings_input')"
                append-icon="trending_up"
                outlined
                prefix="%"
                :hint="`${avgYieldPercent} %`"
                :persistent-hint="showHint"
              ></v-text-field>
            </v-col>
            <v-col cols="12" sm="2">
              <v-text-field
                v-model="ageString"
                :label="$t('age_input')"
                append-icon="today"
                :hint="String(age)"
                :persistent-hint="showHint"
                outlined
              ></v-text-field>
            </v-col>
            <v-col cols="12" sm="2">
              <v-text-field
                v-model="maxAgeString"
                :label="$t('future_age_input')"
                append-icon="event_available"
                outlined
                :hint="String(maxAge)"
                :persistent-hint="showHint"
              ></v-text-field>
            </v-col>
          </v-row>
          <v-row v-if="inflationEnabled">
            <v-col cols="12" sm="3">
              <v-text-field
                v-model="inflationRateString"
                :label="$t('inflation_rate_input')"
                append-icon="trending_down"
                outlined
                prefix="%"
                :hint="inflationHint"
                persistent-hint
              ></v-text-field>
            </v-col>
          </v-row>
        </v-container>
      </v-form>

      <p style="margin-top: -24px; margin-bottom: 18px; margin-left: 24px; margin-right: 24px;">
        {{ $t('text_2[0]') }}
        <b>MSCI World</b>
        {{ $t('text_2[1]') }}
        <b>48 {{ $t('text_2[2]') }}</b>
        (1972-2019) {{ $t('text_2[3]') }}
        <b>8,1%</b>
        {{ $t('text_2[4]') }}.
        <br />
        <a
          href="https://www.dividendenadel.de/wp-content/uploads/2019/02/DividendenAdel-MSCI-World-Renditedreieck-2020-BLAU.pdf"
          target="_blank"
          >{{ $t('data_button') }}</a
        >
        -
        <a href="https://repl.it/@KuhlTime/MSCI" target="_blank">{{ $t('calculation_button') }}</a>
      </p>

      <v-divider></v-divider>
      <chart id="chart" :chartdata="chartdata" :options="chartOptions" style="margin-top: 24px;"></chart>

      <div style="padding: 0 24px; padding-bottom: 24px;">
        {{ $t('text_1[0]') }}
        <span class="highlight">{{ maxAge - age }} {{ $t('text_1[1]') }}</span>
        {{ $t('text_1[2]') }}
        <span class="highlight">{{ totalInvested }} {{ moneyUnit }}</span>
        {{ $t('text_1[3]') }}
        <span class="highlight">{{ finalYieldPercent }}%</span>
        {{ $t('text_1[4]') }}
        <span class="highlight">{{ totalEarnings }} {{ moneyUnit }}</span>
        {{ $t('text_1[5]') }}
        <span class="highlight">{{ taxesString }}%</span>
        {{ $t('text_1[6]') }}
        <span class="highlight">{{ afterTaxCapital }} {{ moneyUnit }}.</span>
        <template v-if="inflationEnabled">
          {{ $t('text_real[0]') }}
          <span class="highlight-real">{{ displayedRealCapital }} {{ moneyUnit }}</span>
          {{ $t('text_real[1]') }}
        </template>
        <p style="font-size: 11px; margin-top:4px;">({{ $t('disclaimer') }})</p>
      </div>

      <v-simple-table style="width: 400px; margin: 0 auto; padding-bottom: 80px;">
        <template v-slot:default>
          <tbody>
            <tr>
              <td>{{ $t('timespan') }}</td>
              <td>{{ maxAge - age }} {{ $t('years') }}</td>
            </tr>
            <tr>
              <td>{{ $t('investment') }}</td>
              <td>{{ totalInvested }} €</td>
            </tr>
            <tr>
              <td>{{ $t('yield') }}</td>
              <td>{{ finalYieldPercent }} %</td>
            </tr>
            <tr>
              <td>{{ $t('earnings') }}</td>
              <td>{{ displayedEarnings }} €</td>
            </tr>
            <tr>
              <td>{{ $t('capital') }}</td>
              <td>{{ displayedCapital }} €</td>
            </tr>
            <tr v-if="inflationEnabled">
              <td>{{ $t('real_capital') }}</td>
              <td class="real-value">{{ displayedRealCapital }} €</td>
            </tr>
          </tbody>
        </template>
      </v-simple-table>
    </v-main>

    <v-footer id="footer">
      <v-icon dense>update</v-icon>
      <div style="margin-left: 8px">{{ $t('version_label') }}: {{ version }}</div>
      <a href="https://github.com/KuhlTime/return-calculator" target="_blank" style="margin-left: 8px">Source Code</a>
      <v-spacer></v-spacer>
      <div>
        Made with ❤️ by
        <a href="https://twitter.com/@kuhltime" target="_blank">André Kuhlmann</a>
        2021
      </div>
    </v-footer>
  </v-app>
</template>

<script>
import Chart from './components/Chart'

export default {
  name: 'App',
  components: { Chart },
  data: () => {
    return {
      version: '19.05.2021',
      showHint: false,
      removeTaxes: true,
      langs: ['en', 'de'],

      capitalString: '1000',
      monthlyDepositString: '20',
      avgYieldPercentString: '8,1',
      ageString: '22',
      maxAgeString: '40',
      taxesString: '25',
      moneyUnit: '€',

      inflationEnabled: false,
      inflationRateString: '2',
      inflationFetchStatus: 'idle', // 'idle' | 'loading' | 'loaded' | 'error'
      inflationDataYears: 0
    }
  },
  mounted() {
    this.fetchInflationRate()
  },
  computed: {
    capital: function() {
      return this.saveParseToFloat(this.capitalString)
    },

    monthlyDeposit: function() {
      return this.saveParseToFloat(this.monthlyDepositString)
    },

    avgYieldPercent: function() {
      return this.saveParseToFloat(this.avgYieldPercentString)
    },

    age: function() {
      return this.saveParseToFloat(this.ageString)
    },

    maxAge: function() {
      return this.saveParseToFloat(this.maxAgeString)
    },

    taxes: function() {
      return this.saveParseToFloat(this.taxesString) * 0.01
    },

    inflationRate: function() {
      return this.saveParseToFloat(this.inflationRateString)
    },

    inflationHint: function() {
      if (this.inflationFetchStatus === 'loading') return this.$t('inflation_hint_loading')
      if (this.inflationFetchStatus === 'loaded') return this.$t('inflation_hint_loaded', { n: this.inflationDataYears })
      return this.$t('inflation_hint_error')
    },

    totalAvgYield: function() {
      return this.avgYieldPercent * 0.01 + 1
    },

    // The age range
    ageRange: function() {
      return this.range(this.age, this.maxAge + 1)
    },

    // Pre-computed final values to avoid repeated method calls in the template
    totalInvested: function() {
      return this.investmentByAge(this.maxAge)
    },

    totalEarnings: function() {
      return this.totalEarningsByAge(this.maxAge)
    },

    afterTaxCapital: function() {
      return this.capitalWithoutTaxesByAge(this.maxAge)
    },

    // Total yield as a rounded integer percentage (e.g. 308 for 308% growth)
    finalYieldPercent: function() {
      return this.yieldRateByAge(this.maxAge)
    },

    displayedCapital: function() {
      return this.removeTaxes ? this.afterTaxCapital : this.capitalByAge(this.maxAge)
    },

    displayedEarnings: function() {
      return this.removeTaxes ? this.afterTaxCapital - this.totalInvested : this.totalEarnings
    },

    displayedRealCapital: function() {
      return this.inflationAdjust(this.displayedCapital, this.maxAge)
    },

    // See: https://vue-chartjs.org/guide/#chart-with-props
    chartdata: function() {
      const datasets = [
        {
          // Styling: https://www.chartjs.org/docs/latest/charts/line.html#dataset-properties
          label: this.$t('chart_dataset'),
          data: this.values,
          backgroundColor: 'rgba(33, 150, 243, 0.4)',
          borderColor: 'rgba(33, 150, 243, 0.6)',
          borderWidth: 2,
          pointBackgroundColor: 'rgba(33, 150, 243, 1)',
          pointBorderWidth: 0,
          pointRadius: 3.3,
          pointHitRadius: 6
        }
      ]

      if (this.inflationEnabled) {
        datasets.push({
          label: this.$t('chart_real_dataset'),
          data: this.realValues,
          backgroundColor: 'rgba(76, 175, 80, 0.2)',
          borderColor: 'rgba(76, 175, 80, 0.7)',
          borderWidth: 2,
          borderDash: [6, 4],
          pointBackgroundColor: 'rgba(76, 175, 80, 1)',
          pointBorderWidth: 0,
          pointRadius: 3.3,
          pointHitRadius: 6
        })
      }

      return { labels: this.ageRange, datasets }
    },

    chartOptions: function() {
      const ageLabel = this.$t('chart_age_label')
      return {
        responsive: true,
        maintainAspectRatio: false,
        legend: {
          display: this.inflationEnabled
        },
        tooltips: {
          // https://www.chartjs.org/docs/latest/configuration/tooltip.html#tooltip-callbacks
          callbacks: {
            title: function(tooltipItem) {
              let capital = tooltipItem[0].yLabel
              return `${capital} €`
            },
            label: function(tooltipItem) {
              let age = tooltipItem.xLabel
              return `${ageLabel}${age}`
            }
          },
          backgroundColor: 'rgba(0,0,0, 0.6)',
          titleFontSize: 14,
          bodyFontColor: '#FFF',
          bodyFontSize: 13,
          displayColors: false
        },
        scales: {
          yAxes: [
            {
              scaleLabel: {
                display: true,
                labelString: this.$t('chart_y_axis')
              },
              ticks: {
                callback: function(value) {
                  return value + ' €'
                }
              }
            }
          ],
          xAxes: [
            {
              scaleLabel: {
                display: true,
                labelString: this.$t('chart_x_axis')
              }
            }
          ]
        }
      }
    },

    // Returns an array of nominal capital values for each year in ageRange
    values: function() {
      return this.ageRange.map(x =>
        this.removeTaxes ? this.capitalWithoutTaxesByAge(x) : this.capitalByAge(x)
      )
    },

    // Returns an array of inflation-adjusted capital values for each year in ageRange
    realValues: function() {
      return this.ageRange.map(x =>
        this.inflationAdjust(
          this.removeTaxes ? this.capitalWithoutTaxesByAge(x) : this.capitalByAge(x),
          x
        )
      )
    }
  },
  methods: {
    // Generates an array from start to stop
    range: function(start, stop, step = 1) {
      return Array(Math.ceil((stop - start) / step))
        .fill(start)
        .map((x, y) => x + y * step)
    },

    // Calculates the total capital for the given age n
    capitalByAge: function(n, round = true) {
      let years = n - this.age
      let value = (this.capital + years * this.monthlyDeposit * 12) * Math.pow(this.totalAvgYield, years)
      return round ? Math.round(value) : value
    },

    // Calculates the post-tax capital for the given age n
    capitalWithoutTaxesByAge: function(n, round = true) {
      let value = this.investmentByAge(n, false) + this.totalEarningsByAge(n, false) * (1 - this.taxes)
      return round ? Math.round(value) : value
    },

    // Calculates the total amount invested by the given age
    investmentByAge: function(n, round = true) {
      let years = n - this.age
      let value = this.capital + years * this.monthlyDeposit * 12
      return round ? Math.round(value) : value
    },

    // Returns the total yield as a rounded integer percentage (e.g. 308 for 308% total growth)
    yieldRateByAge: function(n) {
      return Math.round((Math.pow(this.totalAvgYield, n - this.age) - 1) * 100)
    },

    totalEarningsByAge: function(n, round = true) {
      let value = this.capitalByAge(n, false) - this.investmentByAge(n, false)
      return round ? Math.round(value) : value
    },

    // Returns the nominal value discounted by inflation back to today's purchasing power
    inflationAdjust: function(nominalValue, age) {
      const years = age - this.age
      if (years <= 0) return nominalValue
      return Math.round(nominalValue / Math.pow(1 + this.inflationRate / 100, years))
    },

    // Fetches historical Euro area CPI inflation from the World Bank API and
    // pre-fills inflationRateString with the average of the last ~10 years.
    // Falls back silently to the hardcoded default on any error.
    fetchInflationRate: async function() {
      this.inflationFetchStatus = 'loading'
      try {
        const res = await fetch(
          'https://api.worldbank.org/v2/country/EMU/indicator/FP.CPI.TOTL.ZG?format=json&mrv=10&per_page=10'
        )
        if (!res.ok) throw new Error(`HTTP ${res.status}`)
        const data = await res.json()
        const validValues = data[1]
          .filter(d => d.value !== null)
          .map(d => d.value)
        if (validValues.length === 0) throw new Error('No data')
        const avg = validValues.reduce((a, b) => a + b, 0) / validValues.length
        this.inflationRateString = String(Math.round(avg * 10) / 10)
        this.inflationDataYears = validValues.length
        this.inflationFetchStatus = 'loaded'
      } catch {
        this.inflationFetchStatus = 'error'
      }
    },

    // Safely parses a float, treating comma as decimal separator
    saveParseToFloat: function(string, defaultValue = 0.0) {
      const value = parseFloat(string.replace(',', '.'))
      return isNaN(value) ? defaultValue : value
    }
  }
}
</script>

<style>
html,
body {
  height: 100%;
  width: 100%;
  padding: 0;
  margin: 0;
  box-sizing: border-box;
  background-color: #aaa;
}

#app {
  font-family: 'Roboto', 'Avenir', Helvetica, Arial, sans-serif;
  -webkit-font-smoothing: antialiased;
  -moz-osx-font-smoothing: grayscale;
  text-align: center;
  color: #2c3e50;
  height: 100%;
  width: 100%;
  display: flex;
  overflow-x: hidden;
  flex-direction: column;
}

#content {
  margin-bottom: 80px;
}

#chart {
  padding-bottom: 40px;
}

#footer {
  position: fixed;
  bottom: 0;
  left: 0;
  right: 0;
  font-size: 13px;
}

.toggles {
  display: inline-flex;
  flex-direction: column;
  align-items: flex-start;
  gap: 8px;
  margin-bottom: 4px;
}

.toggle-row {
  display: flex;
  align-items: center;
  gap: 10px;
}

.highlight {
  color: #2196f3;
  font-weight: 600;
}

.highlight-real {
  color: #4caf50;
  font-weight: 600;
}

.real-value {
  color: #4caf50;
  font-weight: 600;
}

input[type='checkbox'].switch {
  /*
    Set the font size to manipulate the size of the switches
    Default 11px
   */
  font-size: 11px;
  position: relative;
  appearance: none;
  -moz-appearance: none;
  -webkit-appearance: none;
  width: 3.5em;
  height: 2em;
  border-radius: 2em;
  background-color: #eee;
  outline: none;
  cursor: pointer;
  transition: all 0.09s ease-in-out;
}

input[type='checkbox'].switch:checked {
  background-color: #2196f3;
}

input[type='checkbox'].switch::after {
  content: '';
  position: absolute;
  width: 2em;
  height: 2em;
  border-radius: 2em;
  background-color: #222;
  transition: 0.09s all ease-in-out;
}

input[type='checkbox'].switch:checked::after {
  margin-left: calc(3.5em - 2em);
  background-color: #222;
}

input[type='checkbox'].switch:active::after {
  transform: scale(0.8);
}

a {
  color: #33a3ff;
  text-decoration: none;
  transition: all ease-in-out 200ms;
}

a:hover {
  color: #3b98e4;
}

.lang-selection {
  position: absolute;
  top: 24px;
  right: 24px;
}
</style>
