; =========================================================================================== ;
; Image_button - ikona sortowania / Image_button - sort icon                                  ;
;  Key   [STR] - nazwa wycinka / name of control                                              ;
;  Mode  [INT] - kierunek sortowania / sort direction                                         ;
;                0 = rosnaco / ascending                                                      ;
;                1 = malejaco / descending                                                    ;
;  Col   [INT] - kolor wypelnienia / fill color                                               ;
; ------------------------------------------------------------------------------------------- ;
; (cd:DCL_ImgBtnSortIcon "image" 0 15)                                                        ;
; =========================================================================================== ;
(defun cd:DCL_ImgBtnSortIcon (Key Mode Col / x y c n d l)
  (setq x (dimx_tile Key)
        y (dimy_tile Key)
        c (if (not Col) 252 Col)
        n (/ x 2)
        d (if (zerop Mode) (- (/ y 2) 2) (+ (/ y 2) 2))
        l '(0 1 2 3 4 5)
  )
  (start_image Key)
  (fill_image 2 2 (- x 2) (- y 2) -15)
  (mapcar
    (function
      (lambda (% / %1 %2)
        (setq %1 (nth % (reverse l))
              %2 (if (zerop Mode) (+ d %1) (- d %1))
        )
        (vector_image (- n %) %2 (+ n %) %2 c)
      )
    )
    l
  )
  (end_image)
)