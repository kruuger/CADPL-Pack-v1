; =========================================================================================== ;
; Tworzy obiekt typu VIEWPORT / Creates a VIEWPORT object                                     ;
;  Space  [VLA-Object] - kolekcja / collection | Model/Paper + Block Object                   ;
;  Pb     [LIST]       - punkt bazowy / base point                                            ;
;  Width  [REAL]       - szeroko�� rzutni / ViewPort width                                    ;
;  Height [REAL]       - wysoko�� rzutni / ViewPort height                                    ;
;  HJust  [INT]        - wyr�wnanie w poziomie / horizontal justification                     ;
;                        1 - Lewo / Left; 2 - �rodek / Center; 3 - Prawo / Right              ;
;  VJust  [INT]        - wyr�wnanie w pionie / vertical justification                         ;
;                        1 - G�ra / Top; 2 - �rodek / Middle; 3 - D� / Bottom                ;
; ------------------------------------------------------------------------------------------- ;
; (cd:ACX_AddViewport (cd:ACX_Paper) (getpoint) 100 200 3 2)                                  ;
; =========================================================================================== ;
(defun cd:ACX_AddViewport (Space Pb Width Height HJust VJust / obj)
  (setq Pb (trans Pb 1 0))
  (cond 
    ( (= HJust 1) (setq Pb (list (+ (car Pb) (/ Width 2)) (cadr Pb) (caddr Pb))) )
    ( (= HJust 3) (setq Pb (list (- (car Pb) (/ Width 2)) (cadr Pb) (caddr Pb))) )
  )
  (cond 
    ( (= VJust 1) (setq Pb (list (car Pb) (- (cadr Pb) (/ Height 2)) (caddr Pb))) )
    ( (= VJust 3) (setq Pb (list (car Pb) (+ (cadr Pb) (/ Height 2)) (caddr Pb))) )
  )
  (vla-Display  
    (setq obj
      (vla-AddPViewport
        Space
        (vlax-3d-point Pb)
        Width
        Height
      )
    )
    :vlax-true
  )
   obj
)