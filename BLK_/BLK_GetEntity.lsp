; =========================================================================================== ;
; Lista obiektow w definicji bloku / List of objects in block definition                      ;
;  Name   [STR] - nazwa bloku / block name                                                    ;
;  Entity [STR] - nazwa entycji / entity name                                                 ;
; ------------------------------------------------------------------------------------------- ;
; (cd:BLK_GetEntity "*Model_space" nil), (cd:BLK_GetEntity "NAZWA" "*LINE")                   ;
; =========================================================================================== ;
(defun cd:BLK_GetEntity (Name Entity / en dt res)
  (setq en (tblobjname "BLOCK" Name))
  (while
    (and
      en
      (setq en (entnext en))
      (setq dt (entget en))
      (/= "ENDBLK" (cdr (assoc 0 dt)))
    )
    (if
      (if Entity
        (wcmatch (cdr (assoc 0 dt)) (strcase Entity))
        (cdr (assoc 0 dt))
      )
      (setq res (cons
                  (cdr (assoc -1 dt))
                  res
                )
      )
    )
  )
  (reverse res)
)