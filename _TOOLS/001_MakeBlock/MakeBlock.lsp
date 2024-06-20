; =========================================================================================== ;
; MakeBlock.lsp - Tworzy blok (nazwany, nazwany automatycznie i anonimowy) /                  ;
;                 Creates block (named, automatically named and anonymous)                    ;
; =========================================================================================== ;
;  Project : CADPL (www.cad.pl, http://forum.cad.pl/cadpl-utworz-blok-t78523.html)            ;
;  Ver     : 1.00                                                                             ;
;  Date    : 2012-03-13                                                                       ;
;  Library : CADPL-Pack-v1.lsp                                                                ;
; =========================================================================================== ;
; Historia zmian: / History of changes:                                                       ;
;  2012-03-10 - ver. 1.00 : Pierwsza wersja / First version                                   ;
;  2013-09-17 - ver. 2.00 : zgodnosc z CAD-Util.lsp / compatibility with CAD-Util.lsp | (CPL) ;
;  2014-10-07 - ver. 2.01 : zmiana automatycznej nazwy bloku na "YYYYMODD-HHMMSMSEC" /        ;
;                           change auto block name format to "YYYYMODD-HHMMSMSEC"             ;
; =========================================================================================== ;
; Polecenia: / Commands:                                                                      ;
;  MB   - Polecenie glowne tworzenia bloku / Main command to create block                     ;
;  MBA  - Tworzy blok anonimowy / Creates an anonymous block                                  ;
;  MBAN - Tworzy blok z automatyczna nazwa / Creates a block with an automatic name           ;
;  MBN  - Tworzy blok z podana nazwa / Creates a block with given name                        ;
;  MBO  - Opcje programu (dcl) / Program options (dcl)                                        ;
; =========================================================================================== ;
; Funkcje / Functions:                                                                        ;
;  cd:001_DynamicFilter    - tworzy filtr zbioru wskazan / creates selection set filter       ;
;  cd:001_Error            - funkcja obslugi bledow / error handling function                 ;
;  cd:001_GetBlockName     - pobiera nazwe bloku / gets block name                            ;
;  cd:001_GetUserData      - pobiera dane od uzytkownika / gets data from user                ;
;  cd:001_Make-InsertBlock - tworzy definicje i odniesienie bloku /                           ;
;                            creates definitions and block reference                          ;
;  cd:001_MakeBlock        - glowna funkcja programu / program main function                  ;
;  cd:001_MakeFilterStr    - tworzy lancuch tekstowy filtra / creates a filter string         ;
;  cd:001_AutoBlockName    - tworzy automatyczna nazwa bloku / creates automatic block name   ;
;  cd:001_RegData          - ustawienia programu / program settings                           ;
;  cd:001_SetupDlg         - obsluga okna dcl / dcl support                                   ;
; =========================================================================================== ;
(if (not cd:ACX_ADoc) (load "CADPL-Pack-v1.lsp" -1))
; =========================================================================================== ;
(defun C:MB   () (cd:001_MakeBlock -1) (princ))
(defun C:MBA  () (cd:001_MakeBlock  1) (princ))
(defun C:MBAN () (cd:001_MakeBlock  2) (princ))
(defun C:MBN  () (cd:001_MakeBlock  3) (princ))
(defun C:MBO  () (cd:001_MakeBlock  0) (princ))
; =========================================================================================== ;
(defun cd:001_Error (Msg)
  (cd:SYS_UndoEnd)
  (princ (strcat "\nMakeBlock error: " Msg))
  (if olderr (setq *error* olderr))
  (princ)
)
; =========================================================================================== ;
(defun cd:001_MakeBlock (Mode / *key *key_help *tra *l *def *pos ts bname pt res ss olderr)
  (setq olderr *error*
        *error* cd:001_Error
        *key "CADPL\\Tools\\MakeBlock"
        *key_help "\\HelpStrings"
        *tra (list "PL" "EN") ;LANG;
        *l (cond ( (vl-position (cd:SYS_RW *key "Language" nil) *tra) ) ( 1 ) )
        *def (cd:001_RegData)
        *pos (read (cd:SYS_RW *key "DialogPosition" nil))
  )
  (if (not *l) (setq *l 0))
  (cond
    ( (zerop Mode)
      (princ (nth *l (list "MakeBlock - Opcje\n" "MakeBlock - Options\n"))) ;LANG;
      (cd:001_SetupDlg)
    )
    ( T
      (princ
        (cond
          ( (= Mode 1)
            (nth *l (list "Utwórz blok anonimowy\n" "Make annonymous block\n")) ;LANG;
          )
          ( (= Mode 2)
            (strcat
              (nth *l (list "Utwórz blok " "Make block ")) ;LANG;
              " (" (cd:001_AutoBlockName) ")\n"
            )
          )
          ( (= Mode 3)
            (strcat
              (nth *l (list "Utwórz blok " "Make block ")) ;LANG;
              "\n"
            )
          )
          ( T "")
        )
      )
      (if
        (if (>= Mode 1) T (setq ts (cd:001_GetUserData)))
        (if (/= ts "")
          (if
            (setq bname
              (if (= Mode 1)
                "*U"
                (cd:SYS_CheckError
                  (list
                    cd:001_GetBlockName
                    (cadr *def)
                    (cond
                      ( (= Mode 2) 1)
                      ( (= Mode 3) 0)
                      (T (caddr *def))
                    )
                  )
                )
              )
            )
            (if
              (setq pt
                (cd:USR_GetPoint
                  (nth *l (list "\nOkreœl punkt bazowy wstawienia: " "\nSpecify insertion base point: ")) ;LANG;
                  1 nil
                )
              )
              (if
                (setq ss
                  (cd:SYS_CheckError (list cd:001_DynamicFilter (car *def)))
                )
                (progn
                  (cd:SYS_UndoBegin)
                  (setq res (cd:001_MakeInsertBlock bname pt ss))
                  (cd:SYS_UndoEnd)
                  (princ
                    (strcat
                      (nth *l (list "\nUtworzono blok: " "\nCreated block: ")) ;LANG;
                      res
                    )
                  )
                )
                (princ (nth *l (list "Nic nie wybrano" "Nothing selected"))) ;LANG;
              )
              (princ (nth *l (list "\n** Anulowano **" "\n** Cancelled **"))) ;LANG;
            )
            (princ (nth *l (list "\n** Anulowano **" "\n** Cancelled **"))) ;LANG;
          )
          (princ (nth *l (list "Zakoñczono" "Finished"))) ;LANG;
        )
        (princ (nth *l (list "\n** Anulowano **" "\n** Cancelled **"))) ;LANG;
      )
    )
  )
  (setq *error* olderr)
)
; =========================================================================================== ;
(defun cd:001_SetupDlg (/ _TgSet _TgSel bit lg tnm lr rn r h b v rb la p fd tmp dc res)
  (defun _TgSet ()
    (foreach % (if (= 128 bit) (cons 128 lr) (cd:CAL_BitList bit))
      (set_tile (itoa %) "1")
    )
    (foreach % lr
      (mode_tile (itoa %) (if (= 128 bit) 1 0))
    )
  )
  (defun _TgSel (Key Val)
    (setq bit
      (if (zerop (read Val))
        (- bit (read Key))
        (+ bit (read Key))
      )
    )
  )
  (if (not *pos) (setq *cd-TempDlgPosition* (list -1 -1)))
  (setq bit (car *def)
        tnm (caddr *def)
        lr (cd:CAL_BitList 127)
        rn (list "nus" "nau")
        r ": radio_button { key = \""
        h "fixed_width = true;"
        b ": boxed_row { label = \""
        v "width = 12; horizontal_margin = none;"
        rb ": retirement_button {"
        la "label = \""
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
              (strcat "makeblocksetup:dialog{" la
                (nth *l (list "MakeBlock - Opcje" "MakeBlock - Options")) "\";" b        ;LANG;
                (nth *l (list "Nazwa bloku:" "Block Name:")) "\";" h r "nus\";" la       ;LANG;
                (nth *l (list "Z&apytaj" "&Ask ")) "\";" h "}" r "nau\";" la             ;LANG;
                (nth *l (list "A&utomatycznie" "A&utomatically")) "\";" h "}}" b         ;LANG;
                (nth *l (list "Pomiñ w wyborze:" "Skip the selection:")) "\";:column{" h ;LANG;
                (apply
                  (quote strcat)
                  (mapcar
                    (function
                      (lambda (%1 %2)
                        (strcat ":toggle { key = \"" (itoa %1) "\";" la (nth *l %2) "\";" "}")
                      )
                    )
                    (cd:CAL_BitList 255)
                    (list
                      (list "&Wymiary" "&Dimensions")
                      (list "&Tolerancje" "&Tolerances")
                      (list "Wie&lolinie odniesienia" "&Multileaders")
                      (list "&Kreskowania" "&Hatches")
                      (list "&Proste" "Construction &lines")
                      (list "Pó³p&roste" "&Rays")
                      (list "Ta&bele" "Ta&bles")
                      (list "&Zaznacz wszystko" "&Select all")
                    )
                  )
                )
                "}}"
                ":row { width = 25;" h "alignment = centered;"
                rb la "OK\"; key = \"accept\"; is_default = true;" v "}" rb la
                (nth *l (list "&Anuluj" "&Cancel")) "\";" ;LANG;
                "key = \"cancel\"; is_cancel = true;" v "}}}"
              )
            )
            (write-line % fd)
          )
          (not (close fd))
          (< 0 (setq dc (load_dialog tmp)))
          (new_dialog "makeblocksetup" dc ""
            (cond
              (*cd-TempDlgPosition*)
              ( (quote (-1 -1)) )
            )
          )
        )
      )
    )
    ( T
      (_TgSet)
      (foreach % lr
        (action_tile (itoa %) "(_TgSel $key $value)")
      )
      (set_tile (nth tnm rn) "1")
      (foreach % rn
        (action_tile % "(setq tnm (vl-position $key rn))")
      )
      (action_tile "128" "(setq bit (nth (read $value) (list 127 128))) (_TgSet)")
      (action_tile "accept" "(setq *cd-TempDlgPosition* (done_dialog 1))")
      (action_tile "cancel" "(setq *cd-TempDlgPosition* (done_dialog 0))")
      (setq res (start_dialog))
    )
  )
  (if (< 0 dc) (unload_dialog dc))
  (if (setq tmp (findfile tmp)) (vl-file-delete tmp))
  (if (not (zerop res))
    (progn
      (cd:SYS_RW *key "Filter" (itoa bit))
      (cd:SYS_RW *key "TypeName" (itoa tnm))
      (setq *def (list bit (cadr *def) tnm))
      (princ (nth *l (list "Zapisano ustawienia " "Settings saved "))) ;LANG;
    )
    (princ (nth *l (list "Nie zmieniono ustawieñ " "Settings unchanged "))) ;LANG;
  )
)
; =========================================================================================== ;(defun cd:001_MakeInsertBlock (Name Pins Obj / bdef bn sse ssv zdir obj)  (setq bdef (vla-add (cd:ACX_Blocks) (vlax-3d-Point (list 0 0 0)) Name)        bn (vla-get-name bdef)        sse (cd:SSX_Convert Obj 1)        ssv (cd:SSX_Convert Obj 2)        zdir (trans (list 0 0 1) 1 0 T)  )  (foreach % sse    (vla-TransformBy % (cd:CON_TransMatrix 0))    (vla-move %      (vlax-3d-point pins)      (vlax-3d-point (list 0 0 0))    )  )  (vla-CopyObjects (cd:ACX_ADoc) ssv bdef)  (foreach % sse (vla-Delete %))  (setq obj (cd:BLK_InsertBlock Pins bn nil 0 nil))  (vla-put-normal obj (vlax-3d-point zdir))  bn)
; =========================================================================================== ;
(defun cd:001_RegData (/ n h1 h2)
  (setq n 0)
  (setq h1
    (list
      (cons "MB"   (list "Polecenie g³ówne" "Main command")) ;LANG;
      (cons "MBA"  (list "Tworzy blok anonimowy" "Creates an anonymous block")) ;LANG;
      (cons "MBAN" (list "Tworzy blok z automatyczn¹ nazw¹" "Creates a block with an automatic name")) ;LANG;
      (cons "MBN"  (list "Tworzy blok z podan¹ nazw¹" "Creates a block with given name")) ;LANG;
      (cons "MBO"  (list "Opcje programu (dcl)" "Program options (dcl)")) ;LANG;
    )
  )
  (setq h2
    (list
      (cons "Description" (list "Tworzy blok" "Creates block")) ;LANG;
    )
  )
  (foreach %
    (list
      (cons "AcadLanguage" (cadddr (cd:SYS_AcadInfo)))
      (cons "Command" (cd:STR_ReParse (mapcar (quote car) h1)  ","))
      (cons "DialogPosition" "T")
      (cons "File" "MakeBlock.lsp")
      (cons "Group" "Block")
      (cons "Tool" "001")
      (cons "Translations" (cd:STR_ReParse *tra ","))
      (cons "Version" "2.01")

      (cons "Filter" "128")
      (cons "TypeBlock" "0")
      (cons "TypeName" "0")
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
        (atoi (cd:SYS_RW *key % nil))
      )
    )
    (list "Filter" "TypeBlock" "TypeName")
  )
)
; =========================================================================================== ;
(defun cd:001_GetUserData (/ msg in)
  (setq msg
    (list
      (nth *l (list "Anonimowy" "Anonymous")) ;LANG;
      (nth *l (list "Nazwa" "Name"))          ;LANG;
      (nth *l (list "Opcje" "Options"))       ;LANG;
      (nth *l (list "WyjdŸ" "Exit"))          ;LANG;
    )
  )
  (setq in
    (cd:USR_GetKeyWord
      (nth *l (list "\nUtwórz blok" "\nCreate block")) ;LANG;
      msg
      (nth (cadr *def) msg)
    )
  )
  (cond
    ( (member in
        (list
          (nth *l (list "Anonimowy" "Anonymous")) ;LANG;
          (nth *l (list "Nazwa" "Name"))          ;LANG;
        )
      )
      (cd:SYS_RW *key "TypeBlock" (itoa (vl-position in msg)))
      (setq *def (cd:LST_ReplaceItem 1 *def (vl-position in msg)))
    )
    ( (= in (caddr msg))
      (cd:001_SetupDlg)
      (princ "\n")
      (cd:001_GetUserData)
    )
    ( (= in (cadddr msg)) "")
    ( T nil)
  )
)
; =========================================================================================== ;
(defun cd:001_MakeFilterStr (Bit)
  (if (< 0 Bit 129)
    (progn
      (if (= Bit 128) (setq Bit 127))
      (cd:STR_ReParse
        (mapcar
          (function
            (lambda (%)
              (cdr
                (assoc %
                  (mapcar
                    (quote cons)
                    (cd:CAL_BitList 127)
                    (list
                      "DIMENSION" "TOLERANCE" "MULTILEADER"
                      "HATCH" "XLINE" "RAY" "ACAD_TABLE"
                    )
                  )
                )
              )
            )
          )
          (cd:CAL_BitList bit)
        )
        ","
      )
    )
  )
)
; =========================================================================================== ;
(defun cd:001_AutoBlockName (/ bn res n)
  (setq bn (cd:SYS_GetDateTime "YYYYMODD-HHMMSMSEC")
        res bn
        n 1
  )
  (while (tblsearch "BLOCK" res)
    (setq res (strcat bn "." (itoa n))
          n (1+ n)
    )
  )
  res
)
; =========================================================================================== ;
(defun cd:001_DynamicFilter (Obj / xr)
  (ssget "_:L"
    (list
      (cons -4 "<NOT")
      (cons 0
        (strcat
          (cd:STR_ReParse
            (list "*UNDERLAY" "OLE2FRAME" "IMAGE" "VIEWPORT")
            ","
          )
          (if (zerop (caddr *def)) ",ATTDEF" "")
          (if
            (not (zerop Obj))
            (strcat "," (cd:001_MakeFilterStr Obj))
            ""
          )
        )
      )
      (cons -4 "NOT>")
      (cons -4 "<NOT")
        (cons 2
          (if (not (setq xr (cd:STR_ReParse (cd:BLK_GetXrefs) ",")))
            ""
            xr
          )
        )
      (cons -4 "NOT>")
    )
  )
)
; =========================================================================================== ;
(defun cd:001_GetBlockName (TypeBlock TypeName / res)
  (if (zerop TypeBlock)
    (setq res "*U")
    (if (zerop TypeName)
      (while
        (or
          (=
            (setq res
               (getstring T
                 (nth *l (list "\nPodaj nazwê nowego bloku: " "\nEnter new block name: ")) ;LANG;
               )
             )
             ""
          )
          (not (snvalid res))
          (tblsearch "BLOCK" res)
        )
        (princ
          (nth *l (list "\n** Z³a nazwa bloku lub blok ju¿ istnieje **" "\n** Invalid block name or block already exist **")) ;LANG;
        )
      )
      (setq res (cd:001_AutoBlockName))
    )
  )
  res
)
; =========================================================================================== ;
(princ "\n [MakeBlock v2.01]: (MB MBA MBAN MBN MBO) ")
(princ)
