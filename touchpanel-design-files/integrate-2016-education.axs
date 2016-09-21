PROGRAM_NAME='education'
(***********************************************************)
(*  FILE CREATED ON: 08/23/2016  AT: 08:44:34              *)
(***********************************************************)
(***********************************************************)
(***********************************************************)
(*  FILE_LAST_MODIFIED_ON: 09/21/2016  AT: 20:23:49        *)
(***********************************************************)
(* System Type : NetLinx                                   *)
(***********************************************************)
(* REV HISTORY:                                            *)
(***********************************************************)
(*
    $History: $
*)
(***********************************************************)
(*          DEVICE NUMBER DEFINITIONS GO BELOW             *)
(***********************************************************)
DEFINE_DEVICE

dvMaster													=  0:1:0;

dvTP_1														= 10001:1:0;

(***********************************************************)
(*               CONSTANT DEFINITIONS GO BELOW             *)
(***********************************************************)
DEFINE_CONSTANT

(***********************************************************)
(*              DATA TYPE DEFINITIONS GO BELOW             *)
(***********************************************************)
DEFINE_TYPE

(***********************************************************)
(*               VARIABLE DEFINITIONS GO BELOW             *)
(***********************************************************)
DEFINE_VARIABLE

(***********************************************************)
(*               LATCHING DEFINITIONS GO BELOW             *)
(***********************************************************)
DEFINE_LATCHING

(***********************************************************)
(*       MUTUALLY EXCLUSIVE DEFINITIONS GO BELOW           *)
(***********************************************************)
DEFINE_MUTUALLY_EXCLUSIVE

(***********************************************************)
(*        SUBROUTINE/FUNCTION DEFINITIONS GO BELOW         *)
(***********************************************************)
(* EXAMPLE: DEFINE_FUNCTION <RETURN_TYPE> <NAME> (<PARAMETERS>) *)
(* EXAMPLE: DEFINE_CALL '<NAME>' (<PARAMETERS>) *)

(***********************************************************)
(*                STARTUP CODE GOES BELOW                  *)
(***********************************************************)
DEFINE_START

(***********************************************************)
(*                THE EVENTS GO BELOW                      *)
(***********************************************************)
DEFINE_EVENT

// Custom Event [10101:1:101]-ID=1 Type=700 Flag=0 Value1=2 Value2=0 Value3=7 Text: 04B0FE3A853280
custom_event[dvTP_1, 1, 700] {
    local_var volatile long timer;
    local_var volatile char last_tag[255];

    stack_var volatile char organiser[255];

    if ((timer >= get_timer - 20) && (last_tag == custom.text)) {
		if (AMX_DEBUG <= get_log_level()) amx_log(AMX_DEBUG, "'Ignoring repeated NFC tag read'");
    } else {
		switch (custom.text) {
			case '04C2433A853280': organiser = 'Professor';
			case '04A4073A853284': organiser = 'Student';
		}

		if (AMX_DEBUG <= get_log_level()) amx_log(AMX_DEBUG, "'NFC tag read: ', custom.text, ' (', organiser, ')'");

		if (length_string(organiser)) {
			switch (organiser) {
				case 'Professor': {
					send_command custom.device, 'PAGE-welcome-professor';
				}
				case 'Student': {
					send_command custom.device, 'PAGE-welcome-student';
				}
			}
			wait 5 send_command custom.device, "'^SOU-nfc-tag-accepted.mp3'"; // delaying confirmation sound to ensure G5 does not play (and stop) during page flip
		} else {
			send_command custom.device, "'^SOU-nfc-tag-rejected.mp3'";
		}
    }

    timer = get_timer;
    last_tag = custom.text;
}

(*****************************************************************)
(*                                                               *)
(*                      !!!! WARNING !!!!                        *)
(*                                                               *)
(* Due to differences in the underlying architecture of the      *)
(* X-Series masters, changing variables in the DEFINE_PROGRAM    *)
(* section of code can negatively impact program performance.    *)
(*                                                               *)
(* See “Differences in DEFINE_PROGRAM Program Execution” section *)
(* of the NX-Series Controllers WebConsole & Programming Guide   *)
(* for additional and alternate coding methodologies.            *)
(*****************************************************************)

DEFINE_PROGRAM

(*****************************************************************)
(*                       END OF PROGRAM                          *)
(*                                                               *)
(*         !!!  DO NOT PUT ANY CODE BELOW THIS COMMENT  !!!      *)
(*                                                               *)
(*****************************************************************)


