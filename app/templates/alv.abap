*----------------------------------------------------------------------*
*       CLASS gcl_alv DEFINITION
*----------------------------------------------------------------------*
*  Listado de pedidos rechazados.
*    * Admite variantes de layout
*----------------------------------------------------------------------*
class gcl_alv definition inheriting from zcl_util_alv
  friends gcl_event_handler.
  public section.
    constants:
      lc_ref_table type lvc_s_fcat-ref_table value '{{types.line}}',
{{columnConstants.gen}}
    methods:
      constructor importing iv_container type scrfname,
      resetear redefinition,
      asignar_datos redefinition,
      obtener_datos redefinition,
      mostrar redefinition.

  protected section.
    methods:
      cargar_catalogo redefinition,
      cargar_layout redefinition,
      cargar_filtro redefinition,
      cargar_botones redefinition,
      asignar_manejadores redefinition.

  private section.
    data:
      lr_event_handler type ref to gcl_event_handler,
      lt_data type {{types.table}}.
endclass.


*----------------------------------------------------------------------*
*       CLASS gcl_event_handler DEFINITION
*----------------------------------------------------------------------*
*  Añade soporte para doble-click en el ALV
*----------------------------------------------------------------------*
class gcl_event_handler definition.
  public section.
    methods:
      constructor
        importing
          ir_alv type ref to gcl_alv,

      handle_double_click
        for event double_click of cl_gui_alv_grid
        importing
          e_row
          e_column.

  private section.
    data:
      lr_alv type ref to gcl_alv.
endclass.                    "gcl_event_handler DEFINITION


*----------------------------------------------------------------------*
*       CLASS gcl_alv IMPLEMENTATION
*----------------------------------------------------------------------*
*
*----------------------------------------------------------------------*
class gcl_alv implementation.
  method constructor.
    super->constructor( iv_container = iv_container ).
    create object lr_event_handler
      exporting
        ir_alv = me.
  endmethod.                    "constructor

  method resetear.
    super->resetear( ).
    refresh lt_data.
  endmethod.                    "resetear

  method asignar_datos.
    lt_data[] = it_datos[].
  endmethod.                    "asignar_datos

  method obtener_datos.
    et_datos[] = lt_data[].
  endmethod.                    "obtener_datos

  method cargar_botones.
    "vacio para que no use los del padre
  endmethod.                    "cargar_botones

  method asignar_manejadores.
    set handler lr_event_handler->handle_double_click for lr_alvgrid .
  endmethod.                    "ASIGNAR_MANEJADORES

  method mostrar.
    data:
      ls_variant type  disvariant.

*   Variantes layout
    ls_variant-report    = sy-repid.
    ls_variant-username  = sy-uname.

    sort lt_data ascending by type.

    super->mostrar(
      exporting
        is_variant = ls_variant
      changing
        it_datos = lt_data[] ).
  endmethod.                    "mostrar
  
  method cargar_catalogo.

    data:
      ls_fieldcat type lvc_s_fcat.

*   Refresh catalog
    refresh me->lt_catalogo.

{{columnCatalog.gen}}
  endmethod.                    "cargar_catalogo

  method cargar_layout.
    me->ls_layout-sel_mode   = 'A'.
    me->ls_layout-stylefname = 'STYLE'.
*    me->ls_layout-ctab_fname = 'COLOR'.
    me->ls_layout-col_opt = abap_true.

    me->ls_layout-zebra      = abap_true.
  endmethod.                    "cargar_layout

  method cargar_filtro.
    data:
      ls_sort type lvc_s_sort .

    ls_sort-spos = '1'.
    ls_sort-fieldname = gcl_alv=>lc_col_type.
    ls_sort-up = abap_true. "A to Z
    ls_sort-down = abap_false.
    append ls_sort to me->lt_filtro.
  endmethod.                    "cargar_filtro
endclass.


*----------------------------------------------------------------------*
*       CLASS gcl_event_handler IMPLEMENTATION
*----------------------------------------------------------------------*
*
*----------------------------------------------------------------------*
class gcl_event_handler implementation.
  method constructor.
    me->lr_alv = ir_alv.
  endmethod.                    "constructor

  method handle_double_click.
    constants:
      lc_param_DTYP type char20 value 'DTYP',
      lc_trx_se11 type char20 value 'SE11'.

    data:
      ls_selected type {{types.line}}.

*   Recupera el ID de pedido
    if e_column-fieldname = gcl_alv=>lc_col_message.
      read table  me->lr_alv->lt_data
        into ls_selected
        index e_row-index.

      if not sy-subrc is initial.
        message e026(zmm).
      endif.

*     Fija parámetros y lanza la transacción
*     set parameter id lc_param_DTYP field '{{types.table}}'.
      call transaction lc_trx_se11.
    endif.
  endmethod.                    "handle_double_click
endclass.                    "gcl_event_handler IMPLEMENTATION