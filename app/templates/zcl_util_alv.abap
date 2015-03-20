class zcl_util_alv definition .

public section.

  constants modo_e type xfeld value 'E'. "#EC NOTEXT
  constants modo_v type xfeld value 'V'. "#EC NOTEXT

  methods constructor
    importing
      !iv_container type scrfname .
  methods actualizar
    returning
      value(ev_valid) type xfeld .
  methods asignar_datos
    importing
      !it_datos type table .
  methods asignar_modo
    importing
      !iv_modo type xfeld .
  methods mostrar
    importing
      !is_estable type lvc_s_stbl optional
      !is_variant type disvariant optional
    changing
      !it_datos type table optional .
  methods obtener_datos
    exporting
      value(et_datos) type table .
  methods obtener_modo
    returning
      value(ev_modo) type xfeld .
  methods resetear .
protected section.

  data lv_container type scrfname .
  data lr_container type ref to cl_gui_custom_container .
  data lr_alvgrid type ref to cl_gui_alv_grid .
  data lt_catalogo type lvc_t_fcat .
  data lt_botones type ui_functions .
  data ls_layout type lvc_s_layo .
  data lv_modo type xfeld .
  data lt_filtro type lvc_t_sort .
  data lv_error type xfeld .

  methods crear_alv .
  methods cargar_layout .
  methods cargar_catalogo .
  methods cargar_botones .
  methods cargar_formato .
  methods cargar_estilo .
  methods cargar_filtro .
  methods cargar_ayudas .
  methods asignar_manejadores .
private section.
endclass.



class zcl_util_alv implementation.


* <SIGNATURE>---------------------------------------------------------------------------------------+
* | Instance Public Method ZCL_UTIL_ALV->ACTUALIZAR
* +-------------------------------------------------------------------------------------------------+
* | [<-()] EV_VALID                       TYPE        XFELD
* +--------------------------------------------------------------------------------------</SIGNATURE>
method actualizar.

    clear lv_error.

* Transfiere los datos a la tabla interna
  call method me->lr_alvgrid->check_changed_data
    importing
      e_valid = ev_valid.

  if ev_valid is initial.
    lv_error = 'X'.
  endif.

endmethod.


* <SIGNATURE>---------------------------------------------------------------------------------------+
* | Instance Public Method ZCL_UTIL_ALV->ASIGNAR_DATOS
* +-------------------------------------------------------------------------------------------------+
* | [--->] IT_DATOS                       TYPE        TABLE
* +--------------------------------------------------------------------------------------</SIGNATURE>
method asignar_datos.
endmethod.


* <SIGNATURE>---------------------------------------------------------------------------------------+
* | Instance Protected Method ZCL_UTIL_ALV->ASIGNAR_MANEJADORES
* +-------------------------------------------------------------------------------------------------+
* +--------------------------------------------------------------------------------------</SIGNATURE>
method asignar_manejadores.
endmethod.


* <SIGNATURE>---------------------------------------------------------------------------------------+
* | Instance Public Method ZCL_UTIL_ALV->ASIGNAR_MODO
* +-------------------------------------------------------------------------------------------------+
* | [--->] IV_MODO                        TYPE        XFELD
* +--------------------------------------------------------------------------------------</SIGNATURE>
method asignar_modo.
    lv_modo = iv_modo.
endmethod.


* <SIGNATURE>---------------------------------------------------------------------------------------+
* | Instance Protected Method ZCL_UTIL_ALV->CARGAR_AYUDAS
* +-------------------------------------------------------------------------------------------------+
* +--------------------------------------------------------------------------------------</SIGNATURE>
method cargar_ayudas.
endmethod.


* <SIGNATURE>---------------------------------------------------------------------------------------+
* | Instance Protected Method ZCL_UTIL_ALV->CARGAR_BOTONES
* +-------------------------------------------------------------------------------------------------+
* +--------------------------------------------------------------------------------------</SIGNATURE>
method cargar_botones.

