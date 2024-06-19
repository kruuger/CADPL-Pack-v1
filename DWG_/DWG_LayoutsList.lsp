; =========================================================================================== ;
; Lista arkuszy rysunku / Layouts drawing list                                                ;
; =========================================================================================== ;
(defun cd:DWG_LayoutsList (/ res)
  (vlax-for % (cd:ACX_Layouts)
    (setq res (cons
                (list
                  (vla-get-name %)
                  (vla-get-TabOrder %)
                  %
                )
                res
              )
    )
  )
)