; =========================================================================================== ;
; Okno dialogowe z lista "list_box" / Dialog control with list "list_box"                     ;
;  Data      [LIST]     - lista do wyswietlenia / list to display                             ;
;  Pos       [INT]      - pozycja poczatkowa na liscie / select list position                 ;
;  Title     [STR/nil]  - tytul okna / window title                                           ;
;  ListTitle [STR/nil]  - tytul list_box / list_box title                                     ;
;  Width     [INT]      - szerokosc / width                                                   ;
;  Height    [INT]      - wysokosc / height                                                   ;
;  Btns      [0/1/2]    - [cancel/ok/ok_cancel] przyciski / buttons                           ;
;  BtnsWidth [REAL/INT] - szerokosc przyciskow / buttons width                                ;
;  BtnsLabel [LIST]     - etykiety przyciskow / buttons label                                 ;
;  MSelect   [T/nil]    - dopuszczenie multiple_select / allow multiple select                ;
;  DPos      [T/nil]    - zapamietanie pozycji okna / save window position                    ;
;  DblClick  [T/nil]    - podwojny klik (wykluczone Cancel) / double click (not for Cancel)   ;
;  Func      [SUBR]     - funkcja do obslugi wybranej pozycji na liscie /                     ;
;                         function to operate selected position on the list                   ;
; ------------------------------------------------------------------------------------------- ;
; Zwraca / Return:                                                                            ;
;  nil  = nic nie wybrano (anulowano) / nothing was selected (canceled)                       ;
;  INT  = wybrano jedna pozycje / one position selected  | MSelect = nil                      ;
;  LIST = wybrano kilka pozycji / few positions selected | MSelect = T                        ;
; ------------------------------------------------------------------------------------------- ;
; (cd:DCL_StdListDialog                                                                       ;
;   (setq lst (mapcar 'car (cd:DWG_LayoutsList))) (vl-position (getvar "ctab") lst)           ;
;   "List of Layouts" "Select layout:" 40 15 2 13 (list "&Ok" "&Cancel")                      ;
;   nil T T '(setvar "ctab" (nth (atoi res) lst)))                                            ;
; =========================================================================================== ;
(defun cd:DCL_StdListDialog (Data Pos Title ListTitle Width Height Btns BtnsWidth
                             BtnsLabel MSelect DPos DblClick Func / _Sub _Value2List
                             _SetControls fd ok ca tmp dc res
                            )
  (defun _Sub (Val)
    (if (and Func Data) (eval Func))
    (_SetControls (setq res (_Value2List Val)))
  )
  (defun _Value2List (Val) (read (strcat "(" Val ")")))
  (defun _SetControls (Idx)
    (if (and Idx Data)
      (mode_tile (car BtnsLabel) 0)
      (mode_tile (car BtnsLabel) 1)
    )
  )
  (if (not DPos) (setq *cd-TempDlgPosition* (list -1 -1)))
  (cond
    ((not
       (and
         (setq fd (open
                    (setq tmp (vl-FileName-MkTemp nil nil ".dcl"))
                    "w"
                  )
         )
         (setq ok (strcat
                    ": but { label = \""
                    (car BtnsLabel)
                    "\";"
                    "  key = \""
                    (car BtnsLabel)
                    "\"; is_default = true;}"
                  )
               ca (strcat
                    ": but { label=\""
                    (cadr BtnsLabel)
                    "\";"
                    "  key = \""
                    (cadr BtnsLabel)
                    "\";is_cancel = true;}"
                  )
         )
         (foreach %
           (list
             (strcat
               "but : button { width = "
               (if BtnsWidth (itoa BtnsWidth) 13)
               "; fixed_width = true; }"
               "StdListDialog: dialog {"
               (if Title (strcat "label = \"" Title "\";") "")
               ": list_box { key = \"list\";"
               (if ListTitle (strcat "label = \"" ListTitle "\";") "")
               "fixed_width = true; fixed_height = true;"
               "width = "
               (if Width (itoa Width) "20")
               ";"
               "height = "
               (if Height (itoa Height) "20")
               ";"
               "multiple_select = "
               (if MSelect "true;" "false;")
               "} : row { alignment = centered; fixed_width = true;"
             )
             (cond
               ((zerop Btns) ca)
               ((= 1 Btns) ok)
               (T (strcat ok ca))
             )
             "}}"
           )
           (write-line % fd)
         )
         (not (close fd))
         (< 0 (setq dc (load_dialog tmp)))
         (new_dialog "StdListDialog"
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
     (start_list "list")
     (mapcar (quote add_list) Data)
     (end_list)
     (if
       (or
         (not Pos)
         (not (< -1 Pos (length Data)))
       )
       (setq Pos 0)
     )
     (setq res (set_tile "list" (itoa Pos)))
     (_Sub res)
     (action_tile "list"
                  (vl-prin1-to-string
                    (quote
                      (progn
                        (setq res $value)
                        (_Sub res)
                        (if
                          (and
                            DblClick
                            (not (zerop Btns))
                          )
                          (if (= $reason 4)
                            (setq *cd-TempDlgPosition* (done_dialog 1))
                          )
                        )
                      )
                    )
                  )
     )
     (action_tile (car BtnsLabel) "(setq *cd-TempDlgPosition* (done_dialog 1))")
     (action_tile (cadr BtnsLabel) "(setq res nil) (done_dialog 0)")
     (start_dialog)
    )
  )
  (if (< 0 dc) (unload_dialog dc))
  (if (setq tmp (findfile tmp)) (vl-file-delete tmp))
  (if (not DPos) (setq *cd-TempDlgPosition* (list -1 -1)))
  (if res (if MSelect res (car res)))
)