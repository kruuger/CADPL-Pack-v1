; =========================================================================================== ;
; Usuwa kody z listy DXF / Removes codes from the list of DXF                                 ;
;  Data [LIST] - lista par kropkowych / list of dotted pairs                                  ;
;  Lst  [LIST] - lista kodow do usuniecia / list of codes to be removed                       ;
; ------------------------------------------------------------------------------------------- ;
; (cd:DXF_RemoveDXF (entget (entlast)) (list -1 3 5 102 330 360 440))                         ;
; =========================================================================================== ;
(defun cd:DXF_RemoveDXF (Data Lst)
  (vl-remove-if
    (function
      (lambda (%)
        (member (car %) Lst)
      )
    )
    Data
  )
)