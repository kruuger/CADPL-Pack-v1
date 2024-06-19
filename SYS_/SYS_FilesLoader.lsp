; =========================================================================================== ;
; Wczytuje pliki lsp,fas,vlx / Loads files lsp,fas,vlx                                        ;
;  Lst [LIST]  - lista plikow / files list                                                    ;
; ------------------------------------------------------------------------------------------- ;
; (cd:SYS_FilesLoader (list "CADPL-Pack-v1.lsp" "Brak.fas" "Nawias.lsp"))                     ;
; =========================================================================================== ;
(defun cd:SYS_FilesLoader (Lst / err res)
  (foreach % Lst
    (if
      (and
        (setq err (vl-catch-all-apply (quote load) (list %)))
        (= (type err) (quote vl-catch-all-apply-error))
      )
      (setq res (cons
                  (cons % (vl-catch-all-error-message err))
                  res
                )
      )
    )
  )
  (reverse res)
)