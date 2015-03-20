* Create Dynpro '9000'. Paste this code into 'Logic process' tab
* Add assign 'gv_okcode' to Dynpro 9000 OK_CODE
* Create a Custom Container called 'CC_LOG'
* Create an Empty Status GUI called 'ST9000'
* Add function codes 'BACK', 'EXIT' and 'CANCEL', all type 'E'
* to corresponding toolbar icons

process before output.
  module set_title_9000.
  module set_status_9000.

process after input.
  module user_command_9000.
  module exit_command_9000 at exit-command.
  