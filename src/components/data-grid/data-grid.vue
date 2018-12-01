<template>
<div>
  <div class="md-card md-table md-table-card">
      <div class="data-grid-toolbar md-table-toolbar ">
          <div v-show="show_alternate_toolbar" class="md-layout  md-flex-100 md-vertical-align-center"
          style="padding-left: 5px">
              <div class="md-layout md-flex-95 md-flex-small-85 md-flex-xsmall-85 md-vertical-align-center"
              style="background: white;height: 35px">
                  <div class="md-layout md-flex-5 md-flex-small-15 md-flex-xsmall-15">

                      <button   type="button" class="v-btn v-btn--flat v-btn--icon ripple  " @click="toogle_alternate_toolbar(false)">
                        <div class="v-btn__content">
                         <i class="material-icons black-text">arrow_back</i>
                        </div>
                      </button>
                  </div>
                  <div class="md-layout md-flex-90 md-flex-small-70 md-flex-xsmall-70">
                      <div class="md-field">
                          <input :type="search_by.type?search_by.type:'text'" ref="search_input" @keyup="autocomplete"
                          :placeholder="'Buscar por '+search_by.label" class="black-text"/>
                          <span class="highlight"></span>
                          <span class="md-field-bar"></span>
                          <label></label>
                      </div>
                  </div>
                  <div class="md-layout md-flex-5 md-flex-small-15 md-flex-xsmall-15">

                      <button   v-show="$refs.search_input?$refs.search_input.value.length>0:false" type="button"
                         class="v-btn v-btn--flat v-btn--icon ripple  " @click="clearSearchBar">
                        <div class="v-btn__content">
                          <i  class=" material-icons black-text">close</i>
                        </div>
                      </button>
                  </div>
              </div>
              <div class="md-layout md-flex-5 md-flex-small-15 md-flex-xsmall-15">
                  <v-menu bottom left  offset-y   origin="center center" transition="scale-transition">
           <v-btn slot="activator" dark icon>
             <v-icon>filter_list</v-icon>
           </v-btn>
           <v-list>
             <slot name="more-options"></slot>
             <v-list-tile v-for="sc in searchColumns" @click="changeColumnFilter(sc)">
               <v-list-tile-title>
                  {{sc.label}}
               </v-list-tile-title>
             </v-list-tile>
             <v-list-tile  @click="clearFilters">
               <v-list-avatar>
                  <i class="v-icon material-icons">clear_all</i>
               </v-list-avatar>
               <v-list-tile-title>
                 Mostrar todos
               </v-list-tile-title>
             </v-list-tile>
           </v-list>
         </v-menu>

              </div>
          </div>
          <div v-show="!show_alternate_toolbar" class="md-layout md-vertical-align-center">
              <div class="md-layout md-flex-100 md-align-end md-vertical-align-center">
                  <slot name="toolbar"></slot>
                  <button v-if="onAdd" @click="onAdd"  type="button" class="v-btn v-btn--flat v-btn--icon theme--light ripple md-hide-small md-hide-xsmall" >
                    <div class="v-btn__content">
                      <i aria-hidden="true" class=" material-icons theme--light white-text">add</i>
                    </div>
                  </button>
              <button  v-if="searchColumns.length>0" type="button" class="v-btn v-btn--flat v-btn--icon theme--light ripple  " @click="alternate_toolbar">
                <div class="v-btn__content">
                  <i aria-hidden="true" class=" material-icons theme--light white-text">search</i>
                </div>
              </button>
                  <v-menu bottom left v-if="showMoreOptions" offset-y   origin="center center" transition="scale-transition">
           <v-btn slot="activator" dark icon>
             <v-icon>more_vert</v-icon>
           </v-btn>
           <v-list>
             <slot name="more-options"></slot>
             <v-list-tile>
               <v-list-tile-avatar>
                 <i class="material-icons">settings</i>
           </v-list-tile-avatar>
               <v-list-tile-content>
               <v-list-tile-title>
                  Ajustes
               </v-list-tile-title>
             </v-list-tile-content>
             </v-list-tile>
           </v-list>
         </v-menu>


              </div>
          </div>
      </div>
      <template v-if="!isEmpty">
          <template v-if="isDesktop">
              <div class="md-table-fixed-header">
                  <table ref="grid_header">
                      <thead style="background:#37474f">
                          <tr>
                              <th class="md-table-head">
                                  <label v-if="hasCheckbox" class="md-checkbox">
                                      <input type="checkbox" @change.stop="onRowChangeAll">
                                      <span></span>
                                  </label>
                              </th>
                              <th v-for="cell in columns" @click.stop="sort(cell)"
                              v-bind:class="{'md-sorted' :cell.sorted,'md-table-head md-sortable':true}">
                                  <div class="md-table-head-container ripple">
                                      <div class="md-table-head-label">
                                          <i class="material-icons md-table-sortable-icon ">{{cell.sortype=='desc'?'arrow_upward':'arrow_downward'}}</i>

                                          <span v-html="cell.label"></span>
                                      </div>
                                  </div>
                              </th>
                              <th v-if="hasActions" class="md-table-head">
                                  <div class="md-table-head-container ripple">
                                      <div class="md-table-head-label">
                                          <i class="material-icons">confirmation_number</i>
                                      </div>
                                  </div>
                              </th>
                          </tr>
                      </thead>
                  </table>
              </div>
              <div class="md-content md-table-content md-scrollbar" @scroll.stop="onScroll"  :style="{height:height+'px'}">
                  <table ref="grid_body">
                      <tbody>
                          <tr v-for="row in rows"  v-bind:class="{'selected-row' :row._selected_row_,'md-table-row':true}"
                          @contextmenu.prevent="openContextMenu($event,row._index)"   >
                              <td v-if="hasCheckbox" :style="getBackground(row.state)" class="md-table-cell">
                                  <label class="md-checkbox">
                                      <input type="checkbox" :checked="row._selected_row_" @change.stop="onRowChange(row,$event)">
                                      <span></span>
                                  </label>
                              </td>
                              <td v-if="!hasCheckbox" :style="getBackground(row.state)" class="md-table-cell md-empty-cell">
                              </td>
                              <td class="md-table-cell" v-for="col in columns" @click.stop="onRowClick(row)">
                                  <div class="md-table-cell-container">
                                      <span v-html="row[col.column]"></span>
                                  </div>
                              </td>
                              <td v-if="hasActions" class="md-table-cell">
                                  <slot name="row-actions" v-bind:row="row"></slot>
                              </td>
                          </tr>
                      </tbody>
                  </table>
              </div>
          </template>
