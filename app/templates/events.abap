*----------------------------------------------------------------------*
* EVENTS                                                               *
*----------------------------------------------------------------------*

* Initialization
*---------------
initialization.
  create object go_app
    exporting
      iv_dynpro    = gc_dynpro_9000
      iv_container = gc_cc_log.
      

* Start of selection
*-------------------
start-of-selection.
  go_app->get_data(
    importing
      et_data  = go_app->gt_data ).

  go_app->show( ).
  