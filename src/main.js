import 'normalize.css'

import Vue from 'vue'
import App from './App.vue'
import vuetify from './plugins/vuetify'
import i18n from './plugins/i18n'

Vue.config.productionTip = false

new Vue({
  render: h => h(App),
  vuetify,
  i18n
}).$mount('#app')
