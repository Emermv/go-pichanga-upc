<template>

<v-app>
<v-content>
  <v-container fluid fill-height>
    <v-layout align-center justify-center v-if="show_login">
      <v-flex xs12 sm8 md4>
        <v-card class="elevation-12">
          <v-toolbar dark color="primary">
            <v-toolbar-title>GoPichanga</v-toolbar-title>
            <v-spacer></v-spacer>
          </v-toolbar>
          <v-card-text>
            <v-form>
              <v-text-field prepend-icon="person" name="login" label="Usuario" type="text" v-model="user"></v-text-field>
              <v-text-field  prepend-icon="lock" name="password" label="Contraseña" type="password" v-model="password"></v-text-field>
            </v-form>
          </v-card-text>
          <v-card-actions>
            <v-spacer></v-spacer>
            <v-btn color="primary" @click.stop="autenticar">Login</v-btn>

          </v-card-actions>

            <v-flex>
               <v-btn flat small color="primary"  @click="show_login=false">Registrate</v-btn>
            </v-flex>
        </v-card>
      </v-flex>
    </v-layout>
      <v-layout align-center justify-center v-else>
      <SignUp v-on:show-login="changeLogin"/>
    </v-layout>
    <v-snackbar
        v-model="snackbar"
        :bottom="y === 'bottom'"
        :left="x === 'left'"
        :multi-line="mode === 'multi-line'"
        :right="x === 'right'"
        :timeout="timeout"
        :top="y === 'top'"
        :vertical="mode === 'vertical'"
      >
        {{ text }}
        <v-btn
          color="pink"
          flat
          @click="snackbar = false"
        >
          Close
        </v-btn>
      </v-snackbar>
  </v-container>
</v-content>
</v-app>
</template>

<script>
  import SignUp from '@/views/Sign-up.vue'
export default {
  data: () => ({
    show_login:true,
    user:'',
    password:'',
        snackbar: false,
         y: 'top',
         x: null,
         mode: '',
         timeout: 6000,
         text: 'Usuario y/o contraseña incorrecta!'
  }),
methods:{
  autenticar(){
    let form=new FormData();
    form.append("user",this.user);
    form.append("password",this.password);
     axios.post("/user/autenticate",form).then(r=>{
       console.log(r)
       if(r.data.state){
         localStorage.setItem("user",JSON.stringify(r.data.user));
         location.reload();
       }else{
         this.snackbar=true;
       }
     });
  },
  changeLogin(state){
  this.show_login=state;
  },
  navigate(uri){
    this.$router.push({path:uri});
  },
},
components:{
  SignUp
}
}
</script>
