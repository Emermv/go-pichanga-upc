import Vue from 'vue'
import Router from 'vue-router'
import Login_form from './views/login/Login-form.vue'

Vue.use(Router);

export default new Router({
//  mode: 'history',
  base: process.env.BASE_URL,
  routes: [
    {
      path: '/',
      name: 'login',
      components:{
        login:()=>Login_form
      }
    },
    {
      path:'/sign-up',
      name:'sign-up',
      components:{
        login:()=>import('./views/Sign-up.vue')
      }
    },
  ]
});
