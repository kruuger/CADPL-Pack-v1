; =========================================================================================== ;
; MatchAtt.lsp - Uzgadnia niektore cechy atrybutow, tekstow i tekstow wieloliniowych /        ;
;                Match some properties of attributes, text and multiline text                 ;
; =========================================================================================== ;
;  Project : CADPL (www.cad.pl, http://forum.cad.pl/cadpl-uzgodnij-atrybuty-t78683.html)      ;
;  Ver     : 1.00                                                                             ;
;  Date    : 2012-03-13-2012                                                                  ;
;  Library : CADPL-Pack-v1.lsp                                                                ;
; =========================================================================================== ;
; Historia zmian: / History of changes:                                                       ;
;  2012-03-13 - ver. 1.00 : Pierwsza wersja / First version                                   ;
;  2012-04-04 - ver. 1.01 : Cofanie zmian dla grupy, nowe polecenie MATTO /                   ;
;                           Undo the changes for the group, new command MATTO                 ;
;  2013-09-17 - ver. 2.00 : zgodnosc z CAD-Util.lsp / compatibility with CAD-Util.lsp | (CPL) ;
; =========================================================================================== ;
; Polecenia: / Commands:                                                                      ;
;  MATT  - Polecenie glowne / Main command                                                    ;
;  MATTO - Opcje programu (dcl) / Program options (dcl)                                       ;
; =========================================================================================== ;
; Funkcje / Functions:                                                                        ;
;  cd:003_Error     - funkcja obslugi bledow / error handling function                        ;
;  cd:003_FormatMsg - formatuje zgloszenia i komunikaty / format notification and prompts     ;
;  cd:003_GetAtt    - pobiera obiekty zrodlowe i docelowe / gets the source and target objects;
;  cd:003_PropList  - tworzy liste wybranych wlasciwosci / creates a list of selected proper. ;
;  cd:003_MatchAtt  - glowna funkcja programu / program main function                         ;
;  cd:003_ObjList   - ustala liste obiektow / sets a list of objects                          ;
;  cd:003_RegData   - ustawienia programu / program settings                                  ;
;  cd:003_SetupDlg  - obsluga okna dcl / handling of dcl window                               ;
; =========================================================================================== ;
(if (not cd:ACX_ADoc) (load "CADPL-Pack-v1.lsp" -1))
; =========================================================================================== ;
(defun C:MATT  () (cd:003_MatchAtt -1) (princ))
(defun C:MATTO () (cd:003_MatchAtt  0) (princ))
; =========================================================================================== ;
(defun cd:003_Error (Msg)
  (cd:SYS_UndoEnd)
  (if ats (redraw ats 4))
  (princ (strcat "\nMatchAtt error: " Msg))
  (if olderr (setq *error* olderr))
  (princ)
)
; =========================================================================================== ;
(defun cd:003_MatchAtt (Mode / olderr *key *key_help *tra *l *def *pos ols msg ats u atd lst dat)
  (setq olderr *error*
        *error* cd:003_Error
        *key "CADPL\\Tools\\MatchAtt"
        *key_help "\\HelpStrings"
        *tra (list "PL" "EN") ;LANG;
        *l (cond ( (vl-position (cd:SYS_RW *key "Language" nil) *tra) ) ( 1 ) )
        *def (cd:003_RegData)
        *pos (read (cd:SYS_RW *key "DialogPosition" nil))
        ols (cd:003_ObjList (cadr *def) T)
        msg (cd:003_FormatMsg ols T)
  )
  (if (not *l) (setq *l 0))
  (cond
    ( (zerop Mode)
      (princ (nth *l (list "MatchAtt - Opcje\n" "MatchAtt - Options\n"))) ;LANG;
      (cd:003_SetupDlg)
    )
    ( T
      (if
        (setq ats
          (cd:SYS_CheckError
            (list cd:003_GetAtt T)
          )
        )  
        (progn
          (setq lst (cd:003_PropList (car *def))
                dat (cd:ACX_GetProp ats lst)
                msg (cd:003_FormatMsg ols nil)
                u (not (zerop (caddr *def)))
          )
          (redraw ats 3)
          (if u (cd:SYS_UndoBegin))
          (while
            (setq atd
              (cd:SYS_CheckError
                (list cd:003_GetAtt nil)
              )
            )
            (if
              (vlax-write-enabled-p
                (vla-objectidtoobject
                  (cd:ACX_ADoc)
                  (vla-get-ownerID
                    (vlax-ename->vla-object atd)
                  )
                )
              )
              (progn
                (if (not u)(cd:SYS_UndoBegin))
                (cd:ACX_SetProp atd dat)
                (if (not u)(cd:SYS_UndoEnd))
              )
              (princ
                (nth *l
                  (list "\nObiekt na zablokowanej warstwie " "\nObject on a locked layer ") ;LANG;
                )
              )
            )
          )
          (if u (cd:SYS_UndoEnd))
          (redraw ats 4)
        )
      )
    )
  )
  (setq *error* olderr)
)
; =========================================================================================== ;
(defun cd:003_FormatMsg (Lob Mode)
  (strcat
    (nth *l (list "\nWska¿ " "\nSelect ")) ;LANG;
    (cond
      ( (= (length Lob) 3)
        (strcat
          (if Mode
            (nth *l (list "obiekty Ÿród³owe (" "source (")) ;LANG;
            (nth *l (list "obiekty docelowe (" "targets (")) ;LANG;
          )
          (car Lob) ", " (cadr Lob) ", " (caddr Lob) ")"
        )
      )
      ( (= (length Lob) 2)
        (strcat
          (if Mode
            (nth *l (list "obiekty Ÿród³owe (" "source (")) ;LANG;
            (nth *l (list "obiekty docelowe (" "targets (")) ;LANG;
          )
          (car Lob) ", " (cadr Lob) ")"
        )
      )
      (T
        (strcat
          (car Lob)
          (if Mode
            (nth *l (list " Ÿród³owy" " source")) ;LANG;
            (nth *l (list " docelowy" " target")) ;LANG;
          )
        )
      ) 
    )
    (if Mode
      (nth *l (list " lub [Opcje/WyjdŸ]: " " or [Options/Exit]: ")) ;LANG;
      (nth *l (list " lub [WyjdŸ]: " " or [Exit]: ")) ;LANG;
    )
  )
)
; =========================================================================================== ;
(defun cd:003_PropList (Bit)
  (if (< 0 Bit 129)
    (progn
      (if (= Bit 128)(setq Bit 127))
      (mapcar
        (function
          (lambda (%)
            (cdr
              (assoc %
                (mapcar
                  (quote cons)
                  (cd:CAL_BitList 127)
                  (list
                    "TextString" "Color" "Layer"
                    "StyleName" "Height" "ScaleFactor"
                    "Rotation"
                  )
                )
              )
            )
          )
        )
        (cd:CAL_BitList Bit)
      )
    )
  )
)
; =========================================================================================== ;
(defun cd:003_ObjList (Bit Mode)
  (mapcar
    (function
      (lambda (%)
        (cdr
          (assoc %
            (mapcar
              (quote cons)
              (cons 0 (cd:CAL_BitList 3))
              (if (not Mode)
                (list "ATTRIB" "TEXT" "MTEXT")
                (nth *l
                  (list
                    (list "atrybut" "tekst" "tekst wieloliniowy") ;LANG;
                    (list "attribute" "text" "multiline text")    ;LANG;
                  )
                )
              )
            )
          )
        )
      )
    )
    (if (zerop Bit)
      (list 0)
      (cons 0 (cd:CAL_BitList Bit))
    )
  )
)
; =========================================================================================== ;
(defun cd:003_GetAtt (In / res ent)
  (while
    (progn
      (setvar "ERRNO" 0)
      (if In
        (initget (nth *l (list "Opcje WyjdŸ" "Options Exit"))) ;LANG;
        (initget (nth *l (list "WyjdŸ" "Exit"))) ;LANG;
      )
      (setq res
        (nentsel
          (cd:003_FormatMsg (cd:003_ObjList (cadr *def) T) In)
        )
      )
      (cond
        ( (= res (nth *l (list "WyjdŸ" "Exit"))) ;LANG;
          (setq res (not (princ (nth *l (list "\nZakoñczono" "\nFinished"))))) ;LANG;
        )
        ( (= res (nth *l (list "Opcje" "Options"))) ;LANG;
          (cd:003_SetupDlg)
        )
        ( (= (getvar "ERRNO") 7)
          (princ (nth *l (list "\nNic nie wybrano - spróbuj ponownie " "\nNothing selected - try again "))) ;LANG;
        )
        ( (null res)
          (not (princ (nth *l (list "\nZakoñczono - nic nie wybrano " "\nFinished - nothing selected ")))) ;LANG;
        )
        ( (listp res)
          (setq ent (car res))
          (if (member (cdr (assoc 0 (entget ent)))(cd:003_ObjList (cadr *def) nil))
            (if (= (length res) 2)
              (not (setq res ent))
              (princ (nth *l (list "\nNieprawid³owy obiekt - spróbuj ponownie " "\nInvalid object - try again "))) ;LANG;
            )
            (princ (nth *l (list "\nNieprawid³owy obiekt - spróbuj ponownie " "\nInvalid object - try again "))) ;LANG;
          )
        )
        (T nil)
      )
    )
  )
  res
)
; =========================================================================================== ;
(defun cd:003_RegData (/ n h1 h2)
  (setq n 0)
  (setq h1
    (list
      (cons "MATT"  (list "Polecenie g³ówne" "Main command")) ;LANG;
      (cons "MATTO" (list "Opcje programu (dcl)" "Program options (dcl)")) ;LANG;
    )
  )
  (setq h2
    (list
      (cons "Description" (list "Uzgadnia niektóre cechy ATTRIB TEXT MTEXT" "Match some properties of ATTRIB TEXT MTEXT")) ;LANG;
    )
  )
  (foreach %
    (list
      (cons "AcadLanguage" (cadddr (cd:SYS_AcadInfo)))
      (cons "Command" (cd:STR_ReParse (mapcar (quote car) h1)  ","))
      (cons "DialogPosition" "T")
      (cons "File" "MatchAtt.lsp")
      (cons "Group" "Attribute")
      (cons "Tool" "003")
      (cons "Translations" (cd:STR_ReParse *tra ","))
      (cons "Version" "2.00")
      
      (cons "Objects" "3")
      (cons "Properties" "58")
      (cons "Undo" "1")
    )
    (if
      (or 
        (= (car %) "Command")
        (= (car %) "Version")
      )
      (cd:SYS_RW *key (car %)(cdr %))
      (or
        (cd:SYS_RW *key (car %) nil)
        (cd:SYS_RW *key (car %)(cdr %))
      )
    )
  )
  (foreach % *tra
    (foreach %1 h1
      (cd:SYS_RW (strcat *key *key_help "\\" %) (car %1) (nth n (cdr %1)))
    )
    (foreach %1 h2
      (cd:SYS_RW (strcat *key *key_help "\\" %) (car %1) (nth n (cdr %1)))
    )
    (setq n (1+ n))
  )
  (mapcar
    (function
      (lambda (%)
        (atoi (cd:SYS_RW *key % nil))
      )
    )
    (list "Properties" "Objects" "Undo")
  )
)
; =========================================================================================== ;
(defun cd:003_SetupDlg (/ $Tgset $Tgsel $Bitok bit bitt und lr lt r h b v rb la tk fd tmp dc res)
  (defun $Bitok ()
    (mode_tile "accept"
      (if (zerop bit) 1 0)
    )
  )
  (defun $Tgset ()
    (foreach % (if (= 128 bit)(cons 128 lr)(cd:CAL_BitList bit))
      (set_tile (itoa %) "1")
    )
    ($Bitok)
    (foreach % lr
      (mode_tile (itoa %)(if (= 128 bit) 1 0))
    )
  )
  (defun $Tgsel (Key Val)
    (setq bit
      (if (zerop (read Val))
        (- bit (read Key))
        (+ bit (read Key))
      )
    )
    ($Bitok)
  )
  (if (not *pos)(setq *cd-TempDlgPosition* (list -1 -1)))
  (setq bit (car *def)
        bitt (cadr *def)
        und (caddr *def)
        lr (cd:CAL_BitList 127)
        lt (cd:CAL_BitList 3)
        r ":radio_button{key=\""
        h "fixed_width=true;"
        b ":boxed_row{label=\""
        v "width=12;horizontal_margin=none;"
        rb ":retirement_button{"
        la "label=\""
        tk ":toggle{key=\""
  )
  (cond
    ( (not
        (and
          (setq fd
            (open
              (setq tmp (vl-FileName-MkTemp nil nil ".dcl")) "w"
            )
          )
          (foreach %
            (list
              (strcat "mattsetup:dialog{" la
                (nth *l (list "MatchAtt - Opcje" "MatchAtt - Options")) "\";" ;LANG;
                b (nth *l (list "Dodatkowe obiekty:" "Additional objects:")) "\";" h ;LANG;
                tk "t1\";" la (nth *l (list "&Tekst" "&Text")) "\";" "}" ;LANG;
                tk "t2\";" la (nth *l (list "Tekst &wieloliniowy" "&Multiline text")) "\";" "}" ;LANG;
                "}" b
                (nth *l (list "Wybierz w³aœciwoœci:" "Select properties:")) "\";:column{" h ;LANG;
                (apply
                  (quote strcat)
                  (mapcar
                    (function
                      (lambda (%1 %2)
                        (strcat tk (itoa %1) "\";" la (nth *l %2) "\";" "}")
                      )
                    )
                    (cd:CAL_BitList 255)
                    (list
                      (list "W&artoœæ" "V&alue") ;LANG;
                      (list "K&olor" "C&olor") ;LANG;
                      (list "&Warstwa" "&Layer") ;LANG;
                      (list "Styl t&ekstu" "T&ext style name") ;LANG;
                      (list "Wys&okoœæ" "&Height") ;LANG;
                      (list "Wspó³&czynik szerokoœci" "Width &factor") ;LANG;
                      (list "Ob&rót" "&Rotation") ;LANG;
                      (list "&Zaznacz wszystko" "&Select all") ;LANG;
                    )
                  )
                )
                "}}"
              )
              (strcat
                b (nth *l (list "Cofaj zmiany:" "Undo the changes:")) "\";" ;LANG;
                r "u0\";" la (nth *l (list "&Pojedynczo" "&Singly")) "\";}" ;LANG;
                r "u1\";" la (nth *l (list "&Grupa" "&Group")) "\";" ;LANG;
                "}}"
              )
              (strcat
                ":row{width=25;" h "alignment=centered;"
                rb la "OK\";key=\"accept\";is_default=true;" v "}" rb la
                (nth *l (list "&Anuluj" "&Cancel")) "\";" ;LANG;
                "key=\"cancel\";is_cancel=true;" v "}}}"
              )
            )
            (write-line % fd)
          )
          (not (close fd))
          (< 0 (setq dc (load_dialog tmp)))
          (new_dialog "mattsetup" dc ""
            (cond
              (*cd-TempDlgPosition*)
              ( (quote (-1 -1)) )
            )
          )
        )
      )
    )
    ( T
      ($Tgset)
      (foreach %
        (cd:CAL_BitList bitt)
        (set_tile (strcat "t" (itoa %)) "1")
      )
      (foreach % lr
        (action_tile (itoa %) "($Tgsel $key $value)")
      )
      (foreach % lt
        (action_tile
          (strcat "t" (itoa %))
          (strcat
            "(setq bitt (if (zerop (read $value))(- bitt (read (substr $key 2 1)))"
            "(+ bitt (read (substr $key 2 1)))))"
          )
        )
      )
      (set_tile (strcat "u" (itoa und)) "1")
      (foreach % (list "u0" "u1")
        (action_tile % "(setq und (atoi (substr $key 2 1)))")
      )
      (action_tile "128" "(setq bit (nth (read $value)(list 127 128)))($Tgset)")
      (action_tile "accept" "(setq *cd-TempDlgPosition* (done_dialog 1))")
      (action_tile "cancel" "(setq *cd-TempDlgPosition* (done_dialog 0))")
      (setq res (start_dialog))
    )
  )
  (if (< 0 dc) (unload_dialog dc))
  (if (setq tmp (findfile tmp)) (vl-file-delete tmp))
  (if (not (zerop res))
    (progn
      (cd:SYS_RW *key "Properties" (itoa bit))
      (cd:SYS_RW *key "Objects" (itoa bitt))
      (cd:SYS_RW *key "Undo" (itoa und))
      (setq *def (list bit bitt und))
      (princ (nth *l (list "\nZapisano ustawienia " "\nSettings saved "))) ;LANG;
    )
    (princ (nth *l (list "\nNie zmieniono ustawieñ " "\nSettings unchanged "))) ;LANG;
  )
)
; =========================================================================================== ;
(princ "\n [MatchAtt v2.00]: (MATT MATTO) ")
(princ)
