import Vue from 'vue'

import './plugins/vuetify'
import './plugins/libs'
import App from './App.vue'
import Login from './Login.vue'
import router from './router'
import './styles/app.css'
import Data_grid from './components/data-grid/data-grid.vue'
import Constants from './scripts/Constants'
Vue.config.productionTip = false

var user=localStorage.getItem("user");

window.$_SESSION={user:user?JSON.parse(user):null};
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
Vue.component('data-grid',Data_grid);
