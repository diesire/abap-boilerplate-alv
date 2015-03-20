*  {{columnCatalog.element | uppercase}}
   clear ls_fieldcat.
   ls_fieldcat-fieldname   = gcl_alv=>lc_col_{{columnCatalog.element}}.
   ls_fieldcat-ref_table   = gcl_alv=>lc_ref_table.
   append ls_fieldcat to me->lt_catalogo.
   