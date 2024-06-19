; =========================================================================================== ;
; Lista odnosnikow zewnetrznych / List of external references                                 ;
; =========================================================================================== ;
(defun cd:BLK_GetXrefs (/ res)
  (vlax-for % (cd:ACX_Blocks)
    (if (= (vla-get-IsXref %) :vlax-true)
      (setq res (cons (vla-get-name %) res))
    )
  )
  res
)