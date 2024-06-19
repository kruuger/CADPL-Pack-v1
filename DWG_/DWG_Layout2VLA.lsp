; =========================================================================================== ;
; Zmiana nazwy arkusza na obiekt VLA / Convert layout name to VLA-Object                      ;
;  Layout [STR] - nazwa arkusza / layout tab name                                             ;
; ------------------------------------------------------------------------------------------- ;
; (cd:DWG_Layout2VLA (getvar "CTAB"))                                                         ;
; =========================================================================================== ;
(defun cd:DWG_Layout2VLA (Layout / res)
  (and
    (member Layout (layoutlist))
    (setq res (vla-item
                (cd:ACX_Layouts)
                Layout
              )
    )
  )
  res
)