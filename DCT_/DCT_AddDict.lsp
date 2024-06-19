; =========================================================================================== ;
; Dodaje slownik / Adds dictionary                                                            ;
;  Root [ENAME/nil] - ENAME = slownik "rodzic" / "parent" dictionary                          ;
;                     nil   = (namedobjdict) jako "rodzic" / (namedobjdict) as "parent"       ;
;  Name [STR]       - nazwa slownika / name of the dictionary                                 ;
; ------------------------------------------------------------------------------------------- ;
; (cd:DCT_AddDict (namedobjdict) "NAZWA")                                                     ;
; =========================================================================================== ;
(defun cd:DCT_AddDict (Root Name)
  (dictadd (if (not Root) (namedobjdict) Root)
           Name
           (entmakex (append '((0 . "DICTIONARY") (100 . "AcDbDictionary"))))
  )
)