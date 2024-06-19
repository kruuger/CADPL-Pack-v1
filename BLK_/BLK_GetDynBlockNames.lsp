; =========================================================================================== ;
; Lista nazw blokow (*U) zaleznych od bloku dynamicznego /                                    ;
; List of the blocks name (*U) which depends on a dynamic block                               ;
;  Name [STR] - nazwa bloku / block name                                                      ;
; ------------------------------------------------------------------------------------------- ;
; (cd:BLK_GetDynBlockNames "NazwaBloku")                                                      ;
; =========================================================================================== ;
(defun cd:BLK_GetDynBlockNames (Name / res n xd handle ent)
  (setq res (list Name))
  (vlax-for % (cd:ACX_Blocks)
    (if (wcmatch (setq n (vla-get-name %)) "`*U*")
      (if
        (setq xd (cd:XDT_GetXData
                   (vlax-vla-object->ename %)
                   "AcDbBlockRepBTag"
                 )
        )
        (if
          (and
            (setq handle (cdr (assoc 1005 (cdr xd))))
            (setq ent (handent
                        handle
                      )
            )
            (=
              (strcase Name)
              (strcase
                (cdr
                  (assoc 2
                         (entget
                           ent
                         )
                  )
                )
              )
            )
          )
          (setq res (cons n res))
        )
      )
    )
  )
  (reverse res)
)