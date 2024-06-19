; =========================================================================================== ;
; Zwraca liste blokow dynamicznych / Returns a list of dynamic blocks                         ;
; =========================================================================================== ;
(defun cd:BLK_GetDynBlockList ()
  (mapcar (quote cdadr)
          (vl-remove nil
                     (mapcar
                       (quote
                         (lambda (%)
                           (cd:XDT_GetXData
                             (cdr (assoc 330 (entget (tblobjname "Block" %))))
                             "AcDbDynamicBlockTrueName*"
                           )
                         )
                       )
                       (cd:SYS_CollList "BLOCK" (+ 1 2 4 8))
                     )
          )
  )
)