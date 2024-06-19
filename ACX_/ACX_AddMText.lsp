; =========================================================================================== ;
; Tworzy obiekt typu MTEXT / Creates a MTEXT object                                           ;
;  Space [VLA-Object] - kolekcja / collection | Model/Paper + Block Object                    ;
;  Str   [STR]  - lancuch tekstowy / string                                                   ;
;  Pb    [LIST] - punkt bazowy / base point                                                   ;
;  Width [REAL] - szerokosc tekstu / width text                                               ;
;  Rot   [REAL] - kat obrotu w radianach / rotation angle in radians                          ;
; ------------------------------------------------------------------------------------------- ;
; (cd:ACX_AddMText (cd:ACX_ASpace) "NEW_MTEXT" (getpoint) 1.5 (/ pi 4))                       ;
; =========================================================================================== ;
(defun cd:ACX_AddMText (Space Str Pb Width Rot / obj)
  (vla-put-rotation
    (setq obj (vla-AddMText Space
                            (vlax-3d-point (trans Pb 1 0))
                            Width
                            Str
              )
    )
    Rot
  )
  obj
)