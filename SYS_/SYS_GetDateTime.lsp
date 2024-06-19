; =========================================================================================== ;
; Zwraca date/czas systemowa(y) / Return system date/time                                     ;
;  Format [STR] -                                                                             ;
;   ----- Data / Date -----    |   ---- Czas / Time ----                                      ;
;   D       ->   5             |   H       ->   4                                             ;
;   DD      ->   05            |   HH      ->   04                                            ;
;   DDD     ->   Sat           |   MM      ->   53                                            ;
;   DDDD    ->   Saturday      |   SS      ->   17                                            ;
;   M       ->   9             |   MSEC    ->   506                                           ;
;   MO      ->   09            |   AM/PM   ->   AM or PM                                      ;
;   MON     ->   Sep           |   am/pm   ->   am or pm                                      ;
;   MONTH   ->   September     |   A/P     ->   A  or P                                       ;
;   YY      ->   89            |   a/p     ->   a  or p                                       ;
;   YYYY    ->   1989          |                                                              ;
; ------------------------------------------------------------------------------------------- ;
; (cd:SYS_GetDateTime "DDD\",\" DD MON YYYY - H:MMam/pm")                                     ;
; =========================================================================================== ;
(defun cd:SYS_GetDateTime (Format)
  (menucmd (strcat "m=$(edtime,$(getvar,DATE)," Format ")"))
)