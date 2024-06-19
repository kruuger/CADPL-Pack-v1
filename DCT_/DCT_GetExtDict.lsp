; =========================================================================================== ;
; Pobiera/Tworzy ExtensionDictionary obiektu / Gets/Creates an ExtensionDictionary of object  ;
;  Ename [ENAME] - nazwa entycji / entity name                                                ;
;  Flag  [T/nil] - T   = tworzy / creates                                                     ;
;                  nil = pobiera jesli istnieje / gets if exist                               ;
; ------------------------------------------------------------------------------------------- ;
; (cd:DCT_GetExtDict (car (entsel)) T)                                                        ;
; =========================================================================================== ;
(defun cd:DCT_GetExtDict (Ename Flag / res he ta)
  (if
    (and
      (= (type Ename) (quote ENAME))
      (setq dt (entget Ename))
    )
    (if (not (setq res (cdr (assoc 360 (member '(102 . "{ACAD_XDICTIONARY") dt)))))
      (if Flag
        (progn
          (setq res (entmakex
                      (append '((0 . "DICTIONARY") (100 . "AcDbDictionary")))
                    )
                he  (reverse (member (assoc 5 dt) (reverse dt)))
                ta  (cdr (member (assoc 5 dt) dt))
          )
          (entmod
            (append
              he
              (list
                '(102 . "{ACAD_XDICTIONARY")
                (cons 360 res)
                '(102 . "}")
              )
              ta
            )
          )
        )
      )
    )
  )
  res
)