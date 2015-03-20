class zcl_util_ctx definition
  .

*"* public components of class ZCL_UTIL_CTX
*"* do not include other source files here!!!
public section.

  constants modo_c type xfeld value 'C'. "#EC NOTEXT
  constants modo_e type xfeld value 'E'. "#EC NOTEXT
  constants modo_v type xfeld value 'V'. "#EC NOTEXT

  methods constructor
    importing
      !iv_tcode type sytcode
      !iv_modo type xfeld .
  methods obtener_tcode
    returning
      value(ev_tcode) type sytcode .
  methods asignar_tcode
    importing
      !iv_tcode type sytcode .
  methods obtener_modo
    returning
      value(ev_modo) type xfeld .
  methods asignar_modo
    importing
      !iv_modo type xfeld .
  methods authority_check
    raising
      zcx_util_error .
  methods asignar_indicador_error
    importing
      !iv_ref type ref to object .
  methods eliminar_indicador_error
    importing
      !iv_ref type ref to object .
  methods existe_error
    returning
      value(ev_result) type xfeld .
  methods resetear .
protected section.

  data lv_tcode type sytcode .
  data lv_modo type xfeld .
private section.
* Tipo estructura para indicador de error
  types: begin of lty_s_ref,
          rfobj type ref to object,
         end of lty_s_ref.

* Tipo tabla para indicadores de error
  types: lty_t_ref type table of lty_s_ref.
  data lt_inderr type lty_t_ref.
endclass.



class zcl_util_ctx implementation.


* <SIGNATURE>---------------------------------------------------------------------------------------+
* | Instance Public Method ZCL_UTIL_CTX->ASIGNAR_INDICADOR_ERROR
* +-------------------------------------------------------------------------------------------------+
* | [--->] IV_REF                         TYPE REF TO OBJECT
* +--------------------------------------------------------------------------------------</SIGNATURE>
method asignar_indicador_error.

* Estructura para añadir el indicador de error
  data: ls_ref type lty_s_ref.

* Asigna la referencia y la incluye
  ls_ref-rfobj = iv_ref.
  append ls_ref to lt_inderr.

endmethod.


* <SIGNATURE>---------------------------------------------------------------------------------------+
* | Instance Public Method ZCL_UTIL_CTX->ASIGNAR_MODO
* +-------------------------------------------------------------------------------------------------+
* | [--->] IV_MODO                        TYPE        XFELD
* +--------------------------------------------------------------------------------------</SIGNATURE>
method asignar_modo.

    lv_modo = iv_modo.

endmethod.


* <SIGNATURE>---------------------------------------------------------------------------------------+
* | Instance Public Method ZCL_UTIL_CTX->ASIGNAR_TCODE
* +-------------------------------------------------------------------------------------------------+
* | [--->] IV_TCODE                       TYPE        SYTCODE
* +--------------------------------------------------------------------------------------</SIGNATURE>
method asignar_tcode.

    lv_tcode = iv_tcode.

endmethod.


* <SIGNATURE>---------------------------------------------------------------------------------------+
* | Instance Public Method ZCL_UTIL_CTX->AUTHORITY_CHECK
* +-------------------------------------------------------------------------------------------------+
* | [!CX!] ZCX_UTIL_ERROR
* +--------------------------------------------------------------------------------------</SIGNATURE>
method authority_check.

* Chequeo por código de transacción
  authority-check
    object 'S_TCODE' id 'TCD' field lv_tcode.

  if not sy-subrc is initial.
    raise exception type zcx_util_error.
  endif.

endmethod.


* <SIGNATURE>---------------------------------------------------------------------------------------+
* | Instance Public Method ZCL_UTIL_CTX->CONSTRUCTOR
* +-------------------------------------------------------------------------------------------------+
* | [--->] IV_TCODE                       TYPE        SYTCODE
* | [--->] IV_MODO                        TYPE        XFELD
* +--------------------------------------------------------------------------------------</SIGNATURE>
method constructor.

  me->asignar_tcode( iv_tcode ).
  me->asignar_modo( iv_modo ).

endmethod.


* <SIGNATURE>---------------------------------------------------------------------------------------+
* | Instance Public Method ZCL_UTIL_CTX->ELIMINAR_INDICADOR_ERROR
* +-------------------------------------------------------------------------------------------------+
* | [--->] IV_REF                         TYPE REF TO OBJECT
* +--------------------------------------------------------------------------------------</SIGNATURE>
method eliminar_indicador_error.

* Borra los indicadores de error para la referencia indicada
  delete lt_inderr where rfobj = iv_ref.

endmethod.


* <SIGNATURE>---------------------------------------------------------------------------------------+
* | Instance Public Method ZCL_UTIL_CTX->EXISTE_ERROR
* +-------------------------------------------------------------------------------------------------+
* | [<-()] EV_RESULT                      TYPE        XFELD
* +--------------------------------------------------------------------------------------</SIGNATURE>
method existe_error.

  clear ev_result.
  if lt_inderr[] is not initial.
    ev_result = 'X'.
  endif.

endmethod.


* <SIGNATURE>---------------------------------------------------------------------------------------+
* | Instance Public Method ZCL_UTIL_CTX->OBTENER_MODO
* +-------------------------------------------------------------------------------------------------+
* | [<-()] EV_MODO                        TYPE        XFELD
* +--------------------------------------------------------------------------------------</SIGNATURE>
method obtener_modo.

  ev_modo = lv_modo.

endmethod.


* <SIGNATURE>---------------------------------------------------------------------------------------+
* | Instance Public Method ZCL_UTIL_CTX->OBTENER_TCODE
* +-------------------------------------------------------------------------------------------------+
* | [<-()] EV_TCODE                       TYPE        SYTCODE
* +--------------------------------------------------------------------------------------</SIGNATURE>
method obtener_tcode.

    ev_tcode = lv_tcode.

endmethod.


* <SIGNATURE>---------------------------------------------------------------------------------------+
* | Instance Public Method ZCL_UTIL_CTX->RESETEAR
* +-------------------------------------------------------------------------------------------------+
* +--------------------------------------------------------------------------------------</SIGNATURE>
method resetear.

* Elimina indicadores de error
  clear lt_inderr[].

endmethod.
endclass.