* Estructura para botones por defecto
  data: ls_boton type ui_func.

  ls_boton = cl_gui_alv_grid=>mc_fc_load_variant.
  append ls_boton to lt_botones.

  ls_boton = cl_gui_alv_grid=>mc_fc_detail.
  append ls_boton to lt_botones.

  ls_boton = cl_gui_alv_grid=>mc_fc_pc_file.
  append ls_boton to lt_botones.

  ls_boton = cl_gui_alv_grid=>mc_fc_print.
  append ls_boton to lt_botones.

  ls_boton = cl_gui_alv_grid=>mc_fc_average.
  append ls_boton to lt_botones.

  ls_boton = cl_gui_alv_grid=>mc_fc_count.
  append ls_boton to lt_botones.

  ls_boton = cl_gui_alv_grid=>mc_fc_loc_append_row.
  append ls_boton to lt_botones.

  ls_boton = cl_gui_alv_grid=>mc_fc_loc_copy.
  append ls_boton to lt_botones.

  ls_boton = cl_gui_alv_grid=>mc_fc_loc_copy_row.
  append ls_boton to lt_botones.

  ls_boton = cl_gui_alv_grid=>mc_fc_loc_cut.
  append ls_boton to lt_botones.

  ls_boton = cl_gui_alv_grid=>mc_fc_loc_delete_row.
  append ls_boton to lt_botones.

  ls_boton = cl_gui_alv_grid=>mc_fc_loc_insert_row.
  append ls_boton to lt_botones.

  ls_boton = cl_gui_alv_grid=>mc_fc_loc_move_row.
  append ls_boton to lt_botones.

  ls_boton = cl_gui_alv_grid=>mc_fc_loc_paste.
  append ls_boton to lt_botones.

  ls_boton = cl_gui_alv_grid=>mc_fc_loc_paste_new_row.
  append ls_boton to lt_botones.

  ls_boton = cl_gui_alv_grid=>mc_fc_load_variant.
  append ls_boton to lt_botones.

  ls_boton = cl_gui_alv_grid=>mc_fc_maintain_variant.
  append ls_boton to lt_botones.

  ls_boton = cl_gui_alv_grid=>mc_fc_save_variant.
  append ls_boton to lt_botones.

  ls_boton = cl_gui_alv_grid=>mc_fc_current_variant.
  append ls_boton to lt_botones.

  ls_boton = cl_gui_alv_grid=>mc_fc_subtot.
  append ls_boton to lt_botones.

  ls_boton = cl_gui_alv_grid=>mc_fc_sum.
  append ls_boton to lt_botones.

  ls_boton = cl_gui_alv_grid=>mc_fc_graph.
  append ls_boton to lt_botones.

  ls_boton = cl_gui_alv_grid=>mc_fc_help.
  append ls_boton to lt_botones.

  ls_boton = cl_gui_alv_grid=>mc_fc_html.
  append ls_boton to lt_botones.

  ls_boton = cl_gui_alv_grid=>mc_fc_info.
  append ls_boton to lt_botones.


endmethod.


* <SIGNATURE>---------------------------------------------------------------------------------------+
* | Instance Protected Method ZCL_UTIL_ALV->CARGAR_CATALOGO
* +-------------------------------------------------------------------------------------------------+
* +--------------------------------------------------------------------------------------</SIGNATURE>
method cargar_catalogo.
endmethod.


* <SIGNATURE>---------------------------------------------------------------------------------------+
* | Instance Protected Method ZCL_UTIL_ALV->CARGAR_ESTILO
* +-------------------------------------------------------------------------------------------------+
* +--------------------------------------------------------------------------------------</SIGNATURE>
method cargar_estilo.
endmethod.


* <SIGNATURE>---------------------------------------------------------------------------------------+
* | Instance Protected Method ZCL_UTIL_ALV->CARGAR_FILTRO
* +-------------------------------------------------------------------------------------------------+
* +--------------------------------------------------------------------------------------</SIGNATURE>
method cargar_filtro.
endmethod.


* <SIGNATURE>---------------------------------------------------------------------------------------+
* | Instance Protected Method ZCL_UTIL_ALV->CARGAR_FORMATO
* +-------------------------------------------------------------------------------------------------+
* +--------------------------------------------------------------------------------------</SIGNATURE>
method cargar_formato.
endmethod.


* <SIGNATURE>---------------------------------------------------------------------------------------+
* | Instance Protected Method ZCL_UTIL_ALV->CARGAR_LAYOUT
* +-------------------------------------------------------------------------------------------------+
* +--------------------------------------------------------------------------------------</SIGNATURE>
method cargar_layout.

  me->ls_layout-zebra      = abap_true.
  me->ls_layout-cwidth_opt = abap_true.

endmethod.


* <SIGNATURE>---------------------------------------------------------------------------------------+
* | Instance Public Method ZCL_UTIL_ALV->CONSTRUCTOR
* +-------------------------------------------------------------------------------------------------+
* | [--->] IV_CONTAINER                   TYPE        SCRFNAME
* +--------------------------------------------------------------------------------------</SIGNATURE>
method constructor.
  lv_container = iv_container.
  me->resetear( ).

endmethod.


* <SIGNATURE>---------------------------------------------------------------------------------------+
* | Instance Protected Method ZCL_UTIL_ALV->CREAR_ALV
* +-------------------------------------------------------------------------------------------------+
* +--------------------------------------------------------------------------------------</SIGNATURE>
method crear_alv.

* Llama al constructor del ALV
  create object lr_alvgrid
    exporting
      i_parent          = lr_container
    exceptions
      error_cntl_create = 1
      error_cntl_init   = 2
      error_cntl_link   = 3
      error_dp_create   = 4
      others            = 5.