<template v-if="!isDesktop">
              <div class="md-content md-table-content " @scroll.stop="onScroll" :style="{height:height+'px'}">
                  <ul class="data-grid-list" ref="grid_body">
                      <li class="data-grid-list-item  ripple" v-for="row in rows"
                      :class="{ 'selected-row' :row._selected_row_,'md-table-row':true}" >
                          <div class="md-layout data-grid-list-item-container">
                              <div content class="md-layout md-flex-85 " @click="onRowClick(row)">
                                  <span v-for="col in responsiveColumns" class="flex-truncate"
                                   v-html="row[col.column]"></span>
                                  <hr class="md-divider md-inset">
                              </div>
                              <div actions class="md-layout md-flex-15 md-align-end" :style="getBackground(row.state)">

                                  <button type="button" class="v-btn v-btn--flat v-btn--icon ripple"  v-if="show_more_options_on_small" @click="openContextMenu($event,row._index)">
                                    <div class="v-btn__content"><i aria-hidden="true" class="material-icons dark-text">more_vert</i>
                                    </div>
                                  </button>

                                  <button type="button" class="v-btn v-btn--flat v-btn--icon ripple" @click="showDetail(row._index)">
                                    <div class="v-btn__content"><i aria-hidden="true" class="material-icons dark-text">remove_red_eye</i>
                                    </div>
                                  </button>
                              </div>
                          </div>
                      </li>
                  </ul>
              </div>
              <v-dialog v-model="opened_detail_dialog" fullscreen hide-overlay transition="dialog-bottom-transition">
     <v-card>
       <v-toolbar dark color="primary">
         <v-btn icon dark @click.native="opened_detail_dialog = false">
           <v-icon>arrow_back</v-icon>
         </v-btn>
         <v-toolbar-title>{{title}}</v-toolbar-title>
       </v-toolbar>
       <ul class="collection">
           <li class="collection-item ripple" v-for="col in columns">
               <strong v-html="col.label"> </strong>:
               <span v-html="row[col.column]"></span>
           </li>
       </ul>
     </v-card>
   </v-dialog>

          </template>
