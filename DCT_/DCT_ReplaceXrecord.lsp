; =========================================================================================== ;
; Podmienia Xrecord / Replace Xrecord                                                         ;
;  Ename [ENAME] - nazwa entycji xrecord / entity name xrecord                                ;
;  Data  [LIST]  - lista par kropkowych / list of dotted pairs                                ;
; ------------------------------------------------------------------------------------------- ;
; (cd:DCT_ReplaceXrecord                                                                      ;
;   (cdar (cd:DCT_GetDictList (cd:DCT_GetDict (namedobjdict) "NAZWA") T))                     ;
;   (list (cons 1 "NEW") (cons 341 (car (entsel)))))                                          ;
; =========================================================================================== ;
(defun cd:DCT_ReplaceXrecord (Ename Data / en root name)
  (setq root (cdr (assoc 330 (entget Ename)))
        name (cdr
               (assoc
                 Ename
                 (mapcar
                   (function
                     (lambda (%)
                       (cons (cdr %) (car %))
                     )
                   )
                   (cd:DCT_GetDictList root T)
                 )
               )
             )
  )
  (if (cd:DCT_RemoveDict root name)
    (progn
      (setq en (cd:DCT_AddXrecord root name Data))
      (cd:DCT_GetXRecord en)
    )
  )
)