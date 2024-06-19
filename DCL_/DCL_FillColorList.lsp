; =========================================================================================== ;
; Wypelnia wycinek "popup_list" lista kolorow / Fills "popup_list" tiles with list of colors  ;
;  Key [STR]  - nazwa wycinka / tile name                                                     ;
;  Lst [LIST] - lista kolorow / list of colors                                                ;
;  Col [STR]  - aktualny kolor / current color                                                ;
; =========================================================================================== ;
(defun cd:DCL_FillColorList (Key Lst Col)
  (cond
    ((= Col "256") (setq Col "0"))
    ((= Col "0") (setq Col "1"))
    (T (setq Col (itoa (1+ (atoi Col)))))
  )
  (if
    (and
      (> (atoi Col) 8)
      (<= (atoi Col) 256)
    )
    (setq Lst (append Lst (list (itoa (1- (atoi Col)))))
          Col "10"
    )
  )
  (cd:DCL_SetList Key Lst Col)
)