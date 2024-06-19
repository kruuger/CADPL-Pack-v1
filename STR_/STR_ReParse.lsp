; =========================================================================================== ;
; Laczy liste lancuchow w lancuch z separatorem /                                             ;
; Combines a list of strings in the string with the separator                                 ;
;  Lst [LIST] - lista lancuchow / list of strings                                             ;
;  Sep [STR]  - separator / separator                                                         ;
; ------------------------------------------------------------------------------------------- ;
; (cd:STR_ReParse '("OLE2FRAME" "IMAGE" "HATCH") ",")                                         ;
; =========================================================================================== ;
(defun cd:STR_ReParse (Lst Sep / res)
  (setq res (car Lst))
  (foreach % (cdr Lst)
    (setq res (strcat res Sep %))
  )
  res
)