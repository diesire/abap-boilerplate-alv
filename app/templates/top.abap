constants:
  gc_dynpro_9000 type char4 value '9000',
  gc_cc_log type scrfname value 'CC_LOG'.

class:
  gcl_alv definition deferred,
  gcl_event_handler definition deferred,
  gcl_app definition deferred.

data:
  go_app type ref to gcl_app, "Tipo documento
  gv_okcode type sy-ucomm.
