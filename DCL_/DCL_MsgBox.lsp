; =========================================================================================== ;
; DCL-owe okno komunikatu / DCL message box                                                   ;
;  Msg   [STR]         - komunikat do wyswietlenia / message to display                       ;
;  Title [STR]         - tytul okna / window title                                            ;
;  Btn   [0/1/2/3/4/5] - przyciski / buttons                                                  ;
;  DPos  [T/nil]       - zapamietanie pozycji okna / save window position                     ;
;  Lng   [0/1/nil]     - 0   = jezyk polski / polish language                                 ;
;                        1   = jezyk angielski / english language                             ;
;                        nil = ustawienie standardowe / default settings                      ;
; ------------------------------------------------------------------------------------------- ;
; Typy przyciskow / Buttons type:                                                             ;
;  0  = OK                / OK                                                                ;
;  1  = OK i Anuluj       / OK and Cancel                                                     ;
;  2  = Anuluj            / Cancel                                                            ;
;  3  = Tak, Nie i Anuluj / Yes, No and Cancel                                                ;
;  4  = Tak i Nie         / Yes and No                                                        ;
;  5  = Zamknij           / Close                                                             ;
; ------------------------------------------------------------------------------------------- ;
; Zwraca / Return:                                                                            ;
;  1  = OK      / OK                                                                          ;
;  2  = Anuluj  / Cancel                                                                      ;
;  6  = Tak     / Yes                                                                         ;
;  7  = Nie     / No                                                                          ;
;  12 = Zamknij / Close                                                                       ;
; ------------------------------------------------------------------------------------------- ;
; (cd:DCL_Msgbox "Komunikat\nw 2 liniach" "Uwaga" 4 T 0)                                      ;
; =========================================================================================== ;
(defun cd:DCL_MsgBox (Msg Title Btns DPos Lng / data f tmp dc res l d c h)
  (if (not DPos) (setq *cd-TempDlgPosition* (list -1 -1)))
  (setq data (cd:STR_Parse Msg "\n" T)
        d    (length data)
        c    (if (numberp Lng)
               (cond
                 ((zerop Lng) T)
                 ((= 1 Lng) nil)
                 (T nil)
               )
               (= "PL" (cadddr (cd:SYS_AcadInfo)))
             )
        h    "width=12;horizontal_margin=none;vertical_margin=none;fixed_width=true;"
  )
  (cond
    ((not
       (and
         (setq f (open
                   (setq tmp (vl-FileName-MkTemp nil nil ".dcl"))
                   "w"
                 )
         )
         (foreach %
           (list
             "StdYesNoDialog:dialog{"
             (strcat "label=\""
                     (if Title (strcat Title "\";") "\"\";")
             )
             ":text{key=\"text\";"
             (strcat
               "width="
               (itoa
                 (if
                   (< (setq l (car (vl-sort (mapcar (quote strlen) data) (quote >))))
                      36
                   )
                   37
                   (if (> l 100) 99 l)
                 )
               )
               ";height="
               (if (>= d 15) "15" (itoa d))
             )
             ";}:spacer{height=0.2;}:row{alignment=centered;spacer_0;"
             (cond
               ((zerop Btns)
                (strcat
                  ":retirement_button{label=\"OK\";key=\"accept\";is_default=true;"
                  h
                  "}"
                )
               )
               ((= 1 Btns)
                (strcat
                  ":row{width=25;fixed_width=true;"
                  ":retirement_button{label=\"OK\";key=\"accept\";is_default=true;"
                  h
                  "}:retirement_button{"
                  (if c "label=\"&Anuluj\";" "label=\"&Cancel\";")
                  "key=\"cancel\";is_cancel=true;"
                  h
                  "}}"
                )
               )
               ((= 2 Btns)
                (strcat
                  ":retirement_button{"
                  (if c "label=\"&Anuluj\";" "label=\"&Cancel\";")
                  "key=\"cancel\";is_cancel=true;"
                  h
                  "}"
                )
               )
               ((= 3 Btns)
                (strcat
                  ":row{width=38;fixed_width=true;:button{"
                  (if c "label=\"&Tak\";" "label=\"&Yes\";")
                  "key=\"yes\";is_default=true;"
                  h
                  "}:button{"
                  (if c "label=\"&Nie\";" "label=\"&No\";")
                  "key=\"not\";"
                  h
                  "}:retirement_button{"
                  (if c "label=\"&Anuluj\";" "label=\"&Cancel\";")
                  "key=\"cancel\";is_cancel=true;"
                  h
                  "}}"
                )
               )
               ((= 4 Btns)
                (strcat
                  ":row{width=25;fixed_width=true;:button{"
                  (if c "label=\"&Tak\";" "label=\"&Yes\";")
                  "key=\"yes\";is_default=true;"
                  h
                  "}:button{"
                  (if c "label=\"&Nie\";" "label=\"&No\";")
                  "key=\"not\";"
                  h
                  "}}"
                )
               )
               ((= 5 Btns)
                (strcat
                  ":button{is_cancel=true;"
                  (if c "label=\"&Zamknij\";" "label=\"&Close\";")
                  "key=\"close\";width=12;"
                  h
                  "is_default=true;}"
                )
               )
               (T
                (strcat
                  ":retirement_button{label=\"OK\";key=\"accept\";is_default=true;"
                  h
                  "}"
                )
               )
             )
             "spacer_0;}}"
           )
           (write-line % f)
         )
         (not (close f))
         (< 0 (setq dc (load_dialog tmp)))
         (new_dialog "StdYesNoDialog"
                     dc
                     ""
                     (cond
                       (*cd-TempDlgPosition*)
                       ((quote (-1 -1)))
                     )
         )
       )
     )
    )
    (T
     (set_tile "text"
               (apply (quote strcat)
                      (mapcar
                        (function
                          (lambda (%)
                            (strcat % "\n")
                          )
                        )
                        data
                      )
               )
     )
     (action_tile "accept" "(setq *cd-TempDlgPosition* (done_dialog 1))")
     (action_tile "yes" "(setq *cd-TempDlgPosition* (done_dialog 6))")
     (action_tile "cancel" "(done_dialog 2)")
     (action_tile "not" "(done_dialog 7)")
     (action_tile "close" "(done_dialog 12)")
     (setq res (start_dialog))
    )
  )
  (if (< 0 dc) (unload_dialog dc))
  (if (setq tmp (findfile tmp)) (vl-File-Delete tmp))
  (if (not DPos) (setq *cd-TempDlgPosition* (list -1 -1)))
  res
)