<template>
  <div>
     <div ref="map"  style="height:500px;width:100%"></div>
    <v-card height="200px" flat>
   <div class="headline text-xs-center pa-5">
     Active: {{ bottomNav }}
   </div>
   <v-bottom-nav
     :active.sync="bottomNav"
     :value="true"
     absolute
     color="transparent"
   >
     <v-btn
       color="teal"
       flat
       value="recent"
     >
       <span>Recent</span>
       <v-icon>history</v-icon>
     </v-btn>

     <v-btn
       color="teal"
       flat
       value="favorites"
     >
       <span>Favorites</span>
       <v-icon>favorite</v-icon>
     </v-btn>

     <v-btn
       color="teal"
       flat
       value="nearby"
     >
       <span>Nearby</span>
       <v-icon>place</v-icon>
     </v-btn>
   </v-bottom-nav>
 </v-card>
    </div>
</template>

<script>
// @ is an alias to /src
import HelloWorld from '@/components/HelloWorld.vue'

export default {
  name: 'home',
  data () {
     return {
       bottomNav: 'recent',
       map:null
     }
   },
   mounted:function(){
    this.map = new google.maps.Map(this.$refs.map, {
          center: {lat: -34.397, lng: 150.644},
          zoom: 8
        });
   },/*
  components: {
    HelloWorld
  }*/
}
</script>
