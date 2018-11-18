import Vue from 'vue'

import './plugins/vuetify'
import App from './App.vue'
import Login from './Login.vue'
import router from './router'
import Constants from './scripts/Constants'
Vue.config.productionTip = false
window.$_SESSION={user:null};
Object.assign($_SESSION,Constants);
if($_SESSION.user){
  new Vue({
    router,
    render: h => h(App)
  }).$mount('#app')
}else{
  new Vue({
    router,
    render: h => h(Login)
  }).$mount('#app')
}
