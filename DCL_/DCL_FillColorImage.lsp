; =========================================================================================== ;
; Wypelnia wycinek "image" kolorem / Fills "image" tile with color                            ;
;  Key [STR] - nazwa wycinka / tile name                                                      ;
;  Col [INT] - kolor / color                                                                  ;
; =========================================================================================== ;
(defun cd:DCL_FillColorImage (Key Col / X Y)
  (start_image Key)
  (fill_image 0 0 (dimx_tile Key) (dimy_tile Key) Col)
  (end_image)
)