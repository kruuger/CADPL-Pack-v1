; =========================================================================================== ;
; Zmienia PICKSET na liste obiektow / Convert PICKSET to list of objects                      ;
;  Ss   [PICKSET] - zbior wskazan / selection sets                                            ;
;  Mode [INT]     - typ zwracanych obiektow / type of returned objects                        ;
;                   0 = ENAME, 1 = VLA-OBJECT, 2 = SAFEARRAY                                  ;
; ------------------------------------------------------------------------------------------- ;
; (cd:SSX_Convert (ssget) 1)                                                                  ;
; =========================================================================================== ;
(defun cd:SSX_Convert (Ss Mode / n res)
  (if
    (and
      (member Mode (list 0 1 2))
      (not
        (minusp
          (setq n (if Ss (1- (sslength Ss)) -1))
        )
      )
    )
    (progn
      (while (>= n 0)
        (setq res (cons
                    (if (zerop Mode)
                      (ssname Ss n)
                      (vlax-ename->vla-object (ssname Ss n))
                    )
                    res
                  )
              n   (1- n)
        )
      )
      (if (= Mode 2)
        (vlax-safearray-fill
          (vlax-make-safearray 9
                               (cons 0 (1- (length res)))
          )
          res
        )
        res
      )
    )
  )
)