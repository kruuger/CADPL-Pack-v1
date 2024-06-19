; =========================================================================================== ;
; Lista sciezek do czcionek (Win/Acad) / List of paths to the fonts (Win/Acad)                ;
; =========================================================================================== ;
(defun cd:SYS_FontPaths ()
  (cons
    (findfile (strcat (getenv "WINDIR") "\\fonts"))
    (vl-remove-if-not
      (function
        (lambda (%)
          (wcmatch (strcase %) "*\\FONTS")
        )
      )
      (cd:STR_Parse (getvar "ACADPREFIX") ";" T)
    )
  )
)