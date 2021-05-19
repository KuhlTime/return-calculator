<!-- @KuhlTime -->
<!-- This code is not ment to be very pretty. And should not be seen as any best practice. -->

<template>
  <v-app id="app">
    <v-content id="content">
      <h1>{{ $t('title') }}</h1>

      <select v-model="$i18n.locale" class="lang-selection">
        <option v-for="(lang, i) in langs" :key="`Lang${i}`" :value="lang">{{ lang }}</option>
      </select>

      <input type="checkbox" class="switch" v-model="removeTaxes" />
      <br />
      {{ $t('tax_switch') }}
      <v-form>
        <v-container fluid>
          <v-row>
            <v-col cols="14" sm="3">
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
            <v-col cols="14" sm="3">
              <v-text-field
                v-model="montlyDepositString"
                :label="$t('monthly_input')"
                append-icon="toll"
                outlined
                :prefix="moneyUnit"
                :hint="`${montlyDeposit} ${moneyUnit}`"
                :persistent-hint="showHint"
              ></v-text-field>
            </v-col>
            <v-col cols="14" sm="2">
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
            <v-col cols="14" sm="2">
              <v-text-field
                v-model="ageString"
                :label="$t('age_input')"
                append-icon="today"
                :hint="String(age)"
                :persistent-hint="showHint"
                outlined
              ></v-text-field>
            </v-col>
            <v-col cols="14" sm="2">
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
        <span class="highlight">{{ investmentByAge(maxAge) }} {{ moneyUnit }}</span>
        {{ $t('text_1[3]') }}
        <span class="highlight">{{ yieldRateByAge(maxAge) * 100 }}%</span>
        {{ $t('text_1[4]') }}
        <span class="highlight">{{ totalEarningsByAge(maxAge) }} {{ moneyUnit }}</span>
        {{ $t('text_1[5]') }}
        <span class="highlight">{{ taxesString }}%</span>
        {{ $t('text_1[6]') }}
        <span class="highlight">{{ capitalWithoutTaxesByAge(maxAge) }} {{ moneyUnit }}.</span>
        <p style="font-size: 11px; margin-top:4px;">({{ $t('disclaimer') }})</p>
      </div>

      <v-simple-table style="width: 400px; margin: 0 auto; padding-bottom: 80px;">
        <template v-slot:default>
          <tbody>
            <tr>
              <td>{{ $t('timespan') }}</td>
              <td>{{ maxAge - age }} Jahre</td>
            </tr>
            <tr>
              <td>{{ $t('investment') }}</td>
              <td>{{ investmentByAge(maxAge) }} €</td>
            </tr>
            <tr>
              <td>{{ $t('yield') }}</td>
              <td>{{ yieldRateByAge(maxAge) * 100 }} %</td>
            </tr>
            <tr>
              <td>{{ $t('earnings') }}</td>
              <td>
                {{
                  removeTaxes ? capitalWithoutTaxesByAge(maxAge) - investmentByAge(maxAge) : totalEarningsByAge(maxAge)
                }}
                €
              </td>
            </tr>
            <tr>
              <td>{{ $t('capital') }}</td>
              <td>
                {{ removeTaxes ? capitalWithoutTaxesByAge(maxAge) : capitalByAge(maxAge) }}
                €
              </td>
            </tr>
          </tbody>
        </template>
      </v-simple-table>
    </v-content>

    <v-footer id="footer">
      <v-icon dense>update</v-icon>
      <div style="margin-left: 8px">{{ $t('version_label') }}: {{ version }}</div>
      <a href="https://codesandbox.io/s/renditen-rechner-b0fxe" target="_blank" style="margin-left: 8px">Source Code</a>
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
      langs: ['🇬🇧 en', '🇩🇪 de'],

      capitalString: '1000',
      montlyDepositString: '20',
      avgYieldPercentString: '8,1',
      ageString: '22',
      maxAgeString: '40',
      taxesString: '25',
      moneyUnit: '€',

      chartOptions: {
        responsive: true,
        maintainAspectRatio: false,
        legend: {
          display: false
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
              return `Alter: ${age}`
            }
            /*
            afterLabel: function(tooltipItem, data) {
              let age = tooltipItem.xLabel
              let yield = this.$methods.yieldRateByAge(age)
              return `Rendite: ${yield}`
            }*/
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
                labelString: 'Kapital'
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
                labelString: 'Jahre'
              }
            }
          ]
        }
      }
    }
  },
  computed: {
    capital: function() {
      return this.saveParseToFloat(this.capitalString)
    },

    montlyDeposit: function() {
      return this.saveParseToFloat(this.montlyDepositString)
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

    // The ahe range
    ageRange: function() {
      return this.range(this.age, this.maxAge + 1)
    },

    // See: https://vue-chartjs.org/guide/#chart-with-props
    chartdata: function() {
      return {
        labels: this.ageRange,
        datasets: [
          {
            // Styling: https://www.chartjs.org/docs/latest/charts/line.html#dataset-properties
            label: 'Kapitalentwicklung',
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
      }
    },

    totalAvgYield: function() {
      return this.avgYieldPercent * 0.01 + 1
    },

    // Returns an array of capital each year
    values: function() {
      var array = []

      this.ageRange.forEach(x => {
        let value = this.removeTaxes ? this.capitalWithoutTaxesByAge(x) : this.capitalByAge(x)
        array.push(value)
      })

      return array
    }
  },
  methods: {
    // Generates an array from start to stop
    range: function(start, stop, step = 1) {
      return Array(Math.ceil((stop - start) / step))
        .fill(start)
        .map((x, y) => x + y * step)
    },

    // Calculates the capital for the given age n
    capitalByAge: function(n, round = true) {
      // Calculate age offset
      let x = n - this.age
      let ceil = Math.pow(this.totalAvgYield, x)
      let value = (this.capital + x * this.montlyDeposit * 12) * ceil

      return round ? Math.round(value) : value
    },

    capitalWithoutTaxesByAge: function(n, round = true) {
      let value = this.investmentByAge(n) + this.totalEarningsByAge(n) * (1 - this.taxes)

      return round ? Math.round(value) : value
    },

    // Calculates the total amount invested by the given age
    investmentByAge: function(n, round = true) {
      // Calculate age offset
      let x = n - this.age
      let value = this.capital + x * this.montlyDeposit * 12

      return round ? Math.round(value) : value
    },

    yieldRateByAge: function(n, round = true) {
      let x = n - this.age
      let value = Math.pow(this.totalAvgYield, x) - 1

      return round ? Math.round(value) : value
    },

    totalEarningsByAge: function(n, round = true) {
      let value = this.capitalByAge(n) - this.investmentByAge(n)

      return round ? Math.round(value) : value
    },

    // Savely parses an int
    saveParseToInt: function(string, defaultValue = 0) {
      let value = parseInt(string, 10)
      return value ? value : defaultValue
    },

    // Savely parses a float
    saveParseToFloat: function(string, defaultValue = 0.0) {
      string = string.replace(',', '.')
      let value = parseFloat(string)
      return value ? value : defaultValue
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

.highlight {
  color: #2196f3;
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