endmethod.


* <SIGNATURE>---------------------------------------------------------------------------------------+
* | Instance Public Method ZCL_UTIL_ALV->MOSTRAR
* +-------------------------------------------------------------------------------------------------+
* | [--->] IS_ESTABLE                     TYPE        LVC_S_STBL(optional)
* | [--->] IS_VARIANT                     TYPE        DISVARIANT(optional)
* | [<-->] IT_DATOS                       TYPE        TABLE(optional)
* +--------------------------------------------------------------------------------------</SIGNATURE>
method mostrar.

* prepara el estilo de las celdas
   me->cargar_estilo( ).

* Crea el contenedor, ALV y los inicializa
  if lr_container is initial.

    create object lr_container
      exporting
        container_name              = lv_container
      exceptions
        cntl_error                  = 1
        cntl_system_error           = 2
        create_error                = 3
        lifetime_error              = 4
        lifetime_dynpro_dynpro_link = 5
        others                      = 6.

*   Crea el objeto ALV
    me->crear_alv( ).

*   Prepara el catálogo
    me->cargar_catalogo( ).

*   Prepara el layout
    me->cargar_layout( ).

*   Prepara los botones
    me->cargar_botones( ).

*   Carga los colores
    me->cargar_formato( ).

*   Prepara los filtros
    me->cargar_filtro( ).

    if is_variant is supplied.

      call method lr_alvgrid->set_table_for_first_display
        exporting
          is_layout                     = ls_layout
          i_default                     = space
          i_save                        = 'A'
          is_variant                    = is_variant
          it_toolbar_excluding          = lt_botones[]
        changing
          it_outtab                     = it_datos[]
          it_fieldcatalog               = lt_catalogo[]
          it_sort                       = lt_filtro[]
        exceptions
          invalid_parameter_combination = 1
          program_error                 = 2
          too_many_lines                = 3
          others                        = 4.

    else.

      call method lr_alvgrid->set_table_for_first_display
        exporting
          is_layout                     = ls_layout
          it_toolbar_excluding          = lt_botones[]
        changing
          it_outtab                     = it_datos[]
          it_fieldcatalog               = lt_catalogo[]
          it_sort                       = lt_filtro[]
        exceptions
          invalid_parameter_combination = 1
          program_error                 = 2
          too_many_lines                = 3
          others                        = 4.

    endif.

*   Establece los manejadores
    me->asignar_manejadores( ).

  elseif lv_error is initial.

**   Prepara el catálogo
*    me->cargar_catalogo( ).

*   Prepara el layout
    me->cargar_layout( ).

*   Prepara los botones
    me->cargar_botones( ).

*   Carga los colores
    me->cargar_formato( ).

    call method lr_alvgrid->set_frontend_layout
      exporting
        is_layout = ls_layout.

    if is_estable is supplied.
      call method lr_alvgrid->refresh_table_display
        exporting
          is_stable = is_estable
        exceptions
          finished  = 1
          others    = 2.
    else.
      call method lr_alvgrid->refresh_table_display
        exceptions
          finished = 1
          others   = 2.
    endif.

  endif.

* Establece el modo de trabajo

  if me->lv_modo = zcl_util_alv=>modo_e.

    call method lr_alvgrid->set_ready_for_input
      exporting
        i_ready_for_input = 1.

  else.

    call method lr_alvgrid->set_ready_for_input
      exporting
        i_ready_for_input = 0.

  endif.

* Establece ayudas búsqueda
  me->cargar_ayudas( ).
endmethod.


* <SIGNATURE>---------------------------------------------------------------------------------------+
* | Instance Public Method ZCL_UTIL_ALV->OBTENER_DATOS
* +-------------------------------------------------------------------------------------------------+
* | [<---] ET_DATOS                       TYPE        TABLE
* +--------------------------------------------------------------------------------------</SIGNATURE>
method obtener_datos.
endmethod.


* <SIGNATURE>---------------------------------------------------------------------------------------+
* | Instance Public Method ZCL_UTIL_ALV->OBTENER_MODO
* +-------------------------------------------------------------------------------------------------+
* | [<-()] EV_MODO                        TYPE        XFELD
* +--------------------------------------------------------------------------------------</SIGNATURE>
method obtener_modo.
    ev_modo = lv_modo.
endmethod.


* <SIGNATURE>---------------------------------------------------------------------------------------+
* | Instance Public Method ZCL_UTIL_ALV->RESETEAR
* +-------------------------------------------------------------------------------------------------+
* +--------------------------------------------------------------------------------------</SIGNATURE>
method resetear.

* Por defecto modo visualización
  lv_modo = zcl_util_alv=>modo_v.

endmethod.
endclass.
