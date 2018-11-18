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
      </v-toolbar>
      <v-content>
        <v-container  >
          <router-view/>
        </v-container>
      </v-content>
    </v-app>

</template>
<script>
  export default {
    data: () => ({
      drawer: null
    }),
    props: {
      source: String
    },
    methods:{
      navigate(uri){
        this.$router.push({path:uri});
      }
    }
  }
</script>
