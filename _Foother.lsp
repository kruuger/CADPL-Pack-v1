; =========================================================================================== ;
(if
  (and
    (setq % (cd:SYS_ReadFile 2 "CADPL-Pack-v1.lsp"))
    (/= % -1)
  )
  (princ
    (strcat
      "\n-- CADPL-Pack-v1.lsp ("
      (substr % 5 10)
      ") - http://forum.cad.pl (R.I.P.) --"
    )
  )
  (princ "\n------- CADPL-Pack-v1.lsp - http://forum.cad.pl (R.I.P.) -------")
)
(setq % nil)
(princ)