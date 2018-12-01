<template>

    <v-app id="inspire" dark>
      <v-navigation-drawer
        v-model="drawer"
        fixed
        app
      >
        <v-list dense>
          <v-list-tile @click="navigate('/')">
            <v-list-tile-action>
              <v-icon>home</v-icon>
            </v-list-tile-action>
            <v-list-tile-content>
              <v-list-tile-title>
                Inicio
              </v-list-tile-title>
            </v-list-tile-content>
          </v-list-tile>
          <v-list-tile @click="navigate('/cancha')">
            <v-list-tile-action>
              <v-icon>view_day</v-icon>
            </v-list-tile-action>
            <v-list-tile-content>
              <v-list-tile-title>
                 Administrar canchas
              </v-list-tile-title>
            </v-list-tile-content>
          </v-list-tile>
          <v-list-tile @click="navigate('/pichanga')">
            <v-list-tile-action>
              <v-icon>ballot</v-icon>
            </v-list-tile-action>
            <v-list-tile-content>
              <v-list-tile-title>
                 Crear pichanga
              </v-list-tile-title>
            </v-list-tile-content>
          </v-list-tile>
          <v-list-tile @click="navigate('/about')">
            <v-list-tile-action>
              <v-icon>settings</v-icon>
            </v-list-tile-action>
            <v-list-tile-content>
              <v-list-tile-title>
                 Configuración
              </v-list-tile-title>
            </v-list-tile-content>
          </v-list-tile>

        </v-list>
      </v-navigation-drawer>
      <v-toolbar dark fixed app>
        <v-toolbar-side-icon @click.stop="drawer = !drawer"></v-toolbar-side-icon>
        <v-toolbar-title>GoPichanga</v-toolbar-title>
        <v-spacer></v-spacer>

       <v-menu
     v-model="menu"
     :close-on-content-click="false"
     :nudge-width="200"
     offset-x
   >
   <v-avatar
    :tile="tile"
    slot="activator"
    size="40px"
    color="grey lighten-4"
  >
     <img :src="user.perfil">
  </v-avatar>

     <v-card>
       <v-list>
         <v-list-tile avatar>
           <v-list-tile-avatar>
             <img :src="user.perfil" >
           </v-list-tile-avatar>

           <v-list-tile-content>
             <v-list-tile-title>{{user.nombre}}</v-list-tile-title>
             <v-list-tile-sub-title>{{user.biografia}}</v-list-tile-sub-title>
           </v-list-tile-content>

           <v-list-tile-action>
             <v-btn
               :class="fav ? 'red--text' : ''"
               icon
               @click="fav = !fav"
             >
               <v-icon>star</v-icon>
             </v-btn>
           </v-list-tile-action>
         </v-list-tile>
       </v-list>

       <v-divider></v-divider>

       <v-list>
         <v-list-tile>
           <v-list-tile-action>
             <v-switch v-model="message" color="purple"></v-switch>
           </v-list-tile-action>
           <v-list-tile-title>Enable messages</v-list-tile-title>
         </v-list-tile>

         <v-list-tile>
           <v-list-tile-action>
             <v-switch v-model="hints" color="purple"></v-switch>
           </v-list-tile-action>
           <v-list-tile-title>Enable hints</v-list-tile-title>
         </v-list-tile>
         <v-list-tile @click="exit">
           <v-list-tile-avatar>
              <v-icon >exit_to_app</v-icon>
            </v-list-tile-avatar>

           <v-list-tile-title>Salir</v-list-tile-title>
         </v-list-tile>
       </v-list>
     </v-card>
   </v-menu>
      </v-toolbar>
      <v-content>

          <router-view/>
      
      </v-content>
    </v-app>

</template>
<script>
  export default {
    data: () => ({
      drawer: null,
      tile:false,
      fav: true,
      menu: false,
      message: false,
      hints: true,
      user:$_SESSION.user
    }),
    props: {
      source: String
    },
    methods:{
      navigate(uri){
        this.$router.push({path:uri});
      },
      exit(){
        localStorage.clear();
        location.reload();
      }
    }
  }
</script>
