; =========================================================================================== ;
; AcadInfo np. ("AutoCAD" 18.0 64 "PL")                                                       ;
; =========================================================================================== ;
(defun cd:SYS_AcadInfo (/ s v)
  (list
    (getvar "PRODUCT")
    (atof (getvar "ACADVER"))
    (if (wcmatch (strcase (getenv "PROCESSOR_ARCHITECTURE")) "*64*") 64 32)
    (if (setq s (vl-string-search "(" (setq v (ver))))
      (strcase (substr v (+ 2 s) 2))
      "??"
    )
  )
)