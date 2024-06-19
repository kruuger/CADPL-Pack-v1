; =========================================================================================== ;
; Dodaje wlasciwosci uzytkownika / Add custom drawing properties                              ;
;  Doc   [VLA-Object] - document / document                                                   ;
;  Name  [STR]   - nazwa / name                                                               ;
;  Value [STR]   - wartosc / value                                                            ;
;  Mode  [T/nil] - nil = nieaktualizuje istniejacej nazwy / do not updates exisitng name      ;
;                  T   = aktualizuje istniejaca nazwe / updates exisitng name                 ;
; ------------------------------------------------------------------------------------------- ;
; (cd:DWG_AddCustomProp (cd:ACX_ADoc) "One" "1" nil)                                          ;
; =========================================================================================== ;
(defun cd:DWG_AddCustomProp (Doc Name Value Mode / si)
  (setq si (vla-get-SummaryInfo Doc))
  (if (member Name (mapcar (quote car) (cd:DWG_GetCustomProp Doc)))
    (if Mode (vla-SetCustomByKey si Name Value))
    (vla-AddCustomInfo si Name Value)
  )
)