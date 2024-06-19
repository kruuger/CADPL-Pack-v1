; =========================================================================================== ;
; Pobiera slownik / Gets a dictionary                                                         ;
;  Root [ENAME/nil] - ENAME = slownik "rodzic" / "parent" dictionary                          ;
;                     nil   = (namedobjdict) jako "rodzic" / (namedobjdict) as "parent"       ;
;  Name [STR]       - nazwa slownika / name of the dictionary                                 ;
; ------------------------------------------------------------------------------------------- ;
; (cd:DCT_GetDict (namedobjdict) "NAZWA")                                                     ;
; =========================================================================================== ;
(defun cd:DCT_GetDict (Root Name)
  (cdr (assoc -1 (dictsearch (if (not Root) (namedobjdict) Root) Name)))
)