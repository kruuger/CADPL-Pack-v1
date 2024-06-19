; =========================================================================================== ;
; Tworzy obiekt typu TEXT / Creates a TEXT object                                             ;
;  Space  [VLA-Object] - kolekcja / collection | Model/Paper + Block Object                   ;
;  Str    [STR]  - lancuch tekstowy / string                                                  ;
;  Pb     [LIST] - punkt bazowy / base point                                                  ;
;  Height [REAL] - wysokosc / height                                                          ;
;  Rot    [REAL] - kat obrotu w radianach / rotation angle in radians                         ;
; ------------------------------------------------------------------------------------------- ;
; (cd:ACX_AddText (cd:ACX_ASpace) "NEW_TEXT" (getpoint) 1.5 (/ pi 4))                         ;
; =========================================================================================== ;
(defun cd:ACX_AddText (Space Str Pb Height Rot / zdir xang obj)
  (setq zdir (trans '(0 0 1) 1 0 T)
        xang (angle '(0 0 0) (trans (getvar "UCSXDIR") 0 zdir))
  )
  (vla-put-rotation
    (setq obj (vla-AddText Space
                           Str
                           (vlax-3d-point (trans Pb 1 0))
                           Height
              )
    )
    (+ Rot xang)
  )
  obj
)