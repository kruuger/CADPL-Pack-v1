; =========================================================================================== ;
; ToolTranslator.lsp - Tlumaczenie komentarzy w narzedziach CADPL-Pack /                      ;
;                      Comments translation in the tools CADPL-Pack                           ;
; =========================================================================================== ;
;  Project : CADPL (www.cad.pl, http://forum.cad.pl/cadpl-tool-translator-t78696.html)        ;
;  Ver     : 1.00                                                                             ;
;  Date    : 2012-04-01                                                                       ;
;  Library : CADPL-Pack-v1.lsp                                                                ;
; =========================================================================================== ;
; Historia zmian: / History of changes:                                                       ;
;  2012-04-01 - ver. 1.00 : Pierwsza wersja / First version                                   ;
;  2013-09-17 - ver. 2.00 : zgodnosc z CAD-Util.lsp / compatibility with CAD-Util.lsp | (CPL) ;
; =========================================================================================== ;
; Polecenia: / Commands:                                                                      ;
;  TTRA - Polecenie glowne / Main command                                                     ;
; =========================================================================================== ;
; Funkcje / Functions:                                                                        ;
;  cd:002_CommList     - tworzy liste komentarzy / creates a list of comments                 ;
;  cd:002_Dialog       - glowne okno programu / program widow function                        ;
;  cd:002_Error        - funkcja obslugi bledow / error handling function                     ;
;  cd:002_FileNameOnly - zwraca tylko nazwe pliku gdy sciezka zawiera ponad 60 znakow /       ;
;                        returns only the filename when the path contains more than 60 char.  ;
;  cd:002_OpenToolFile - wybor pliku do tlumacznie / select a file to translate               ;
;  cd:002_RegData      - ustawienia programu / program settings                               ;
;  cd:002_SaveToolFile - zapis do pliku / write to the file                                   ;
;  cd:002_Translator   - glowna funkcja programu / program main function                      ;
;  cd:002_UpdateComm   - aktualizacja komentarzy / update comments                            ;
; =========================================================================================== ;
(if (not cd:ACX_ADoc) (load "CADPL-Pack-v1.lsp" -1))
; =========================================================================================== ;
(defun C:TTRA () (cd:002_ToolTranslator) (princ))
; =========================================================================================== ;
(defun cd:002_Error (Msg)
  (cd:SYS_UndoEnd)
  (princ (strcat "\nToolTranslator error: " Msg))
  (if olderr (setq *error* olderr))
  (princ)
)
; =========================================================================================== ;
(defun cd:002_ToolTranslator (/ olderr *key *key_help *tra *l *def *pos *sav *all *nbr *ln *fl)
  (setq olderr *error*
        *error* cd:002_Error
        *key "CADPL\\Tools\\ToolTranslator"
        *key_help "\\HelpStrings"
        *tra (list "PL" "EN") ;LANG;
        *l (cond ( (vl-position (cd:SYS_RW *key "Language" nil) *tra) ) ( 1 ) )
        *def (cd:002_RegData)
        *pos (read (cd:SYS_RW *key "DialogPosition" nil))
        *sav 1
  )
  (if (not *l) (setq *l 0))
  (if (cd:002_OpenToolFile nil) (cd:002_MainDialog))
  (setq *error* olderr)
)
; =========================================================================================== ;
(defun cd:002_RegData (/ n h1 h2)
  (setq n 0)
  (setq h1
    (list
      (cons "TTRA" (list "Polecenie g³ówne" "Main command")) ;LANG;
    )
  )
  (setq h2
    (list
      (cons "Description" (list "T³umaczenie komentarzy w narzêdziach CADPL-Pack" "Comments translation in the tools CADPL-Pack")) ;LANG;
    )
  )
  (foreach %
    (list
      (cons "AcadLanguage" (cadddr (cd:SYS_AcadInfo)))
      (cons "Command" (cd:STR_ReParse (mapcar (quote car) h1)  ","))
      (cons "DialogPosition" "T")
      (cons "File" "ToolTranslator.lsp")
      (cons "Group" "Other")
      (cons "Tool" "002")
      (cons "Translations" (cd:STR_ReParse *tra ","))
      (cons "Version" "2.00")
      
      (cons "EditPosition" "")
      (cons "LastPath" "")
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
    (list "EditPosition" "LastPath")
  )
)
; =========================================================================================== ;
(defun cd:002_OpenToolFile (Mode / $ReadFile fl_tmp tmp1 tmp2 res)
  (defun $ReadFile (/ n)
    (if (not (zerop (length (setq tmp1 (cd:SYS_ReadFile nil fl_tmp)))))
      (progn
        (setq n -1)
        (setq tmp2
          (mapcar
            (function
              (lambda (%)
                (setq n (1+ n))
                (if (wcmatch % "*;LANG;")
                  (setq res (cons (cons n %) res))
                )
                (cons n %)
              )
            )
            tmp1
          )
        )
        (if (zerop (length res))
          (alert
            (strcat fl_tmp
              (nth *l (list " plik nie zawiera komentarzy" " file not includes comments")) ;LANG;
            )
          )
          (progn
            (setq *def
              (list
                (car *def)
                (cd:SYS_RW *key "LastPath" fl_tmp)
              )
            )
          )
        )
      )
     (alert
       (strcat fl_tmp
         (nth *l (list " plik jest pusty" " file is empty")) ;LANG;
       )
     )
    )
  )
  (if (not (setq fl_tmp (findfile (cadr *def))))
    (if (setq fl_tmp (getfiled (nth *l (list "Wybierz plik do t³umaczenia" "Select file to translate")) "" "*" 0)) ;LANG;
      ($ReadFile)
    )
    (if Mode
      (if (setq fl_tmp (getfiled (nth *l (list "Wybierz plik do t³umaczenia" "Select file to translate")) "" "*" 0)) ;LANG;
        ($ReadFile)
      )
      (if (not ($ReadFile))
        (progn
          (foreach % (list "EditPosition" "LastPath")
            (cd:SYS_RW *key % "")
          )
          (cd:002_Translator)
        )
      )
    )
  )
  (if res
    (setq *all tmp1 *nbr tmp2 *ln res *fl fl_tmp)
     nil
  )
)
; =========================================================================================== ;
(defun cd:002_MainDialog (/ $_UpdateTiles cm_lst cm_pos co_pos cm_dis la lb h bu fw w fd tmp dc)
  (defun $_UpdateTiles ()
    (setq cm_lst (cd:002_CommList)
          cm_pos (if (> (atoi (car *def)) (1- (length cm_lst))) 0 (atoi (car *def)))
          co_pos (car (nth cm_pos cm_lst))
    )
    (setq cm_dis
      (mapcar
        (function
          (lambda (%)
            (caddr %)
          )
        )
        cm_lst
      )
    )
    (set_tile "main" (strcat "ToolTranslator | " (cd:002_FileNameOnly)))
    (cd:DCL_SetList "code" *all co_pos)
    (cd:DCL_SetList "comm" cm_dis cm_pos)
    (set_tile "edit" (nth cm_pos cm_dis))
    (mode_tile "sa" *sav)
  )
  (if (not *pos) (setq *cd-TempDlgPosition* (list -1 -1)))
  (setq la "label=\""
        lb ":list_box{key=\""
        h  "height = 10;"
        bu ":button{key=\""
        fw "fixed_width=true;"
        w  "width=20;"
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
              (strcat "translator:dialog{key=\"main\";" la
                (nth *l (list "ToolTranslator" "ToolTranslator")) ;LANG;
                "\";width = 80;:boxed_row{" la 
                (nth *l (list "Kod programu:" "Program code:")) ;LANG;
                "\";" lb "code\";" h "}}"
                ":boxed_column{" la
                (nth *l (list "Komentarze:" "Comments:")) ;LANG;
                "\";" lb "comm\";" h "}" ":row{:edit_box{key=\"edit\";}"
                bu "ch\";" la
                (nth *l (list "Z&mieñ" "&Change")) ;LANG;
                "\";width=12;" fw "}}spacer;}:row{" fw "alignment=centered;"
                bu "op\";" la
                (nth *l (list "&Otwórz plik" "&Open file")) ;LANG;
                "\";" w fw "}"
                bu "sa\";" la
                (nth *l (list "&Zapisz plik" "&Save file")) ;LANG;
                "\";" w fw "}"
                bu "cl\";" la
                (nth *l (list "Zam&knij" "C&lose")) ;LANG;
                "\";" w fw "is_cancel=true;}}}" 
              )
            )
            (write-line % fd)
          )
          (not (close fd))
          (< 0 (setq dc (load_dialog tmp)))
          (new_dialog "translator" dc ""
            (cond
              (*cd-TempDlgPosition*)
              ( (quote (-1 -1)) )
            )
          )
        )
      )
    )
    (T
      ($_UpdateTiles)
      (action_tile "op" "(if (cd:002_OpenToolFile T) (progn (setq *sav 1) ($_UpdateTiles)))")
      (action_tile "sa" "(cd:002_SaveToolFile)")
      (action_tile "cl" "(setq *cd-TempDlgPosition* (done_dialog 0))")
      (action_tile "comm"
        "(setq *def (list (itoa (setq cm_pos (atoi $value))) (cadr *def))) 
         (set_tile \"edit\"(nth cm_pos cm_dis))
         (set_tile \"code\" (itoa (setq co_pos (car (nth (atoi $value) cm_lst)))))
        "
      )
      (action_tile "ch"
        (vl-prin1-to-string
          (quote
            (progn 
              (if
                (or
                  (zerop (cd:STR_CountChar (get_tile "edit") "\""))
                  (not (zerop (rem (cd:STR_CountChar (get_tile "edit") "\"") 2)))
                )
                (alert (nth *l (list "Niepoprawna sk³adnia" "Incorrect syntax"))) ;LANG;
                (progn
                  (setq cm_lst (cd:002_UpdateComm cm_lst)
                        *sav 0
                  )
                  ($_UpdateTiles)
                )
                
              )
            )
          )
        )
      )
      (start_dialog)
    )
  )
  (if (< 0 dc) (unload_dialog dc))
  (if (setq tmp (findfile tmp)) (vl-file-delete tmp))
  (cd:SYS_RW *key "EditPosition" (itoa cm_pos))
)
; =========================================================================================== ;
(defun cd:002_CommList ()
  (reverse
    (mapcar
      (function
        (lambda (% / st en)
          (setq st (+ (vl-string-search "(list \"" (cdr %)) 6)
                en (1+ (vl-string-search "\")" (cdr %)))
          )
          (list
            (car %)
            (substr (cdr %) 1 st)
            (substr (cdr %) (1+ st) (- en st))
            (substr (cdr %) (1+ en))
          )
        )
      )
      *ln
    )
  )
)
; =========================================================================================== ;
(defun cd:002_UpdateComm (In)
  (setq In
    (mapcar
      (function
        (lambda (%)
          (if (= (vl-position % In) cm_pos)
            (cd:LST_ReplaceItem 2 % (get_tile "edit"))
            %
          )
        )
      )
      (reverse In)
    )
  )
  (setq *ln
    (mapcar
      (function
        (lambda (%)
          (cons
            (car %)
            (strcat (cadr %) (caddr %) (cadddr %))
          )
        )
      )
      In
    )
  )
  (setq *nbr
    (mapcar
      (function
        (lambda (%)
          (if (cdr (assoc (car %) *ln))
            (cons (car %) (cdr (assoc (car %) *ln)))
            %
          )
        )
      )
      *nbr
    )
  )
  (setq *all (mapcar (quote cdr) *nbr))
  In
)
; =========================================================================================== ;
(defun cd:002_SaveToolFile (/ $SaveAlert co)
  (defun $SaveAlert ()
    (if (cd:SYS_WriteFile *fl *all nil)
      (alert
        (strcat *fl "\n"
          (nth *l (list "Plik zapisano pomyœlnie" "File saved successfully")) ;LANG;
        )
      )
      (alert
        (strcat *fl "\n"
          (nth *l (list "Nie mo¿na zapisaæ pliku w okreœlonej lokalizacji" "Cannot save file to the specific location")) ;LANG;
        )
      )
    )
  )
  (setq co
    (strcat
      (vl-filename-directory *fl) "\\"
      (vl-filename-base *fl) "_"
      (cd:SYS_GetDateTime "YYYY-MO-DD")
      (vl-filename-extension *fl)
    )
  )
  (if (findfile co)
    ($SaveAlert)
    (if (vl-file-copy *fl co)
      (progn
        (alert
          (strcat co "\n"
            (nth *l (list "Pomyœlnie utworzono kopiê pliku" "Copy of the file successfully created")) ;LANG;
          )
        )
        ($SaveAlert)
      )
      (alert
        (strcat co "\n"
          (nth *l (list "Nie mo¿na utworzyæ kopii pliku" "Unable to create a copy of the file")) ;LANG;
        )
      )
    )
  )
)
; =========================================================================================== ;
(defun cd:002_FileNameOnly (/ res)
  (setq res (cadr *def))
  (if (> (strlen res) 60)
    (strcat "...\\" (vl-filename-base res) (vl-filename-extension res))
    res
  )
)
; =========================================================================================== ;
(princ "\n [ToolTranslator v2.00]: (TTRA) ")
(princ)
