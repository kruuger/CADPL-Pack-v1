; =========================================================================================== ;
; ApplyDate.lsp - Wstawia date / Insert date | ATTRIB/MTEXT/TEXT                              ;
; =========================================================================================== ;
;  Project : CADPL (http://forum.cad.pl/czy-prawidlowe-zachowanie-okiena-dcl-t74794.html)     ;
;  Ver     : 1.00                                                                             ;
;  Date    : 2012-11-07                                                                       ;
;  Library : CADPL-Pack-v1.lsp                                                                ;
; =========================================================================================== ;
; Historia zmian: / History of changes:                                                       ;
;  2012-11-07 - ver. 1.00 : Pierwsza wersja / First version                                   ;
;  2013-09-17 - ver. 2.00 : zgodnosc z CAD-Util.lsp / compatibility with CAD-Util.lsp | (CPL) ;
; =========================================================================================== ;
; Polecenia: / Commands:                                                                      ;
;  ADA  - Polecenie glowne / Main command                                                     ;
;  ADAF - Okienko Format / Format window                                                      ;
;  ADAE - Okienko Edytuj liste / Edit list window                                             ;
;  ADAA - Okienko Dodaj date / Add date window                                                ;
;  -ADA - Wersja w linii polecen / Command line version                                       ;
; =========================================================================================== ;
; Funkcje / Functions:                                                                        ;
;  cd:008_AddDateFormatDialog   - okienko dodawania daty / add date window                    ;
;  cd:008_ApplyDate             - glowna funkcja programu / program main function             ;
;  cd:008_CommandLine           - wersja w linii polecen / command line version               ;
;  cd:008_CreateFormattedString - tworzy lancuch tekstowy reprezentujacy aktualna date /      ;
;                                 creates a text string representing the current date         ;
;  cd:008_DateFormatDialog      - okienko formatow daty / format date window                  ;
;  cd:008_DatePatternList       - lista wzorcow dat / date pattern list                       ;
;  cd:008_EditDateFormatDialog  - okienko edycji daty / edit date window                      ;
;  cd:008_Error                 - funkcja obslugi bledow / error handling function            ;
;  cd:008_FormattedList         - lista sformatowanych dat na podstawie listy wzorcow /       ;
;                                 formatted list of dates from a list of patterns             ;
;  cd:008_RegData               - ustawienia programu / program settings                      ;
;  cd:008_UpdateRegDateFormat   - aktualizuje wpisy w rejestrze / updates the registry entries;
; =========================================================================================== ;
(if (not cd:ACX_ADoc) (load "CADPL-Pack-v1.lsp" -1))
; =========================================================================================== ;
(defun C:ADA  () (cd:008_ApplyDate 0) (princ))
(defun C:ADAF () (cd:008_ApplyDate 1) (princ))
(defun C:ADAE () (cd:008_ApplyDate 2) (princ))
(defun C:ADAA () (cd:008_ApplyDate 3) (princ))
(defun C:-ADA () (cd:008_ApplyDate 10) (princ))
; =========================================================================================== ;
(defun cd:008_Error (Msg)
  (cd:SYS_UndoEnd)
  (princ (strcat "\nApplyDate error: " Msg))
  (if olderr (setq *error* olderr))
  (princ)
)
; =========================================================================================== ;
(defun cd:008_ApplyDate (Mode / olderr *key *key_sub *key_help *tra *l *def *pos %1P val *dcl in dt)
  (setq olderr *error*
        *error* cd:008_Error
        *key "CADPL\\Tools\\ApplyDate"
        *key_sub "\\Formats"
        *key_help "\\HelpStrings"
        *tra (list "PL" "EN") ;LANG;
        *l (cond ( (vl-position (cd:SYS_RW *key "Language" nil) *tra) ) ( 1 ) )
        *def (cd:008_RegData)
        *pos (read (cd:SYS_RW *key "DialogPosition" nil))
        %1P (cd:008_DatePatternList)
        val (nth (atoi (car *def)) (cd:008_FormattedList %1P))
        *dcl Mode
  )
  (cond
    ( (zerop Mode)
      (initget (nth *l (list "Format WyjdŸ" "Format Exit"))) ;LANG;
      (setq in
        (nentsel
          (strcat
            (nth *l (list "\nWybierz" "\nSelect")) ;LANG;
            " ATTRIB/MTEXT/TEXT "
            (nth *l (list "aby wstawiæ datê" "to insert date")) ;LANG;
            " <" val "> ["
            (nth *l (list "Format/WyjdŸ" "Format/Exit")) ;LANG;
            "]: "
          )
        )
      )
      (if (listp in)
        (if (zerop (length in))
          (princ (nth *l (list "\n** Nic nie wskazano ** " "\n** Nothing selected ** "))) ;LANG;
          (if (= 4 (length in))
            (princ
              (strcat
                (nth *l (list "\nNale¿y wskazaæ" "\nPlease select")) ;LANG;
                " ATTRIB/MTEXT/TEXT "
              )
            )
            (progn
              (setq dt (entget (car in)))
              (if
                (member
                  (cdr (assoc 0 dt))
                  (list "ATTRIB" "MTEXT" "TEXT")
                )
                (if
                  (vlax-write-enabled-p
                    (if
                      (= (cdr (assoc 0 dt)) "ATTRIB")
                      (cdr (assoc 330 dt))
                      (car in)
                    )
                  )
                  (progn
                    (cd:SYS_UndoBegin)
                    (vla-put-TextString (vlax-ename->vla-object (car in)) val)
                    (cd:SYS_UndoEnd)
                  )
                  (princ (nth *l (list "\nObiekt na zamkniêtej warstwie " "\nObject on a locked layer"))) ;LANG;
                )
                (princ
                  (strcat
                    (nth *l (list "\nNale¿y wskazaæ" "\nPlease select")) ;LANG;
                    " ATTRIB/MTEXT/TEXT "
                  )
                )
              )
            )
          )
        )
        (if (= in (nth *l (list "Format" "Format"))) ;LANG;
          (progn
            (cd:008_DateFormatDialog (car *def) %1P)
            (C:ADA)
          )
          (princ (nth *l (list "\nZakoñczono " "\nFinished "))) ;LANG;
        )
      )
    )
    ( (= Mode 10)
      (cd:008_CommandLine)
    )
    ( T
      (cd:008_DateFormatDialog (car *def) %1P)
    )
  )
  (if olderr (setq *error* olderr))
  (princ)
)
; =========================================================================================== ;
(defun cd:008_RegData (/ _Sub n h1 h2)
  (defun _Sub ()
    (list ".%DD%MO%YYYY%2" "-%DD%MO%YYYY%2" "/%DD%MO%YYYY%2")
  )
  (setq n 0)
  (setq h1
    (list
      (cons "ADA"  (list "Polecenie g³ówne" "Main command")) ;LANG;
      (cons "ADAF" (list "Okienko Format" "Format window")) ;LANG;
      (cons "ADAE" (list "Okienko Edytuj listê" "Edit list window")) ;LANG;
      (cons "ADAA" (list "Okienko Dodaj datê" "Add date window")) ;LANG;
      (cons "-ADA" (list "Wersja w linii poleceñ" "Command line version")) ;LANG;
    )
  )
  (setq h2
    (list
      (cons "Description" (list "Wstawia datê | ATTRIB/MTEXT/TEXT" "Insert date | ATTRIB/MTEXT/TEXT")) ;LANG;
    )
  )
  (foreach %
    (list
      (cons "AcadLanguage" (cadddr (cd:SYS_AcadInfo)))
      (cons "Command" (cd:STR_ReParse (mapcar (quote car) h1)  ","))
      (cons "DialogPosition" "T")
      (cons "File" "ApplyDate.lsp")
      (cons "Group" "Attribute")
      (cons "Tool" "008")
      (cons "Translations" (cd:STR_ReParse *tra ","))
      (cons "Version" "2.00")

      (cons "Position" "0")
    )
    (if
      (or
        (= (car %) "Command")
        (= (car %) "Version")
      )
      (cd:SYS_RW *key (car %) (cdr %))
      (or
        (cd:SYS_RW *key (car %) nil)
        (cd:SYS_RW *key (car %) (cdr %))
      )
    )
  )
  (if (not (cd:SYS_RW (strcat *key *key_sub) "0" nil))
    (foreach % (_Sub)
      (cd:SYS_RW (strcat *key *key_sub) (itoa (vl-position % (_Sub))) %)
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
        (cd:SYS_RW *key % nil)
      )
    )
    (list "Position")
  )
)
; =========================================================================================== ;
(defun cd:008_DatePatternList (/ f n % res)
  (setq f (strcat *key *key_sub) n 0)
  (while
    (and
      (setq % (cd:SYS_RW f (itoa n) nil))
      (setq res (cons (cd:STR_Parse % "%" nil) res)
            n (1+ n)
      )
    )
  )
  (reverse res)
)
; =========================================================================================== ;
(defun cd:008_FormattedList (Lst)
  (mapcar (quote eval)
    (vl-remove (quote nil)
      (mapcar
        (function
          (lambda (%)
            (if
              (and
                (= (length %) 5)
                (= (type (atoi (last %))) (quote INT))
              )
             (cons 'cd:008_CreateFormattedString %)
            )
          )
        )
        Lst
      )
    )
  )
)
; =========================================================================================== ;
(defun cd:008_CreateFormattedString (Sep A B C Case / res)
  (setq res
    (vl-string-translate "," Sep
      (menucmd
        (strcat
          "M=$(edtime,$(getvar,date),"
          A (if (zerop (strlen A)) "" "\",\"")
          B (if (zerop (strlen B)) "" "\",\"")
          C ")"
        )
      )
    )
  )
  (if (= C "")
    (setq res (vl-string-right-trim Sep res))
  )

  (if (or (not (atoi Case)) (> (atoi Case) 1))
    res
    (if (zerop (atoi Case))
      (strcase res T)
      (strcase res)
    )
  )
)
; =========================================================================================== ;
(defun cd:008_DateFormatDialog (Pos Patt / _SelectSubDialog _SetTiles *sav %2P *dc res ret)
  (defun _SelectSubDialog ()
    (cond
      ( (= *dcl 2)
        (setq ret (cd:008_EditDateFormatDialog Pos %2P))
        (unload_dialog *dc)
        (setq Pos (car ret)
              res (cdr ret)
        )
      )
      ( (= *dcl 3)
        (setq ret (cd:008_AddDateFormatDialog Pos %2P))
        (unload_dialog *dc)
        (setq res ret
              %2P %3P
              %3P nil
        )
      )
    )
  )
  (defun _SetTiles ()
    (mapcar (quote mode_tile)
      (list "OK")
      (cond
        ( (and (not *sav) (= Pos (car *def))) (list 1) )
        ( T (list 0) )
      )
    )
  )
  (if (not *pos) (setq *cd-TempDlgPosition* (list -1 -1)))
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
              (strcat
                "ApplyDate : dialog { label = \""
                (nth *l (list "ApplyDate \\\\ Format" "ApplyDate \\\\ Format")) "\";" ;LANG;
                "  : list_box { key = \"LIST\"; label = \""
                (nth *l (list "&Wybierz:" "&Select:")) "\";" ;LANG;
                "    width = 26; height = 10; allow_accept = true; }"
                "  : button { key = \"EDIT\"; label = \""
                (nth *l (list "&Edytuj listê" "&Edit list")) "\"; }" ;LANG;
                "  OK_CANCEL; }"
                "ApplyDateEdit : dialog { label = \""
                (nth *l (list "ApplyDate \\\\ Edytuj listê" "ApplyDate \\\\ Edit list")) "\";" ;LANG;
                "  : row {"
                "    : list_box { key = \"LIST\"; label = \""
                (nth *l (list "Da&ta:" "Da&te:")) "\";" ;LANG;
                "      width = 20; height = 10; }"
                "    : column {"
                "      spacer_1;"
                "      : B13 { key = \"UP\"; label = \""
                (nth *l (list "W &górê" "&Up")) "\"; }" ;LANG;
                "      : B13 { key = \"DOWN\"; label = \""
                (nth *l (list "W &dó³" "&Down")) "\"; }" ;LANG;
                "      spacer_1;"
                "      : B13 { key = \"ADD\"; label = \""
                (nth *l (list "Doda&j" "&Add")) "\"; }" ;LANG;
                "      : B13 { key = \"DEL\"; label = \""
                (nth *l (list "&Usuñ" "De&lete")) "\"; }" ;LANG;
                "      spacer_1;"
                "    }} OK_CANCEL; }"
                "ApplyDateAdd : dialog { label = \""
                (nth *l (list "ApplyDate \\\\ Dodaj datê" "ApplyDate \\\\ Add date")) "\";" ;LANG;
                "  : column {"
                "    : boxed_column { label = \""
                (nth *l (list "Opcje" "Options")) "\";" ;LANG;
                "      : row {"
                "        : POPUP { key = \"SEP\"; label =  \""
               (nth *l (list "&Separator" "&Separator")) "\"; }" ;LANG;
                "        : POPUP { key = \"FOR\"; label =  \""
               (nth *l (list "&Format" "&Format")) "\"; }" ;LANG;
                "      } SH01; }"
                "    : boxed_column { label = \""
               (nth *l (list "Formatowanie" "Formatting")) "\";" ;LANG;
                "      : row {"
                "        : POPUP { key = \"D\"; width = 15; label = \"\"; }"
                "        : POPUP { key = \"M\"; width = 15; label = \"\"; }"
                "        : POPUP { key = \"Y\"; width = 15; label = \"\"; }"
                "      } SH01; }} OK_CANCEL; errtile; }"
                "OK_CANCEL"
                "  : row { fixed_width = true; alignment = centered;"
                "    : B13 { key = \"OK\"; label = \""
                (nth *l (list "&Ok" "&Ok")) "\" ; is_default = true; }" ;LANG;
                "    : B13 { key = \"CANCEL\"; label = \""
                (nth *l (list "&Anuluj" "&Cancel")) "\" ; is_cancel = true; }}" ;LANG;
                "B13 : button { width = 13; fixed_width = true; horizontal_margin = none; }"
                "POPUP : popup_list { vertical_margin = none; }"
                "SH01 : spacer { height = 0.1; fixed_height = true; }"
              )
            )
            (write-line % fd)
          )
          (not (close fd))
          (< 0 (setq *dc (load_dialog tmp)))
          (if (member *dcl (list 0 1))
            (new_dialog "ApplyDate" *dc ""
              (cond
                (*cd-TempDlgPosition*)
                ( (quote (-1 -1)) )
              )
            )
            T
          )
        )
      )
    )
    (T
      (setq %2P Patt)
      (_SelectSubDialog)
      (cd:DCL_SetList "LIST" (cd:008_FormattedList Patt) Pos)
      (mode_tile "LIST" 2)
      (_SetTiles)
      (action_tile "LIST" "(setq Pos $value) (_SetTiles)")
      (action_tile "EDIT" "(setq Pos (car (cd:008_EditDateFormatDialog Pos %2P))) (_SetTiles)")
      (action_tile "OK" "(setq *cd-TempDlgPosition* (done_dialog 1))")
      (action_tile "CANCEL" "(done_dialog 0)")
      (if (member *dcl (list 0 1))
        (setq res (start_dialog))
      )
      (unload_dialog *dc)
      (if (zerop res)
        (princ (nth *l (list "\nNie zmieniono ustawieñ " "\nSettings unchanged ")))
        (progn
          (princ (nth *l (list "\nZapisano ustawienia " "\nSettings saved "))) ;LANG;
          (cd:SYS_RW *key "Position" Pos)
          (cd:008_UpdateRegDateFormat %2P)
        )
      )
    )
  )
)
; =========================================================================================== ;
(defun cd:008_EditDateFormatDialog (Pos Patt / _UpdateList _SetTiles _Position %3P res opos)
  (defun _UpdateList (Key)
    (_Position Key)
    (cd:DCL_SetList "LIST" (cd:008_FormattedList %3P) Pos)
    (_SetTiles)
  )
  (defun _SetTiles ()
    (if (or (not %3P) (equal Patt %3P))
      (mode_tile "OK" 1)
      (mode_tile "OK" 0)
    )
    (mapcar (quote mode_tile)
      (list "LIST" "UP" "DOWN" "DEL")
      (cond
        ( (not %3P)
          (mode_tile "ADD" 2)
          (list 1 1 1 1)
        )
        ( (= (length %3P) 1)
          (list 0 1 1 0)
        )
        ( (zerop (atoi Pos))
          (mode_tile "LIST" 2)
          (list 0 1 0 0)
        )
        ( (= (atoi Pos) (1- (length %3P)))
          (mode_tile "LIST" 2)
          (list 0 0 1 0)
        )
        ( T (list 0 0 0 0) )
      )
    )
  )
  (defun _Position (Key / tmp)
    (setq tmp (atoi Pos))
    (cond
      ( (= Key "UP")
        (setq tmp (1- tmp))
      )
      ( (= Key "DOWN")
        (setq tmp (1+ tmp))
      )
      ( (= Key "DEL")
        (cond
          ( (not %3P)
            (setq tmp nil)
          )
          ( (>= tmp (length %3P))
            (setq tmp (1- (length %3P)))
          )
          ( T (setq tmp tmp) )
        )
      )
    )
    (if tmp
      (setq Pos (itoa tmp))
      (setq Pos "0")
    )
  )
  (setq %3P Patt
        opos Pos
  )
  (new_dialog "ApplyDateEdit" *dc)
  (cd:DCL_SetList "LIST" (cd:008_FormattedList Patt) Pos)
  (_UpdateList nil)
  (mode_tile "LIST" 2)
  (action_tile "LIST" "(setq Pos $value) (_UpdateList $key)")
  (action_tile "UP" "(setq %3P (cd:LST_MoveItemUp (atoi Pos) %3P)) (_UpdateList $key)")
  (action_tile "DOWN" "(setq %3P (cd:LST_MoveItemDown (atoi Pos) %3P)) (_UpdateList $key)")
  (action_tile "ADD" "(cd:008_AddDateFormatDialog Pos %3P) (_UpdateList $key)")
  (action_tile "DEL" "(setq %3P (cd:LST_RemoveItem (atoi Pos) %3P)) (_UpdateList $key)")
  (action_tile "OK" "(setq *sav T) (done_dialog 1)")
  (action_tile "CANCEL" "(setq Pos opos) (done_dialog 0)")
  (setq res (start_dialog))
  (if (not (zerop res))
    (progn
      (setq %2P %3P)
      (cd:DCL_SetList "LIST" (cd:008_FormattedList %2P) Pos)
    )
  )
  (cons Pos res)
)
; =========================================================================================== ;
(defun cd:008_AddDateFormatDialog (Pos Patt / _Separator _SetupTiles _UpdateTextTile
                                              res sepd sepp ssel forl forp alll
                                              dpos mpos ypos dsel msel ysel )
  (defun _Separator ()
    (list
      (nth *l (list "  <spacja>" "  <space>")) ;LANG;
      (nth *l (list ". <kropka>" ". <dot>")) ;LANG;
      (nth *l (list "- <myœlnik>" "- <dash>")) ;LANG;
      (nth *l (list "/ <ukoœnik>" "/ <slash>")) ;LANG;
    )
  )
  (defun _SetupTiles (Data)
    (if Patt
      (nth Data (nth (atoi Pos) Patt))
      (nth Data (list "-" "DD" "MO" "YYYY" "2"))
    )
  )
  (defun _UpdateTextTile (/ res)
    (setq res (cd:008_CreateFormattedString ssel dsel msel ysel forp))
    (cond
      ( (and Patt (equal (nth (atoi Pos) Patt) (list ssel dsel msel ysel forp)))
        (mode_tile "OK" 1)
        (mode_tile "SEP" 2)
        (set_tile "error"
          (nth *l (list "Format daty ju¿ istnieje" "Date format already exist")) ;LANG:
        )
      )
      ( (= res "")
        (mode_tile "OK" 1)
        (set_tile "error"
          (nth *l (list "Format daty jest niepoprawny" "Date format is incorrect")) ;LANG:
        )
      )
      ( T
        (mode_tile "OK" 0)
        (set_tile "error" (strcat (nth *l (list "Dodaj" "Add")) ": " res)) ;LANG:
      )
    )
  )
  (setq sepd (list " " "." "-" "/")
        sepp (vl-position (_SetupTiles 0) sepd)
        ssel (nth sepp sepd)
        forl (mapcar
               (function
                 (lambda (%)
                   (cd:008_CreateFormattedString "" "" "" "MONTH" %)
                 )
               )
               (list "0" "1" "2")
             )
        forp (_SetupTiles 4)
        alll (list "" "D" "DD" "M" "MO" "MON" "MONTH" "YY" "YYYY")
        dpos (vl-position (_SetupTiles 1) alll)
        mpos (vl-position (_SetupTiles 2) alll)
        ypos (vl-position (_SetupTiles 3) alll)
        dsel (nth dpos alll)
        msel (nth mpos alll)
        ysel (nth ypos alll)
  )
  (new_dialog "ApplyDateAdd" *dc)
  (cd:DCL_SetList "SEP" (_Separator) sepp)
  (cd:DCL_SetList "FOR" forl forp)
  (cd:DCL_SetList "D" alll dpos)
  (cd:DCL_SetList "M" alll mpos)
  (cd:DCL_SetList "Y" alll ypos)
  (_UpdateTextTile)
  (action_tile "SEP" "(setq sepp $value ssel (nth (read sepp) sepd)) (_UpdateTextTile)")
  (action_tile "FOR" "(setq forp $value) (_UpdateTextTile)")
  (action_tile "D" "(setq dpos $value dsel (nth (read dpos) alll)) (_UpdateTextTile)")
  (action_tile "M" "(setq mpos $value msel (nth (read mpos) alll)) (_UpdateTextTile)")
  (action_tile "Y" "(setq ypos $value ysel (nth (read ypos) alll)) (_UpdateTextTile)")
  (action_tile "OK" "(done_dialog 1)")
  (action_tile "CANCEL" "(done_dialog 0)")
  (setq res (start_dialog))
  (if (not (zerop res))
    (progn
      (setq %3P (append Patt (list (list ssel dsel msel ysel forp))))
      (cd:DCL_SetList "LIST" (cd:008_FormattedList %3P) Pos)
    )
  )
  res
)
; =========================================================================================== ;
(defun cd:008_UpdateRegDateFormat (Lst / n l)
  (setq n 0)
  (while (cd:SYS_RW (strcat *key *key_sub) (itoa n) nil)
    (vl-registry-delete
      (strcat "HKEY_CURRENT_USER\\Software" "\\" *key *key_sub)
      (itoa n)
    )
    (setq n (1+ n))
  )
  (foreach % (setq l Lst)
    (cd:SYS_RW (strcat *key *key_sub) (itoa (vl-position % Lst)) (cd:STR_ReParse % "%"))
  )
)
; =========================================================================================== ;
(defun cd:008_CommandLine (/ op)
  (setq op
    (cd:USR_GetKeyWord
      (nth *l (list "\nData:" "\nDate:")) ;LANG;
      (list
        (nth *l (list "Wstaw" "Insert")) ;LANG;
        (nth *l (list "Format" "Format")) ;LANG;
        (nth *l (list "Edytuj" "Edit")) ;LANG;
        (nth *l (list "Dodaj" "Add")) ;LANG;
        (nth *l (list "WyjdŸ" "Exit")) ;LANG;
      )
      (nth *l (list "WyjdŸ" "Exit")) ;LANG;
    )
  )
  (cond
    ( (= op (nth *l (list "Wstaw" "Insert"))) (cd:008_ApplyDate 0)) ;LANG;
    ( (= op (nth *l (list "Format" "Format"))) (cd:008_ApplyDate 1)) ;LANG;
    ( (= op (nth *l (list "Edytuj" "Edit"))) (cd:008_ApplyDate 2)) ;LANG;
    ( (= op (nth *l (list "Dodaj" "Add"))) (cd:008_ApplyDate 3)) ;LANG;
    ( T nil )
  )
)
; =========================================================================================== ;
(princ "\n [ApplyDate v2.00]: (ADA ADAF ADAE ADAA -ADA) ")
(princ)
