; =========================================================================================== ;
; Zwraca liste czcionek systemowych / Returns system font list                                ;
; =========================================================================================== ;
(defun cd:SYS_GetFonts (/ lt reg ttfs ls shxs)
  (setq lt (vl-remove-if-not
             (function
               (lambda (%) (wcmatch % "*TrueType)"))
             )
             (vl-registry-descendents
               (setq reg (strcat "HKEY_LOCAL_MACHINE\\Software\\Microsoft\\"
                                 "Windows NT\\CurrentVersion\\Fonts"
                         )
               )
               ""
             )
           )
  )
  (setq ttfs (mapcar
               (function
                 (lambda (%)
                   (cons
                     (vl-string-right-trim " (TrueType)" %)
                     (vl-registry-read reg %)
                   )
                 )
               )
               (vl-remove-if-not
                 (function
                   (lambda (%1 / %2)
                     (and
                       (not
                         (wcmatch
                           (setq %2 (vl-registry-read reg %1))
                           "*\\*"
                         )
                       )
                       (wcmatch (strcase %2) "*.TTF")
                     )
                   )
                 )
                 lt
               )
             )
        lt   (mapcar (quote car) ttfs)
        ls   (vl-directory-files
               (vl-filename-directory
                 (findfile "isocp.shx")
               )
               "*.shx"
             )
        shxs (mapcar (function (lambda (%) (cons % %))) ls)
  )
  (list
    (append lt ls)
    (append ttfs shxs)
  )
)