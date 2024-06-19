; =========================================================================================== ;
; Obsluga listy kolorow / Handling of list colors                                             ;
;  KeyLst [STR]  - nazwa wycinka "popup_list" / "popup_list" tile name                        ;
;  KeyImg [STR]  - nazwa wycinka "image" / "image" tile name                                  ;
;  Lst    [LIST] - lista kolorow / list of colors                                             ;
;  Col    [STR]  - aktualny kolor / current color                                             ;
;  Old    [STR]  - poprzedni kolor / old kolor                                                ;
; =========================================================================================== ;
(defun cd:DCL_ChangeColorList (KeyLst KeyImg Lst Col Old / res cdlg tmp)
  (setq tmp Old)
  (cond
    ((= Col "0") (setq res "256"))
    ((= Col "1") (setq res "0"))
    ((= Col "9")
     (if (setq cdlg (acad_colordlg (atoi tmp)))
       (setq res (itoa cdlg)
             tmp (itoa cdlg)
       )
       (setq res tmp)
     )
    )
    ((= Col "10") (setq res tmp))
    (T (setq res (itoa (1- (atoi Col)))))
  )
  (cd:DCL_FillColorList KeyLst Lst res)
  (cd:DCL_FillColorImage KeyImg (atoi res))
  res
)