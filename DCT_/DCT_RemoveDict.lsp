; =========================================================================================== ;
; Usuwa slownik / Removes the dictionary                                                      ;
;  Root [ENAME/nil] - ENAME = slownik "rodzic" / "parent" dictionary                          ;
;                     nil   = (namedobjdict) jako "rodzic" / (namedobjdict) as "parent"       ;
;  Name [STR]       - nazwa slownika / name of the dictionary                                 ;
; ------------------------------------------------------------------------------------------- ;
; (cd:DCT_RemoveDict (namedobjdict) "NAZWA")                                                  ;
; =========================================================================================== ;
(defun cd:DCT_RemoveDict (Root Name)
  (dictremove (if (not Root) (namedobjdict) Root) Name)
)