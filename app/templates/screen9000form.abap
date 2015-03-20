*&---------------------------------------------------------------------*
*&      Form  exit
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
form exit.
  set screen 0.
  leave screen.
endform.                    "exit

*&---------------------------------------------------------------------*
*&      Form  process_okcode_9000
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*      -->CV_OKCODE  text
*----------------------------------------------------------------------*
form process_okcode_9000 changing cv_okcode type sy-ucomm.
  data: lv_okcode like sy-ucomm.

  lv_okcode = cv_okcode.

  clear cv_okcode.
  clear sy-ucomm.

  case lv_okcode.
    when 'BACK' or 'EXIT' or 'CANCEL'. "failsafe
      perform exit.
  endcase.
endform.                    "process_okcode_9000
