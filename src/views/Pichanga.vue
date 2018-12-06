<template>
<div>
  <v-container>
    <v-form v-model="valid"  ref="form">
    <v-stepper v-model="stepper">
       <v-stepper-header>
         <v-stepper-step :complete="stepper>1" step="1">General</v-stepper-step>

         <v-divider></v-divider>

         <v-stepper-step step="2">Fin</v-stepper-step>
       </v-stepper-header>

       <v-stepper-items>
         <v-stepper-content step="1">
           <v-card class="mb-5" >
             <div  class="container grid-list-md">
    <div class="layout wrap">
      <v-flex xs12 sm6 md6 >
      <v-select
      v-model="row.idCancha"
      :items="canchas"
      item-text="nombre"
       item-value="id"
      label="Cancha"></v-select>
      </v-flex>


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
          v-model="row.fechaInicio"
          label="Fecha de inicio"
          hint="YYYY-MM-DD"
          persistent-hint
          prepend-icon="event"

        ></v-text-field>
        <v-date-picker v-model="row.fechaInicio"  @input="menu1 = false" ref="picker"
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
            v-model="row.fechaFin"
            label="Fin del partido"
            hint="YYYY-MM-DD"
            persistent-hint
            prepend-icon="event"

          ></v-text-field>
          <v-date-picker v-model="row.fechaFin"  @input="menu2 = false" ref="picker2"
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
             @click="stepper = 2"
           >
             Continuar
           </v-btn>

         </v-stepper-content>



         <v-stepper-content step="2">
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

           <v-btn
             color="primary"
             @click="save"
           >
             Guardar
           </v-btn>

           <v-btn flat  @click="stepper=1">Anterior</v-btn>
         </v-stepper-content>
       </v-stepper-items>
     </v-stepper>
   </v-form>
</v-container>

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
       row:{fechaInicio:moment(new Date()).format('YYYY-MM-DD'),estado:1,idUsuario:$_SESSION.user.id},

       menu1: false,
       menu2:false,
      canchas:[]
    };
   },
   created:function () {
     this.getCanchas();
   },
   mounted:function(){

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
     getCanchas(){
       axios.get('/cancha/get').then(response=>{
         console.log(response)
         if(response.data.state){
           this.canchas=response.data.rows;
         }
       });
     },
     save(){
       console.log(this.row)

        if (this.$refs.form.validate()) {
        //  var data=Helpers.serialize(this.row);

          axios.post($_SESSION.JAVA_API+'/match/create',this.row,{

        headers: {
          'Content-Type': 'multipart/form-data'
        }
          }).then(r=>{
            console.log(r);
          });
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
 }
   }
}
</script>
