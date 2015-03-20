class gcl_app definition.
  public section.
    data:
      gt_data type {{types.table}}.
    methods:
      constructor
        importing
          iv_dynpro type char4
          iv_container type scrfname,
      get_data
        exporting
          et_data type {{types.table}},
      show.
  private section.
    data:
      gr_context type ref to zcl_util_ctx,
      gr_alv type ref to gcl_alv,
      gv_dynpro type char4.
endclass.

class gcl_app implementation.
  method constructor.
    create object gr_context
      exporting
        iv_tcode = sy-tcode
        iv_modo  = zcl_util_ctx=>modo_v.

    gv_dynpro = iv_dynpro.

    create object gr_alv
      exporting
        iv_container = iv_container.
  endmethod.
  
  method get_data.
{{dataInput.gen}}
  endmethod.

  method show.
    if me->gt_data[] is initial.
      message s025(zmm).
    else.
      gr_alv->asignar_datos( me->gt_data ).
      gr_alv->mostrar( ).
      call screen gv_dynpro.
    endif.
  endmethod.
endclass.