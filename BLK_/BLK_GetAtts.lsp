; =========================================================================================== ;
; Pobiera wartosci wszystkich atrybutow / Gets the values of all attributes                   ;
;  Ename [ENAME] - nazwa entycji / entity name                                                ;
; ------------------------------------------------------------------------------------------- ;
; (cd:BLK_GetAtts (car (entsel)))                                                             ;
; =========================================================================================== ;
(defun cd:BLK_GetAtts (Ename)
  (mapcar
    (function
      (lambda (% / dt)
        (setq dt (entget %))
        (cons
          (cdr (assoc 2 dt))
          (cdr (assoc 1 dt))
        )
      )
    )
    (cd:BLK_GetAttEntity Ename)
  )
)