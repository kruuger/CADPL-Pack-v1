; =========================================================================================== ;
; Wybiera zadane obiekty / Select a desired object                                            ;
;  Msg   [LIST]     - lista komunikatow / list of messages                                    ;
;  Obj   [LIST/nil] - LIST = lista zadanych obiektow / list of desired objects                ;
;                     nil  = wybiera dowolne obiekty / selects any objects                    ;
;  Init  [STR/nil]  - STR = slowa kluczowe / keywords                                         ;
;                     nil = bez slow kluczowych / no keywords                                 ;
;  Lock  [T/nil] - pomija obiekty na zamknietej warstwie / ignored objects in a locked layer  ;
;                  nil = tak / yes                                                            ;
;                  T   = nie / no                                                             ;
;  Enter [T/nil] - zakoncz prawy klik/spacja/enter / exit right click/space/enter             ;
;                  nil = nie / no                                                             ;
;                  T   = tak / yes                                                            ;
; ------------------------------------------------------------------------------------------- ;
; (cd:USR_EntSelObj                                                                           ;
;   (list                                                                                     ;
;     "\nWybierz blok [Opcje/Wyjdz]: " "Nalezy wskazac blok " "Nic nie wybrano "              ;
;     "To nie blok " "Obiekt na zamknietej warstwie "                                         ;
;   )                                                                                         ;
;   (list "INSERT") "Opcje Wyjdz" T nil                                                       ;
; )                                                                                           ;
; =========================================================================================== ;
(defun cd:USR_EntSelObj (Msg Obj Init Lock Enter / res)
  (while
    (progn
      (setvar "ERRNO" 0)
      (if Init (initget Init))
      (setq res (entsel (car Msg)))
      (cond
        ((= (getvar "ERRNO") 7)
         (princ (cadr Msg))
        )
        ((null res)
         (if Enter
           (not (princ (caddr Msg)))
           (princ (caddr Msg))
         )
        )
        ((listp res)
         (if
           (if Obj
             (member (cdr (assoc 0 (entget (car res)))) Obj)
             T
           )
           (if Lock
             (if (vlax-write-enabled-p (car res))
               (not (setq res res))
               (princ (last Msg))
             )
             (not (setq res res))
           )
           (princ (cadddr Msg))
         )
        )
        ((= (type res) (quote STR))
         nil
        )
        (T nil)
      )
    )
  )
  res
)