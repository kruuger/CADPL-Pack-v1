; =========================================================================================== ;
; Macierz transformacji ukladu wspolrzednych / The coordinate transformation matrix           ;
; Credit: Doug C. Broad, Jr. (UCS2WCSMatrix + WCS2UCSMatrix)                                  ;
;  Cs [INT] - docelowy uklad wspolrzednych / target coordinate system                         ;
;             0 = GUW (Globalny Uklad Wspolrzednych) / WCS (World Coordinate System)          ;
;             1 = LUW (Lokalny Uklad Wspolrzednych) / UCS (User Coordinate System)            ;
; =========================================================================================== ;
; (cd:CON_TransMatrix 0)                                                                      ;
; =========================================================================================== ;
(defun cd:CON_TransMatrix (Cs)
  (vlax-tmatrix
    (append
      (mapcar
        (function
          (lambda (vector origin)
            (append
              (trans vector (abs (1- Cs)) Cs T)
              (list origin)
            )
          )
        )
        (list '(1 0 0) '(0 1 0) '(0 0 1))
        (trans '(0 0 0) Cs (abs (1- Cs)))
      )
      (list '(0 0 0 1))
    )
  )
)