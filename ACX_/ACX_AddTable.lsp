; =========================================================================================== ;
; Tworzy obiekt typu ACAD_TABLE / Creates a ACAD_TABLE object                                 ;
;  Space [VLA-Object]  - kolekcja / collection | Model/Paper + Block Object                   ;
;  Pb    [LIST] - punkt bazowy tabeli / table base point                                      ;
;  Rows  [INT]  - liczba wierszy / number of rows                                             ;
;  Cols  [INT]  - liczba kolumn / number of columns                                           ;
;  RowH  [INT]  - wysokosc wierszy / rows height                                              ;
;  ColH  [INT]  - szerokosc kolumn / columns height                                           ;
; ------------------------------------------------------------------------------------------- ;
; (cd:ACX_AddTable (cd:ACX_ASpace) (getpoint) 5 5 10 30)                                      ;
; =========================================================================================== ;
(defun cd:ACX_AddTable (Space Pb Rows Cols RowH ColH)
  (vla-AddTable
    Space
    (vlax-3d-point (trans Pb 1 0))
    Rows
    Cols
    RowH
    ColH
  )
)