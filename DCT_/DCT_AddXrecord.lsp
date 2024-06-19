; =========================================================================================== ;
; Dodaje Xrecord / Adds the Xrecord                                                           ;
;  Root  [ENAME/nil] - ENAME = slownik "rodzic" / "parent" dictionary                         ;
;                      nil   = (namedobjdict) jako "rodzic" / (namedobjdict) as "parent"      ;
;  XName [STR]       - nazwa xrecord / xrecord name                                           ;
;  XData [LIST]      - dane xrecord / xrecord data                                            ;
; ------------------------------------------------------------------------------------------- ;
; (cd:DCT_AddXrecord (cd:DCT_GetDict (namedobjdict) "NAZWA") "NAZWA-SUB1" '((1 . "ABC")))     ;
; =========================================================================================== ;
(defun cd:DCT_AddXrecord (Root XName XData)
  (dictadd (if (not Root) (namedobjdict) Root)
           XName
           (entmakex (append '((0 . "XRECORD") (100 . "AcDbXrecord")) XData))
  )
)