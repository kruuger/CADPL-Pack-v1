; =========================================================================================== ;
; Tworzy obiekt typu ACAD_TABLE / Creates a ACAD_TABLE object                                 ;
;  Pb   [LIST] - punkt bazowy tabeli / table base point                                       ;
;  Rows [INT]  - liczba wierszy / number of rows                                              ;
;  Cols [INT]  - liczba kolumn / number of columns                                            ;
;  RowH [INT]  - wysokosc wierszy / rows height                                               ;
;  ColH [INT]  - szerokosc kolumn / columns height                                            ;
; ------------------------------------------------------------------------------------------- ;
; (cd:ENT_MakeTable (getpoint) 5 5 10 30)                                                     ;
; =========================================================================================== ;
(defun cd:ENT_MakeTable (Pb Rows Cols RowH ColH / r c)
  (entmakex
    (append
      (list
        (cons 0 "ACAD_TABLE")
        (cons 100 "AcDbEntity")
        (cons 100 "AcDbBlockReference")
        (cons 10 (trans Pb 1 0))
        (cons 100 "AcDbTable")
        (cons 91 Rows)
        (cons 92 Cols)
      )
      (repeat Rows (setq r (cons (cons 141 RowH) r)))
      (repeat Cols (setq c (cons (cons 142 ColH) c)))
    )
  )
)