</template>
<template v-if="isEmpty">
          <div class="md-empty-state md-table-empty-state " :style="{height:height+'px'}">
              <div class="md-empty-state-container" ref="grid_body">
                  <strong class="md-empty-state-label">Not found!</strong>
                  <p class="md-empty-state-description">
                      Not found for this '{{$refs.search_input.value}}' query. Try a different search term or create a new.
                  </p>

                  <button v-if="onAdd" type="button" class=" v-btn  v-btn--round v-btn--small ripple white-text primary" @click="onAdd">
                    <div class="v-btn__content">Crear nuevo</div></button>
              </div>
          </div>
      </template>
<div class="md-table-pagination md-dense">
  <span> 0 - {{rows.length}} de  {{rowsSize}}</span>
</div>
<v-menu  v-model="showMenu" absolute offset-y ref="menu">
         <v-list>
         <v-list-tile v-if="onAdd" @click="onAdd">
                 <v-list-tile-avatar>
                 <v-icon color="#009688">add</v-icon>
               </v-list-tile-avatar>
                 <v-list-tile-title>Nuevo</v-list-tile-title>
         </v-list-tile>
         <v-list-tile v-if="onEdit" @click="onEdit(row)">
                 <v-list-tile-avatar>
                 <v-icon color="#ef6c00">mode_edit</v-icon>
               </v-list-tile-avatar>
                 <v-list-tile-title>Editar</v-list-tile-title>
         </v-list-tile>
         <v-list-tile v-if="onDelete" @click="onDelete(row)">
                 <v-list-tile-avatar>
                 <v-icon color="#ef5350">delete</v-icon>
               </v-list-tile-avatar>
                 <v-list-tile-title>Eliminar</v-list-tile-title>
         </v-list-tile>
         <v-list-tile v-if="onCancel" @click="onCancel(row)">
                 <v-list-tile-avatar>
                 <v-icon color="#ef5350">cancel</v-icon>
               </v-list-tile-avatar>
                 <v-list-tile-title>Anular</v-list-tile-title>
         </v-list-tile>
         <v-list-tile v-if="onPrint" @click="onPrint(row)">
                 <v-list-tile-avatar>
                 <v-icon color="#607d8b">print</v-icon>
               </v-list-tile-avatar>
                 <v-list-tile-title>Imprimir</v-list-tile-title>
         </v-list-tile>
         <slot name="context-menu"></slot>
       </v-list>
</v-menu>
</div>

