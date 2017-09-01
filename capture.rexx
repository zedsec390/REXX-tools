/*REXX capture*/
/* Executes a TSO Command and captures the (normally) displayed
   output in a file named 'userid.CAPTURE.CMD.TEMP'
   To Use:
   Execute the program,
      for example: %Capture
               or: TSO EXEC 'yourid.name-of-file-containing-this'
   Then type in a TSO command that displays output,
      for example: LISTCAT LEVEL(yourid)
                   STOP, QUIT, or just hitting ENTER will terminate at once
   Then examine the file 'userid.CAPTURE.CMD.TEMP' to see what the command did

	Big thanks to KF for this script - you are the REXX master.
*/
ARG COMMAND DATASET_NAME
SIGNAL ON ERROR
IF DATASET_NAME = ""
THEN DATASET_NAME = "CAPTURE.CMD.TEMP"
IF SYSDSN(DATASET_NAME) = "OK"
THEN "ALLOCATE DSN(" DATASET_NAME ") DDN(CAPTURE) SHR REUSE"
ELSE "ALLOCATE DSN(" DATASET_NAME ") DDN(CAPTURE) NEW REUSE",
     " SPACE(1 1) TRACKS RELEASE"
DUMMY = OUTTRAP("LINE.","*")
IF COMMAND = ""
THEN
   DO
     SAY "PLEASE ENTER A COMMAND TO BE EXECUTED"
     PULL COMMAND
     IF COMMAND = "" THEN EXIT
     IF COMMAND = "QUIT" THEN EXIT
     IF COMMAND = "STOP" THEN EXIT
   END
COMMAND
DUMMY = OUTTRAP("OFF")
"EXECIO " LINE.0 " DISKW CAPTURE (STEM LINE. FINIS)"
"FREE DDN(CAPTURE)"
EXIT
ERROR:
SAY "COMMAND " COMMAND " CANNOT BE EXECUTED SUCCESSFULLY"
SAY "PRESS ENTER TO CONTINUE "
PULL .
"DELETE " DATASET_NAME
EXIT
