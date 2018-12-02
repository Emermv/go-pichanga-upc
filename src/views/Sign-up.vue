<template>
<div>
  <v-form v-model="valid"  ref="form">
  <v-stepper v-model="stepper">
     <v-stepper-header>
       <v-stepper-step :complete="stepper>1" step="1">General</v-stepper-step>

       <v-divider></v-divider>

       <v-stepper-step :complete="stepper > 2" step="2">Usuario</v-stepper-step>

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
            v-model="user.nombre"
            :rules="[v => !!v || 'Name is required']"
            label="Nombres"
            required
            ></v-text-field>
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
          v-model="user.fecha_nacimiento"
          label="Fecha de nacimiento"
          hint="YYYY-MM-DD"
          persistent-hint
          prepend-icon="event"

        ></v-text-field>
        <v-date-picker v-model="user.fecha_nacimiento"  @input="menu1 = false" ref="picker"
        :max="new Date().toISOString().substr(0, 10)"
      min="1950-01-01"></v-date-picker>
      </v-menu>
              </v-flex>
        <v-flex xs12 sm12 md12>
                <v-radio-group v-model="user.genero" row>
     <v-radio
       label="Masculino"
       value="M"
     ></v-radio>
     <v-radio
       label="Femenino"
       value="F"
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
         <v-btn

           @click="goLogin"
         >
           Cancelar
         </v-btn>
       </v-stepper-content>

       <v-stepper-content step="2">
         <v-card
           class="mb-5">
           <div  class="container grid-list-md">
  <div class="layout wrap">
    <v-flex xs12 sm6 md6>
  <v-text-field
 v-model="user.usuario"
 :rules="[v => !!v || 'Usuario es requerido']"
 label="Usuario"
 required
 ></v-text-field>
 </v-flex>
 <v-flex xs12 sm6 md6>
<v-text-field
v-model="user.contrasenia"
:rules="[v => !!v || 'La contraseña es requerido']"
label="Contraseña"
required
type="password"
></v-text-field>
</v-flex>
 <v-flex xs12 sm6 md6>
<v-select
v-model="user.tipo_usuario"
:items="types"
item-text="text"
  item-value="field"
label="Tipo"></v-select>
</v-flex>
<v-flex xs12 sm6 md6>
<v-text-field
v-model="imageName"
label="Avatar"
prepend-icon='attach_file'
@click='pickFile'
></v-text-field>
<input
						type="file"
						style="display: none"
						ref="image"
						accept="image/*"
						@change="onFilePicked"
					>
</v-flex>
<v-flex xs12 sm6 md6 v-if="user.tipo_usuario==0">
<v-select
v-model="user.rol"
:items="roles"
item-text="text"
 item-value="field"
label="Rol"></v-select>
</v-flex>
    </div>
    </div>
       </v-card>

         <v-btn
           color="primary"
           @click="stepper = 3">Continuar</v-btn>

         <v-btn flat @click="stepper=1">Anterior</v-btn>
       </v-stepper-content>

       <v-stepper-content step="3" >
         <v-card
           class="mb-5" >
           <div  class="container grid-list-md">
  <div class="layout wrap">
    <v-flex xs12 sm12 md12>
      <v-textarea
v-model="user.biografia"
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

         <v-btn flat  @click="stepper=2">Anterior</v-btn>
       </v-stepper-content>
     </v-stepper-items>
   </v-stepper>
 </v-form>
</div>
</template>
<script>
import Helpers from '@/scripts/Helpers'
export default {
  data () {
     return {
       stepper:0,
       valid:false,
       user:{fecha_nacimiento:moment(new Date()).format('YYYY-MM-DD'),genero:'M',tipo_usuario:'0',rol:'0'},
       menu1: false,
      types:[{field:'1',text:'Proveedor'},{field:'0',text:'Pichanguero'}],
      roles:[
      {field:'0',text:'Guardameta'},
      {field:'1',text:'Defensa'},
      {field:'2',text:'Volante'},
      {field:'3',text:'Delantero'},

      ],
      imageName: '',
      imageUrl: '',
      imageFile: ''
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
     save(){
       console.log(this.user)
        if (this.$refs.form.validate()) {
          var data=Helpers.serialize(this.user);
          data.append('perfil',this.imageFile);
          axios.post('/user/create',data).then(r=>{
            console.log(r);
            if(r.data.state){
              swal("Alerta!","El usuario se ha creado satisfactoriamente","success");
              this.goLogin();

            }else{
              swal("Alerta!","Ocurrió un error inesperado al crear el usuario, por favor intentelo más tarde","error");
            }

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
 },
 goLogin(){
   this.$emit("show-login",true);
 }
   }
}
</script>