</div>
</template>
<style>
  .md-table .md-table-fixed-header,.md-table-head{position:relative}.md-dropdown-menu-item>i,.md-sortable,.md-table-row.md-has-selection{cursor:pointer}.md-table{display:-webkit-box;display:flex;-webkit-box-orient:vertical;-webkit-box-direction:normal;flex-flow:column wrap;overflow-x:auto;background:#fff;color:#000;width:100%}.md-table .md-title{margin:0;font-size:1.2rem;font-weight:400}.md-table .md-table-fixed-header-active{border-bottom:1px solid}.md-table .md-table-content{-webkit-box-flex:1;flex:1;overflow-x:auto;transition:height .3s cubic-bezier(.4,0,.2,1)}.md-table-alternate-header-enter-active,.md-table-row,.md-table-sortable-icon{transition:.3s cubic-bezier(.4,0,.2,1)}.md-table .md-table-empty{display:-webkit-box;display:flex;-webkit-box-align:center;align-items:center;-webkit-box-pack:center;justify-content:center}.md-table table{width:100%;border-spacing:0;border-collapse:collapse;overflow:hidden}.md-table-head{padding:0;font-size:12px;line-height:16px;text-align:left}.md-table-cell.md-numeric,.md-table-head.md-numeric{text-align:right}.md-table-head:last-child .md-table-head-label{padding-right:24px}.md-table-head.md-sortable:first-of-type .md-table-sortable-icon,.md-table-head.md-table-cell-selection+.md-sortable .md-table-sortable-icon{right:8px;left:auto}.md-table-head .material-icons{width:16px;height:16px;font-size:16px}.md-table-head .material-icons:not(.md-sortable-icon){margin:0 4px}.data-grid-list,.data-grid-list .data-grid-list-item p,.md-table-cell-selection .md-checkbox{margin:0}.md-table-head .material-icons:first-child{margin-left:0}.md-table-head .material-icons:last-child{margin-right:0}.md-sortable.md-sorted .md-table-sortable-icon,.md-sortable:hover .md-table-sortable-icon{opacity:1}.md-sortable.md-sorted-desc .md-table-sortable-icon{-webkit-transform:translateY(-50%) rotate(180deg);transform:translateY(-50%) rotate(180deg)}.md-table-head-container{padding:0}.md-table-head-container,.md-table-head-label{overflow:hidden;text-overflow:ellipsis;white-space:nowrap}.md-table-head-label{height:28px;padding-left:24px;display:inline-block;position:relative;line-height:28px;color:#fff}.md-table-sortable-icon{position:absolute;top:50%;left:0;-webkit-transform:translateY(-50%);transform:translateY(-50%);opacity:0;color:#fff}.md-table-alternate-header{position:absolute;top:0;right:0;left:0;z-index:2;will-change:opacity,transform}.md-table-alternate-header-enter,.md-table-alternate-header-leave-active{opacity:0;-webkit-transform:translate3d(0,-100%,0);transform:translate3d(0,-100%,0)}.md-table-alternate-header-leave-active{transition:.2s cubic-bezier(.4,0,1,1)}.md-table-row{transition-property:background-color,font-weight;will-change:background-color,font-weight}.md-table-row:hover{background:0 0}.md-table-row.md-selected-single{font-weight:500}tbody .md-table-row td{border-top:1px solid #e0e0e0;padding:0}.md-table-cell-selection{width:66px}.md-table-cell-selection+td .md-table-cell-container,.md-table-cell-selection+th .md-table-head-label{padding-left:0}.md-table-cell-selection .md-table-cell-container,.md-table-cell-selection .md-table-cell-label,.md-table-cell-selection .md-table-head-container,.md-table-cell-selection .md-table-head-label{padding:0;display:-webkit-box;display:flex;-webkit-box-align:center;align-items:center;-webkit-box-pack:center;justify-content:center;overflow:visible}.md-table-cell-selection .md-checkbox .md-checkbox-container{width:18px;min-width:18px;height:18px}.md-table-cell-selection .md-checkbox .md-checkbox-container:after{top:-1px;left:4px}.md-table-empty-state{padding-left:24px}.md-table-cell{position:relative;transition:.3s cubic-bezier(.4,0,.2,1);font-size:13px;line-height:18px}.md-table-cell.md-empty-cell{min-width:20px}.md-table-cell:last-child .md-table-cell-container{padding-right:24px}.md-table-cell-container{padding:6px 32px 6px 24px}.md-table-pagination{height:30px;display:-webkit-box;display:flex;-webkit-box-flex:1;flex:1;-webkit-box-align:center;align-items:center;-webkit-box-pack:end;justify-content:flex-end;border-top:1px solid #e0e0e0;color:rgba(0,0,0,.54);font-size:12px;z-index:99;background:#cfd8dc;padding:0 5px;width:-webkit-fill-available}.data-grid-list{padding:0;border:1px solid #e0e0e0;border-radius:2px;overflow:hidden;position:relative}.data-grid-list .data-grid-list-item{background-color:#fff;line-height:1.5rem;margin:0}.data-grid-list .data-grid-list-item .data-grid-list-item-container{min-height:85px;padding-left:10px}.data-grid-list-item-container>[content]{font-size:14px}.data-grid-list-item-container>[content] :nth-child(1){font-size:16px}.data-grid-list-item-container>[content] :nth-child(2){color:rgba(0,0,0,.87)}.data-grid-list-item-container>[content] :nth-child(3){color:rgba(0,0,0,.54)}.data-grid-list .data-grid-list-item:last-child{border-bottom:none}.data-grid-list .data-grid-list-item.active{background-color:#26a69a;color:#eafaf9}.data-grid-list .data-grid-list-item{display:block;-webkit-transition:.25s;transition:.25s;color:rgba(0,0,0,.87)}.data-grid-list .data-grid-list-item:not(.active):hover{background-color:#ddd}.data-grid-list-item .md-divider{position:absolute;bottom:0;right:0;left:0}.md-divider.md-inset{margin-left:72px}.md-divider{height:1px;margin:0;padding:0;display:block;border:0;background-color:rgba(0,0,0,.12)}.data-grid-toolbar{min-height:40px;height:45px;display:-webkit-box;display:flex;-webkit-box-align:center;align-items:center;align-content:center;transition:.3s cubic-bezier(.4,0,.2,1);transition-property:opacity,background-color,box-shadow,color,min-height,-webkit-transform;transition-property:opacity,background-color,box-shadow,transform,color,min-height;transition-property:opacity,background-color,box-shadow,transform,color,min-height,-webkit-transform;will-change:opacity,background-color,box-shadow,transform,color,min-height;padding:0;-webkit-box-orient:horizontal;-webkit-box-direction:normal;flex-flow:row wrap;background-color:#37474f;color:#fff;width:-webkit-fill-available;box-shadow:0 11px 15px -7px rgba(0,0,0,.2),0 24px 38px 3px rgba(0,0,0,.14),0 9px 46px 8px rgba(0,0,0,.12)}.md-empty-state,.md-empty-state-container{-webkit-box-orient:vertical;-webkit-box-direction:normal;text-align:center}.selected-row{background:#b2dfdb!important}.md-empty-state{display:-webkit-box;display:flex;flex-direction:column;-webkit-box-align:center;align-items:center;-webkit-box-pack:center;justify-content:center;max-width:420px;padding:36px;margin:0 auto;position:relative;transition:opacity .15s cubic-bezier(0,0,.2,1),-webkit-transform .3s cubic-bezier(0,0,.2,1);transition:opacity .15s cubic-bezier(0,0,.2,1),transform .3s cubic-bezier(0,0,.2,1);transition:opacity .15s cubic-bezier(0,0,.2,1),transform .3s cubic-bezier(0,0,.2,1),-webkit-transform .3s cubic-bezier(0,0,.2,1);will-change:transform,opacity}.md-empty-state.md-rounded{max-width:auto;border-radius:50%}.md-empty-state.md-rounded .md-empty-state-container{padding:40px;position:absolute;top:0;right:0;bottom:0;left:0}.md-empty-state .md-button{margin:.5em 0 0}.md-empty-state-enter{opacity:0;-webkit-transform:scale(.87);transform:scale(.87)}.md-empty-state-enter .md-empty-state-container{opacity:0}.md-empty-state-container{display:-webkit-box;display:flex;flex-direction:column;-webkit-box-align:center;align-items:center;-webkit-box-pack:center;justify-content:center;transition:opacity .4s cubic-bezier(.4,0,.2,1);will-change:opacity}.md-empty-state-icon{width:160px;min-width:160px;height:160px;font-size:160px!important;margin:0}.md-empty-state-label{font-size:26px;font-weight:500;line-height:40px}.md-empty-state-description{margin:1em 0;font-size:16px;line-height:24px}.data-grid-toolbar .md-field{margin:0}.md-table .md-checkbox{margin-left:5px}

</style>
<script>
  import Constants from '../../scripts/Constants'
  export default{
    name:'data-grid',
    props: {
      rows: {
        type: Array,
        default:function(){
          return new Array();
        }
      },
      height: {
        type: Number,
        default: 400
      },
      limit: {
        type: Number,
        default: 20
      },
      startPage: {
        type: Number,
        default: 0
      },
      orderType: {
        type: String,
        default: 'desc'
      },
      orderBy: {
        type: String,
        default: null
      },
      sqlSize: {
        type: String,
        default: ''
      },
      columns: {
        type: Array,
        default: []
      },
      responsiveColumns: {
        type: Array,
        default: []
      },
      activeContextMenu: {
        type: Boolean,
        default: true
      },
      showMoreOptions: {
        type: Boolean,
        default: true
      },
      hasCheckbox: {
        type: Boolean,
        default: true
      },
      hasActions: {
        type: Boolean,
        default: false
      },
      url: {
        type: String,
        default: Constants.API+'/component/data_grid/'
      },
      sql: {
        type: String,
        default: ''
      },
      quitHeightOnDesktop: {
        type: Number,
        default: 150
      },
      quitHeightOnSmall: {
        type: Number,
        default: 120
      },
      onAdd: {
        type: Function,
        default: null,
      },
      onEdit: {
        type: Function,
        default: null,
      },
      onCancel: {
        type: Function,
        default: null,
      },
      onDelete: {
        type: Function,
        default: null,
      },
      onPrint: {
        type: Function,
        default: null,
      },
      searchColumns: {
        type: Array,
        default: []
      },
      title:{
        type:String,
        default:'Detalle'
      }

    },
    data: function() {
      return {
        row: {},
        search_by: {},
        rowsSize: 0,
        rendered: false,
        showMenu:false,
        isEmpty: false,
        show_alternate_toolbar: false,
        opened_detail_dialog:false,
        selectedIndex: -1,
        selectedRows: {},
        isDesktop: (window.innerWidth > 960),
        states: {
          '0': '#e0f2f1',
          '1': '#c8e6c9',
          '2': '#ffcdd2'
        }


      };
    },
    created: function() {
      this.getData();
      this.show_more_options_on_small = (this.onAdd || this.onEdit || this.onDelete || this.onCancel);
      this.onResize = (e) => {
        console.log(window.innerWidth);
        if (window.innerWidth <= 960) {
          if (!this.isDesktop) return;
          this.isDesktop = false;
          //  this.update();
          this.setSettings();
          //console.log("this.isDesktop", this.isDesktop);
        } else {
          if (this.isDesktop) return;
          this.isDesktop = true;

          this.setSettings();
          setTimeout(() => {
            this.setStyles();
          }, 50);
          //console.log("this.isDesktop", this.isDesktop);
        }
      };
      this.onRotate = () => {
        //console.log("orientationchange",screen.orientation);
        //this.update();
        this.setSettings();
      };
    },
    mounted: function() {
      this.setSettings();
      window.addEventListener('resize', this.onResize);
      window.addEventListener("orientationchange", this.onRotate);
    },
    destroyed: function() {
      window.removeEventListener('resize', this.onResize);
      window.removeEventListener('orientationchange', this.onRotate);
    },
    methods: {
      builtFilters(ignore_limit = false) {
        let sql_args = '';
        if (Object.keys(this.search_by).length > 0 && this.$refs.search_input.value.length > 0) {
          sql_args += ` and ` + this.search_by.column + ` like '%` + this.$refs.search_input.value.trim() + `%' `;
        }
        if (this.orderBy) {
          sql_args += ' order by ' + this.orderBy + ' ' + this.orderType;
        }
        if (!ignore_limit) {
          sql_args += ' limit ' + this.startPage + ',' + this.limit;
        }
        return sql_args;
      },
      getData(clear = false) {
        let args = new FormData();

        if (this.sql) {
          args.append('sql', this.sql);
        }
        if (clear) {
          this.startPage = 0;
          this.selectedRows = {};
          this.selectedIndex = -1;
        }
        args.append('limit', this.limit);
        args.append('sql_args', this.builtFilters());
        args.append('index', (this.rows.length > 0 && !clear) ? this.rows.length : 0);

        axios.post(this.url + "getRows", args).then((response) => {
          console.log(response);
          if (response && typeof response.data.rows == 'object') {

            this.rows = clear ? response.data.rows : this.rows.concat(response.data.rows);
            this.isEmpty = response.data.rows.length == 0;
            this.setSettings(this.isEmpty ? 40 : 0);

          }
          if (this.rowsSize == 0 || clear) {
            this.getSize();
          }
          if (!this.rendered && this.isDesktop && response.data.rows && response.data.rows.length > 0) {
            this.rendered = true;
            setTimeout(() => {
              this.setStyles();
            }, 50);
          }
          this.autocomplete_pending = false;
        }).catch(err => {
          this.isEmpty = true;
          console.log(err);
        });
      },
      getSize() {
        let args = new FormData();
        if (this.sqlSize) {
          args.append('sql', this.sqlSize);
        } else {
          args.append('use_default', true);
          args.append('sql', this.sql);
        }
        args.append('sql_args', this.builtFilters(true));
        args.append('limit', this.limit);
        axios.post(this.url + "getSize", args).then((response) => {
          console.log("size", response);
          this.rowsSize = response.data.size;

        });
      },
      clearSearchBar() {
        this.$refs.search_input.value = '';
        this.getData(true);
      },
      call_actions(callback, e) {
        try {
          eval(this[callback])(this.rows[this.selectedIndex]);
        } catch (err) {
          console.error(callback + " is undefined!", err);
        }
      },
      onRowChange(row, e) {


        row._selected_row_ = !row._selected_row_;
        if (e.target.checked) {
          this.selectedRows[row._index] = row;
        } else {
          delete this.selectedRows[row._index];
        }


        this.selectedIndex = row._index;
        console.warn("onRowChange", this.selectedRows);
      },
      onRowChangeAll(e) {
        if (e.target.checked) {
          for (let row of this.rows) {
            row._selected_row_ = e.target.checked;
            this.selectedRows[row._index] = row;
          }
        } else {
          for (let row of this.rows) {
            row._selected_row_ = e.target.checked;
          }
          this.selectedRows = {};
        }
      },
      clearFilters() {
        this.search_by = {};
        this.getData(true);
      },
      toogle_alternate_toolbar(state) {
        this.show_alternate_toolbar = state;
      },
      alternate_toolbar(e) {
        this.show_alternate_toolbar = true;
        if (Object.keys(this.search_by).length == 0) {
          this.search_by = this.searchColumns[0];
        }

        setTimeout(() => {
          this.$refs.search_input.focus();
          this.$refs.search_input.select();
        }, 50);
      },

      setSettings(quit = 0) {

        this.height = (window.innerHeight - (this.isDesktop ? (this.quitHeightOnDesktop) : this.quitHeightOnSmall + 1)) - quit;

        //this.$refs.grid_body.parentElement.style.height = this.height + 'px';
      },
      onScroll(e) {

        if (this.rows.length == this.rowsSize) return;
        /* console.log({
            height: this.$refs.grid_body.parentElement.scrollHeight,
            top: this.$refs.grid_body.parentElement.scrollTop,
            h:this.height
        });
  */
        if (Math.floor(this.$refs.grid_body.parentElement.scrollHeight - this.$refs.grid_body.parentElement.scrollTop) == this.height) {
          //console.log("getMoreData", this.startPage);
          this.startPage += this.limit;
          this.getData();
        }
      },

      open_menu(ref, e) {
        console.log(arguments);
        console.log({
          el: this.$refs[ref]
        })
        // this.$refs[ref].open(e);
      },
      onRowClick(row) {
        row._selected_row_ = true;
        this.selectedIndex = row._index;
        if (row._selected_row_) {
          for (let i in this.rows) {
            if (i != row._index) this.rows[i]._selected_row_ = false;
          }
        }
        if (typeof this.onClick == "function") {
          this.onClick.call(this, row);
        }
      },
      openContextMenu(e,index) {

        if (this.activeContextMenu) {
        e.preventDefault();
        this.showMenu=false;

          this.$refs.menu.absoluteX=e.clientX;
          this.$refs.menu.absoluteY=e.clientY;

          this.$nextTick(() => {
          this.showMenu = true;
          this.row=this.rows[index];
        });
          this.onRowClick(this.rows[index]);

        }
      },
      getBackground(state) {
        //    console.log(state);
        return {
          background: this.states[state],

        };
      },
      computedValue(row, col) {
        // console.log(row[col.column]);
        return row[col.column];
      },
      search(e) {
        e.preventDefault();
        this.getData(true);
        this.$refs.search_dialog.close();
      },
      setStyles() {
        let firstRow = this.$refs.grid_body.querySelectorAll('tbody>tr:first-child .md-table-cell');
        let headers = this.$refs.grid_header.querySelectorAll('thead>tr> .md-table-head');
        let i = 0;
        for (let cell of firstRow) {
          headers[i].style.width = cell.offsetWidth + 'px';
          headers[i++].style.minWidth = cell.offsetWidth + 'px';
        }
      },
      close() {
        this.$destroy();
      },
      showDetail(index) {
        this.row =this.rows[index];
        this.opened_detail_dialog = true;
      },

      autocomplete(e) {
        if (e.target.value.length >= 0 && !this.autocomplete_pending) {
          this.autocomplete_pending = true;
          this.getData(true);
        }

      },
      changeColumnFilter(by) {
        this.search_by=by;
        this.$refs.search_input.focus();
        this.$refs.search_input.select();
      },
      sort(cell) {

        let sortBy = cell.column;
        if (this.rows.length > 0) {
          let sorting = null;
          for (var col of this.columns) {
            if (col.column != sortBy) {
              col.sorted = false;
              col.sortype = "asc";
            } else {
              col.sorted = true;
              col.sortype = (col.sortype == 'asc' || col.sortype == undefined) ? 'desc' : 'asc';
              sorting = col;
            }
          }
          if (!isNaN(this.rows[0][sortBy])) {
            this.rows.sort((a, b) => {
              if (parseFloat(a[sortBy]) > parseFloat(b[sortBy])) return (sorting.sortype == 'asc') ? 1 : -1;
              if (parseFloat(a[sortBy]) < parseFloat(b[sortBy])) return (sorting.sortype == 'desc') ? 1 : -1;
              return 0;
            });
          } else {
            this.rows.sort((a, b) => {
              if (a[sortBy] > b[sortBy]) return (sorting.sortype == 'asc') ? 1 : -1;
              if (a[sortBy] < b[sortBy]) return (sorting.sortype == 'desc') ? 1 : -1;
              return 0;
            });
          }
        }
      },
    },
  }

</script>
