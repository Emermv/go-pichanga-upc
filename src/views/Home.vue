<template>
  <div>
<div v-show="tab==1">
   <div ref="map"  style="height:570px;width:100%"></div>
</div>
<div v-if="tab==2">
  <v-layout row>
    <v-flex >
      <v-card>


        <v-list three-line>
          <template v-for="(item, index) in items_fav">
            <v-subheader
              v-if="item.header"
              :key="item.header"
            >
              {{ item.header }}
            </v-subheader>

            <v-divider
              v-else-if="item.divider"
              :inset="item.inset"
              :key="index"
            ></v-divider>

            <v-list-tile
              v-else
              :key="item.title"
              avatar
              @click=""
            >
              <v-list-tile-avatar>
                <img :src="item.avatar">
              </v-list-tile-avatar>

              <v-list-tile-content>
                <v-list-tile-title v-html="item.title"></v-list-tile-title>
                <v-list-tile-sub-title v-html="item.subtitle"></v-list-tile-sub-title>
              </v-list-tile-content>
            </v-list-tile>
          </template>
        </v-list>
      </v-card>
    </v-flex>
  </v-layout>
</div>
<div v-else-if="tab==3">

  <v-layout row>
    <v-flex >
      <v-card>


        <v-list subheader>
          <v-subheader>Recientes</v-subheader>
          <v-list-tile
            v-for="item in recents"
            :key="item.id"
            avatar
            @click=""
          >
            <v-list-tile-avatar>
              <img :src="item.avatar">
            </v-list-tile-avatar>

            <v-list-tile-content>
              <v-list-tile-title v-html="item.descripcion"></v-list-tile-title>
                <v-list-tile-sub-title v-html="item.fechainicio"></v-list-tile-sub-title>
                <v-list-tile-sub-title v-html="item.fechafin"></v-list-tile-sub-title>
            </v-list-tile-content>

            <v-list-tile-action>
              <v-icon :color="item.active ? 'teal' : 'grey'">chat_bubble</v-icon>
            </v-list-tile-action>
          </v-list-tile>
        </v-list>

        <v-divider></v-divider>

      </v-card>
    </v-flex>
  </v-layout>
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
     @click="tab=1"
   >
     <span>Actual</span>
     <v-icon>home</v-icon>
   </v-btn>

   <v-btn
     color="teal"
     flat
     value="favorites"
      @click="tab=2"
   >
     <span>Favoritos</span>
     <v-icon>favorite</v-icon>
   </v-btn>

   <v-btn
     color="teal"
     flat
     value="nearby"
      @click="tab=3"
   >
     <span>Historial</span>
     <v-icon>history</v-icon>
   </v-btn>
 </v-bottom-nav>

    </div>
</template>

<script>
// @ is an alias to /src
import HelloWorld from '@/components/HelloWorld.vue'

export default {
  name: 'home',
  data () {
     return {
       tab:1,
       bottomNav: 'recent',
       map:null,
       marker:null,
       maps:{results:null},
       recents: [,
       ],
       items_fav: [
          { header: 'Today' },
          {
            avatar: 'https://cdn.vuetifyjs.com/images/lists/1.jpg',
            title: 'Brunch this weekend?',
            subtitle: "<span class='text--primary'>Ali Connors</span> &mdash; I'll be in your neighborhood doing errands this weekend. Do you want to hang out?"
          },
          { divider: true, inset: true },
          {
            avatar: 'https://cdn.vuetifyjs.com/images/lists/2.jpg',
            title: 'Summer BBQ <span class="grey--text text--lighten-1">4</span>',
            subtitle: "<span class='text--primary'>to Alex, Scott, Jennifer</span> &mdash; Wish I could come, but I'm out of town this weekend."
          },
          { divider: true, inset: true },
          {
            avatar: 'https://cdn.vuetifyjs.com/images/lists/3.jpg',
            title: 'Oui oui',
            subtitle: "<span class='text--primary'>Sandra Adams</span> &mdash; Do you have Paris recommendations? Have you ever been?"
          },
          { divider: true, inset: true },
          {
            avatar: 'https://cdn.vuetifyjs.com/images/lists/4.jpg',
            title: 'Birthday gift',
            subtitle: "<span class='text--primary'>Trevor Hansen</span> &mdash; Have any ideas about what we should get Heidi for her birthday?"
          },
          { divider: true, inset: true },
          {
            avatar: 'https://cdn.vuetifyjs.com/images/lists/5.jpg',
            title: 'Recipe to try',
            subtitle: "<span class='text--primary'>Britta Holt</span> &mdash; We should eat this: Grate, Squash, Corn, and tomatillo Tacos."
          }
        ]
     }
   },
   created:function(){
     this.getLocation();
     axios.get($_SESSION.API+'/match/recents').then(response=>{
       console.log(response)
       if(response.data.state){
         this.recents=response.data.rows;
       }
     });
   },
   mounted:function(){

   },
   methods:{
     initMap(pos){
       this.map = new google.maps.Map(this.$refs.map, {
             center: pos,
             zoom: 15
           });
           this.marker= new google.maps.Marker({
       position: pos,
       map: this.map,
       title: 'Posición actual'
     });
     var service = new google.maps.places.PlacesService(map);
         service.textSearch({
           location: coords,
           radius: 500,
            query: 'parqueos,parkings'
         }, (results,status)=>{
           console.log(results);
           this.maps.results=results;
           if (status === google.maps.places.PlacesServiceStatus.OK) {
          for (var i = 0; i < results.length; i++) {

           this.createMarker(results[i]);
           }
       }
     });

     },
     getLocation(){
    if (navigator.geolocation) {
        navigator.geolocation.getCurrentPosition((position)=>{
          console.log(position);
        this.initMap({lat:position.coords.latitude,lng:position.coords.longitude});
        });
    } else {
       console.warn("Geolocation is not supported by this browser.");
    }
  },
   createMarker(place) {

       var image = {
   url:"assets/logo.png" ,
   size: new google.maps.Size(100, 100),
 };
 var shape = {
  coords: [1, 1, 1, 20, 18, 20, 18, 1],
  type: 'poly'
};
       var marker = new google.maps.Marker({
         map: map,
         position: place.geometry.location,
         icon:image,
          shape: shape,
       });

       google.maps.event.addListener(marker, 'click', function(e) {
         console.log("marker click",e);
         //infowindow.setContent(place.name);
         //infowindow.open(map, this);
        // toggleBounce(marker);
       });

       return marker;
     }
   }
   /*
  components: {
    HelloWorld
  }*/
}
</script>
