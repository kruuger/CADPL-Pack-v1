; =========================================================================================== ;
; Obszar papieru / Paper space                                                                ;
; =========================================================================================== ;
(defun cd:ACX_Paper ()
  (setq *cd-PaperSpace* (vla-get-PaperSpace (cd:ACX_ADoc)))
)