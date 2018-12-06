<template>
<div>
  <data-grid
    sql="select c.fechafin,c.fechainicio,c.descripcion from partido as c  where 1=1 [[filters]]"
    :columns="[
        {label: 'Partido', column: 'descripcion' },
        {label: 'Fecha de inicio', column: 'fechainicio' },
        {label: 'Fecha final', column: 'fechafin' },

        ]"
    :responsive-columns="[
        { column: 'descripcion', },
        { column: 'fechafin' },
    ]"
    :search-columns="[{ column: 'c.fechafin', label: 'fechafin' },
       { column: 'c.descripcion', label: 'Dirección' }]"
    order-by="c.idpartido"
     ref="grid"

      :show-more-options="false"
      :has-actions="true"
    >
    <template slot="row-actions" slot-scope="props">
         <button type="button" class="v-btn v-btn--flat v-btn--icon theme--light " @click="edit(props.row)">
           <div class="v-btn__content">
             <i aria-hidden="true" class="v-icon material-icons theme--light">mode_edit</i>
           </div>
         </button>
         <button type="button" class="v-btn v-btn--flat v-btn--icon theme--light danger-tex" @click="_delete(props.row)">
           <div class="v-btn__content">
             <i aria-hidden="true" class="v-icon material-icons theme--light">delete</i>
           </div>
         </button>
       </template>
    </data-grid>

    <v-fab-transition >
                 <v-btn
                   color="blue"

                   dark

                    style="position:fixed;z-index:4440;bottom:15px"
                   right
                   fab
             @click="add_dialog=true"
                 >
                   <v-icon>add</v-icon>
                 </v-btn>
   </v-fab-transition>
<v-dialog v-model="add_dialog" >
<v-card>
<v-card-title>
<span class="headline">Crear partido</span>
</v-card-title>
<v-card-text>
    <v-form v-model="valid"  ref="form">
    <v-stepper v-model="stepper">
       <v-stepper-header>
         <v-stepper-step :complete="stepper>1" step="1">Lugar</v-stepper-step>
         <v-divider></v-divider>
          <v-stepper-step step="2" :complete="stepper>2">Detalles</v-stepper-step>
          <v-divider></v-divider>
         <v-stepper-step step="3">Fin</v-stepper-step>

       </v-stepper-header>



       <v-stepper-items>
         <v-stepper-content step="1">
           <v-card class="mb-5" >
             <v-layout row>
               <v-flex >
                 <v-card>


                   <v-list three-line>


                       <v-list-tile
                        v-for="(cancha,index) of canchas"
                        @click="setCancha(cancha)"
                       >
                         <v-list-tile-avatar>
                           <img :src="cancha.imagen">
                         </v-list-tile-avatar>

                         <v-list-tile-content>
                           <v-list-tile-title v-html="cancha.nombre"></v-list-tile-title>
                           <v-list-tile-sub-title v-html="cancha.descripcion" class="truncate"></v-list-tile-sub-title>
                         </v-list-tile-content>
                       </v-list-tile>

                   </v-list>
                 </v-card>
               </v-flex>
             </v-layout>
           </v-card>
           </v-stepper-content>
         <v-stepper-content step="2">
           <v-card class="mb-5" >
             <div  class="container grid-list-md">
    <div class="layout wrap">



            <v-flex xs12 sm6 md6>
              <v-menu
        ref="datepicker_menu"
        :close-on-content-click="false"
        v-model="menu1"
        :nudge-right="40"
        lazy
        transition="scale-transition"
        offset-y
        full-width
        max-width="290px"
        min-width="290px"
      >
        <v-text-field
          slot="activator"
          v-model="row.fechainicio"
          label="Fecha de inicio"
          hint="YYYY-MM-DD"
          persistent-hint
          prepend-icon="event"

        ></v-text-field>
        <v-date-picker v-model="row.fechainicio"  @input="menu1 = false" ref="picker"
        :max="new Date().toISOString().substr(0, 10)"
      min="1950-01-01"></v-date-picker>
      </v-menu>
              </v-flex>
              <v-flex xs12 sm6 md6>
                <v-menu
          ref="datepicker_menu2"
          :close-on-content-click="false"
          v-model="menu2"
          :nudge-right="40"
          lazy
          transition="scale-transition"
          offset-y
          full-width
          max-width="290px"
          min-width="290px"
        >
          <v-text-field
            slot="activator"
            v-model="row.fechafin"
            label="Fin del partido"
            hint="YYYY-MM-DD"
            persistent-hint
            prepend-icon="event"

          ></v-text-field>
          <v-date-picker v-model="row.fechafin"  @input="menu2 = false" ref="picker2"
          :max="new Date().toISOString().substr(0, 10)"
        min="1950-01-01"></v-date-picker>
        </v-menu>
                </v-flex>
              <v-flex xs12 sm12 md12>
                <v-checkbox
          label="Estado"
          v-model="row.estado"
        ></v-checkbox>
                </v-flex>
          </div>
          </div>
         </v-card>


           <v-btn
             color="primary"
             @click="stepper = 3"
           >
             Continuar
           </v-btn>
           <v-btn flat  @click="stepper=1">Anterior</v-btn>
         </v-stepper-content>



         <v-stepper-content step="3">
           <v-card
             class="mb-5">
             <div  class="container grid-list-md">
    <div class="layout wrap">
      <v-flex xs12 sm12 md12>
        <v-textarea
  v-model="row.descripcion"
  box
  label="Descripción"
  auto-grow
  ></v-textarea>
        </v-flex>
        </div>
        </div>

           </v-card>

           <v-btn flat  @click="stepper=2">Anterior</v-btn>
         </v-stepper-content>
       </v-stepper-items>
     </v-stepper>
   </v-form>

