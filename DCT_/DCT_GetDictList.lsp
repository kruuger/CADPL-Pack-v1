; =========================================================================================== ;
; Pobiera liste slownikow "rodzica" / Gets a list of "parent" dictionaries                    ;
;  Root [ENAME] - ENAME = slownik "rodzic" / "parent" dictionary                              ;
;  Code [T/nil] - T   = zwraca / returns -> ((<slownik1> . <ENAME1>) ... )                    ;
;                 nil = zwraca / returns -> (<slownik1> <slownik2> ... )                      ;
; ------------------------------------------------------------------------------------------- ;
; (cd:DCT_GetDictList (cd:DCT_GetDict (namedobjdict) "NAZWA") T)                              ;
; =========================================================================================== ;
(defun cd:DCT_GetDictList (Root Code / dt tmp res)
  (if Root
    (if Code
      (progn
        (setq dt (entget Root))
        (while (setq dt (member (setq tmp (assoc 3 dt)) dt))
          (setq res (cons (cons (cdr tmp) (cdadr dt)) res)
                dt  (cdr dt)
          )
        )
        (setq res (reverse res))
      )
      (setq res (cd:DXF_massoc 3 (entget Root)))
    )
  )
  res
)