; =========================================================================================== ;
; Usuwa wlasciwosci uzytkownika / Removes custom drawing properties                           ;
;  Doc  [VLA-Object] - document / document                                                    ;
;  Mode [LIST/T] - LIST = lista wlasciwosci do usuniecia / list of properties to remove       ;
;                  T    = usuwa wszystkie wlasciwosci / removes all properites                ;
; ------------------------------------------------------------------------------------------- ;
; (cd:DWG_RemoveCustomProp (cd:ACX_ADoc) (list "One" "Two"))                                  ;
; =========================================================================================== ;
(defun cd:DWG_RemoveCustomProp (Doc Mode / si)
  (setq si (vla-get-SummaryInfo Doc))
  (if (listp Mode)
    (foreach % Mode
      (vl-catch-all-apply
        (quote vla-RemoveCustomByKey)
        (list si %)
      )
    )
    (foreach % (mapcar (quote car) (cd:DWG_GetCustomProp Doc))
      (vla-RemoveCustomByKey si %)
    )
  )
)