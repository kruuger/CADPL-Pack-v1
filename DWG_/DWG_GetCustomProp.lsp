; =========================================================================================== ;
; Lista wlasciwosci uzytkownika / Custom drawing properties                                   ;
;  Doc [VLA-Object] - document / document                                                     ;
; ------------------------------------------------------------------------------------------- ;
; (cd:DWG_GetCustomProp (cd:ACX_ADoc))                                                        ;
; =========================================================================================== ;
(defun cd:DWG_GetCustomProp (Doc / si n k v lst)
  (setq si (vla-get-SummaryInfo Doc)
        n  (vla-NumCustomInfo si)
  )
  (while (> n 0)
    (vla-GetCustomByIndex si (- n 1) 'k 'v)
    (setq lst (cons (cons k v) lst)
          n   (1- n)
    )
  )
  lst
)