</v-card-text>
<v-card-actions>
<v-spacer></v-spacer>
<v-btn color="blue darken-1" flat @click="add_dialog = false">Cerrar</v-btn>
<v-btn color="blue darken-1" flat @click="save">Guardar</v-btn>
</v-card-actions>
</v-card>
</v-dialog>
</div>
</template>
<script>
import Helpers from '@/scripts/Helpers'
export default {
  name: 'pichanga',
  data () {
     return {
       stepper:0,
       valid:false,
       row:{
         fechainicio:moment(new Date()).format('YYYY-MM-DD'),
       fechafin:moment(new Date()).format('YYYY-MM-DD'),
       estado:1,
       idusuario:$_SESSION.user.id
       },

       menu1: false,
       menu2:false,
      canchas:[],
      add_dialog:false,
    };
   },
   created:function () {
     this.getCanchas();
    //    this.getPartidos();
   },
   watch: {
     menu1 (val) {
       val && this.$nextTick(() => (this.$refs.picker.activePicker = 'YEAR'))
     },
     menu2(val){
        val && this.$nextTick(() => (this.$refs.picker2.activePicker = 'YEAR'))
     }
   },

   methods:{
     setCancha(row){
       this.stepper=2;
       this.row.idcancha=row.id;
     },
     getCanchas(){
       axios.get('/cancha/get').then(response=>{
         console.log(response)
         if(response.data.state){
           this.canchas=response.data.rows;
         }
       });
     },
     getPartidos(){
       console.clear();
       axios.get("http://192.168.1.36:8888/api/partidos").then(response=>{
         console.log(response)
       });
     },
     save(){
       console.log(this.row)

        if (this.$refs.form.validate()) {
          $.ajax({
       type: "POST",
       contentType: "application/json",
       url: $_SESSION.JAVA_API+"/match/create",
       data: JSON.stringify(this.row),
       dataType: 'json',
       cache: false,
       timeout: 600000,
       success: function (data) {
         this.add_dialog=false;
          console.log(data)
       },
       error: function (e) {
console.log(e)
       }
   });
        //  var data=Helpers.serialize(this.row);
/*
          axios.post($_SESSION.JAVA_API+'/api/partido',JSON.stringify(this.row),{

        headers: {
        //  'Content-Type': 'multipart/form-data',
          'Content-Type': 'aplication/json',
          'dataType': 'json',
          'cache': false,
        'timeout': 600000,
        }
          }).then(r=>{
            console.log(r);
          });*/

        }
     },
     pickFile () {
         this.$refs.image.click();
     },

 onFilePicked (e) {

   const files = e.target.files;
   console.log(files)
   if(files[0] !== undefined) {
     this.imageName = files[0].name
     if(this.imageName.lastIndexOf('.') <= 0) {
       return
     }
    /* const fr = new FileReader ();
     fr.readAsDataURL(files[0])
     fr.addEventListener('load', () => {
       this.imageUrl = fr.result
       this.imageFile = files[0] // this is an image file that can be sent to server...
     })*/
     this.imageFile = files[0];
   } else {
     this.imageName = ''
     this.imageFile = ''
     this.imageUrl = ''
   }
 },
 edit(row){

 },
 _delete(row){

 }
   }
}
</script>
