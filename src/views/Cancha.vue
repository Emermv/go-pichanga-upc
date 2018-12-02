<template>
<div style="position:relative">

    <data-grid
      :sql="sql"
      :columns="columns"
      :responsive-columns="responsiveColumns"
      :search-columns="searchColumns"
      order-by="c.id"
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
          <span class="headline">Crear cancha</span>
        </v-card-title>
        <v-card-text>
          <v-form v-model="valid"  ref="form">
          <v-stepper v-model="stepper">
             <v-stepper-header>
               <v-stepper-step :complete="stepper>1" step="1">General</v-stepper-step>

               <v-divider></v-divider>

               <v-stepper-step :complete="stepper > 2" step="2">Referencias</v-stepper-step>

               <v-divider></v-divider>

               <v-stepper-step step="3">Fin</v-stepper-step>
             </v-stepper-header>

             <v-stepper-items>
               <v-stepper-content step="1">
                 <v-card class="mb-5" >
                   <div  class="container grid-list-md">
          <div class="layout wrap">
                       <v-flex xs12 sm6 md6>
                     <v-text-field
                    v-model="row.nombre"
                    :rules="[v => !!v || 'Name is required']"
                    label="Nombre"
                    required
                    ></v-text-field>
                    </v-flex>
                    <v-flex xs12 sm6 md6>
                      <v-text-field
                     v-model="row.direccion"
                     :rules="[v => !!v || 'Direction is required']"
                     label="Dirección"
                     required
                     ></v-text-field>
                      </v-flex>
                <v-flex xs12 sm12 md12>
                        <v-radio-group v-model="row.tipo" row>
             <v-radio
               label="Privado"
               value="0"
             ></v-radio>
             <v-radio
               label="Público"
               value="1"
             ></v-radio>
           </v-radio-group>
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
          <v-carousel hide-delimiters v-show="images.length>0" height="300">
            <v-carousel-item
              v-for="(item,i) in images"
              :key="i"
              :src="item.src"
            ></v-carousel-item>
          </v-carousel>
          </v-flex>
          <v-flex xs12 sm12 md12>

          <v-text-field
          v-model="imageName"
          label="Foto"
          prepend-icon='attach_file'
          @click='pickFile'
          ></v-text-field>
          <input
                    type="file"
                    style="display: none"
                    ref="image"
                    multiple
                    accept="image/*"
                    @change="onFilePicked"
                  >
          </v-flex>

            </div>
            </div>
               </v-card>

                 <v-btn
                   color="primary"
                   @click="stepper = 3">Continuar</v-btn>

                 <v-btn flat @click="stepper=1">Anterior</v-btn>
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
  name: 'cancha',
  data () {
     return {
       stepper:0,
       valid:false,
       add_dialog:false,
       row:{tipo:'1',latitud:100,longitud:100,altitud:400},
       images:[],
       image_files:[],
       menu1: false,
      imageName: '',
      imageUrl: '',
      imageFile: '',
      sql:'select c.nombre,c.direccion,c.tipo from cancha as c  where 1=1 [[filters]]',
      searchColumns: [
         { column: "c.nombre", label: 'Nombre' },
         { column: 'c.direccion', label: 'Dirección' },
     ],
     columns: [
         { label: 'Nombre', column: 'nombre' },
         { label: 'Dirección', column: 'direccion' },

     ],
     responsiveColumns: [
         { column: 'nombre', },
         { column: 'direccion' },
     ],
     }
   },
   mounted:function(){

   },
   watch: {
     menu1 (val) {
       val && this.$nextTick(() => (this.$refs.picker.activePicker = 'YEAR'))
     }
   },
   methods:{
     edit(row){
       console.log(row)
     },
     _delete(row){

     },
     save(){
       console.log(this.row)

        if (this.$refs.form.validate()) {
          var data=Helpers.serialize(this.row);
          data.append('id_usuario',$_SESSION.user.id);
          var i=0;
          for(var img of this.image_files){
            data.append('image-'+i,img);
            i++;
          }
          data.append('image_size',i);

          axios.post($_SESSION.API+'/cancha/create',data).then(r=>{
            this.add_dialog=false;
            if(r.data.state){
              this.$refs.grid.getData(true);
            }
            swal({
  title: "Alerta!",
  text: r.data.message,
  icon: r.data.state?"success":"error",
  button: "Ok",
});
          });
        }
     },
     pickFile () {
         this.$refs.image.click();
         this.image_files=[];
         this.images=[];
     },

 onFilePicked (e) {

   const files = e.target.files;
   console.log(files);
   if(files[0] !== undefined) {

     this.imageName = files[0].name
     if(this.imageName.lastIndexOf('.') <= 0) {
       return
     }
    for(var img of files){
      const fr = new FileReader();
      fr.readAsDataURL(img);
      fr.addEventListener('load', () => {
        this.images.push({src:fr.result});
        this.image_files.push(img);
      });
    }

   }else{
     this.imageName = ''
     this.imageFile = ''
     this.imageUrl = ''
   }
 }
   }
}
</script>
