; =========================================================================================== ;
; Tworzy obiekt typu TEXT / Creates a TEXT object                                             ;
;  Layout [STR]  - nazwa arkusza / layout tab name                                            ;
;  Str    [STR]  - lancuch tekstowy / string                                                  ;
;  Pb     [LIST] - punkt bazowy / base point                                                  ;
;  Height [REAL] - wysokosc / height                                                          ;
;  Rot    [REAL] - kat obrotu w radianach / rotation angle in radians                         ;
; ------------------------------------------------------------------------------------------- ;
; (cd:ENT_MakeText "Model" "NEW_TEXT" '(20 10 0) 1.5 (/ pi 4))                                ;
; =========================================================================================== ;
(defun cd:ENT_MakeText (Layout Str Pb Height Rot / zdir xang)
  (setq zdir (trans '(0 0 1) 1 0 T)
        xang (angle '(0 0 0) (trans (getvar "UCSXDIR") 0 zdir))
  )
  (entmakex
    (list
      (cons 0 "TEXT")
      (cons 1 Str)
      (cons 10 (trans Pb 1 zdir))
      (cons 40 Height)
      (cons 50 (+ Rot xang))
      (cons 210 zdir)
      (cons 410 Layout)
    )
  )
)