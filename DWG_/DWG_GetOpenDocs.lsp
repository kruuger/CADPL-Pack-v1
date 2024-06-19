; =========================================================================================== ;
; Lista otwartych dokumentow / Open documents list                                            ;
; =========================================================================================== ;
(defun cd:DWG_GetOpenDocs (/ res)
  (vlax-for % (vla-get-documents (vlax-get-acad-object))
    (setq res (cons
                (cons
                  (vla-get-name %)
                  %
                )
                res
              )
    )
  )
)