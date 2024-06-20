; =========================================================================================== ;
; RedefineBlockProperties.lsp - Zmiana definicji bloku / Change block definition              ;
; =========================================================================================== ;
;  Project : CADPL (http://forum.cad.pl/cadpl-zmiana-definicji-bloku-t80958.html)             ;
;  Ver     : 1.00                                                                             ;
;  Date    : 2013-05-25                                                                       ;
;  Library : CADPL-Pack-v1.lsp                                                                ;
; =========================================================================================== ;
; Historia zmian: / History of changes:                                                       ;
;  2013-05-25 - ver. 1.00 : Pierwsza wersja / First version                                   ;
;  2013-06-07 - ver. 1.01 : - definicja bloku zawsze na warstwie 0 /                          ;
;                             definition block always on layer 0                              ;
;                           - lista rodzajow linii zalezna od zmiennej LWUNITS /              ;
;                             list of linetypes dependent from LWUNITS variable               ;
;                           - poprawione drobne bledy / fixed minor bugs                      ;
; =========================================================================================== ;
; Polecenia: / Commands:                                                                      ;
;  RBP  - Polecenie glowne / Main command                                                     ;
;  RBPS - Zmiana definicji wybranych blokow / Changing the definition of the selected blocks  ;
;  -RBP - Wersja w linii polecen / Command line version                                       ;
; =========================================================================================== ;
; Funkcje / Functions:                                                                        ;
;  cd:009_BlockNameFilter         - filtr ssget (bez xrefs) / ssget filter (no xrefs)         ;
;  cd:009_ColorList               - lista kolorow (dcl) / list of colors (dcl)                ;
;  cd:009_CommandLine             - wersja w linii polecen / command line version             ;
;  cd:009_Error                   - funkcja obslugi bledow / error handling function          ;
;  cd:009_GetBlocks               - lista blokow / list of blocks                             ;
;  cd:009_GetLayers               - lista warstw / list of layers                             ;
;  cd:009_LinetypeList            - list typow linii / list of linetypes                      ;
;  cd:009_LineweightList          - list szerokosci linii / list of lineweigths               ;
;  cd:009_MainDialog              - glowne okno programu / program main window                ;
;  cd:009_RedefineBlockProperties - glowna funkcja programu / program main function           ;
;  cd:009_RegData                 - ustawienia programu / program settings                    ;
;  cd:009_UpdateBlockList         - aktualizuje liste blokow / updates the list of blocks     ;
;  cd:009_UpdateObjects           - aktualizuje obiekty / updates the objects                 ;
; =========================================================================================== ;
(if (not cd:ACX_ADoc) (load "CADPL-Pack-v1.lsp" -1))
; =========================================================================================== ;
(defun C:RBP  () (cd:009_RedefineBlockProperties 0) (princ))
(defun C:RBPS () (cd:009_RedefineBlockProperties 1) (princ))
(defun C:-RBP () (cd:009_RedefineBlockProperties 10) (princ))
; =========================================================================================== ;
(defun cd:009_Error (Msg)
  (cd:SYS_UndoEnd)
  (princ (strcat "\nRedefineBlockProperties error: " Msg))
  (if olderr (setq *error* olderr))
  (princ)
)
; =========================================================================================== ;
(defun cd:009_RedefineBlockProperties (Mode / olderr *key *l *def *pos blst *bnam *bann ss)
  (setq olderr *error*
        *error* cd:009_Error
        *key "CADPL\\Tools\\RedefineBlockProperties"
        *l (cond ( (vl-position (cd:SYS_RW *key "Language" nil) (list "PL" "EN")) ) ( 1 ) ) ;LANG;
        *def (cd:009_RegData)
        *pos (read (cd:SYS_RW *key "DialogPosition" nil))
  )
  (setq blst (cd:009_GetBlocks)
        *bnam (car blst)
        *bann (cadr blst)
  )
  (if (and blst (or *bnam *bann))
    (progn
      (cond
        ( (zerop Mode)
          (cd:009_MainDialog)
        )
        ( (= Mode 1)
          (if (ssget (list (cons 0 "INSERT") (cd:009_BlockNameFilter)))
            (progn
              (setq *bnam nil *bann nil)
              (vlax-for %
                (setq ss
                  (vla-get-activeselectionset
                    (vla-get-activedocument
                      (vlax-get-acad-object)
                    )
                  )
                )
                (setq na (vla-get-EffectiveName %))
                (if (= (substr na 1 2) "*U")
                   (setq *bann (cons na *bann))
                   (if (not (member na *bnam))
                     (setq *bnam (cons na *bnam))
                   )
                )
              )
              (vla-delete ss)
              (cd:009_MainDialog)
            )
            (princ (nth *l (list "\nNic nie wybrano " "\nNothing selected "))) ;LANG;
          )
        )
        ( (= Mode 10)
          (cd:009_CommandLine)
        )
        ( T
          (princ T)
        )
      )
    )
    (princ (nth *l (list "\nBrak bloków w rysunku" "\nNo blocks in a drawing "))) ;LANG;
  )
  (if olderr (setq *error* olderr))
  (princ)
)
; =========================================================================================== ;
(defun cd:009_CommandLine (/ op)
  (setq op
    (cd:USR_GetKeyWord
      (nth *l (list "\nBlok:" "\nBlock:")) ;LANG;
      (list
        (nth *l (list "WYbierz" "Select")) ;LANG;
        (nth *l (list "Wszystkie" "All")) ;LANG;
      )
      (nth *l (list "Wszystkie" "All")) ;LANG;
    )
  )
  (cond
    ( (= op (nth *l (list "WYbierz" "Select"))) (cd:009_RedefineBlockProperties 1)) ;LANG;
    ( (= op (nth *l (list "Wszystkie" "All"))) (cd:009_RedefineBlockProperties 0)) ;LANG;
    ( T nil )
  )
)
; =========================================================================================== ;
(defun cd:009_RegData ()
  (foreach %
    (list
      (cons "Command" "RBP,RBPS,-RBP")
      (cons "DialogPosition" "T")
      (cons "File" "RedefineBlockProperties.lsp")
      (cons "Group" "Block")
      (cons "Language" (cadddr (cd:SYS_AcadInfo)))
      (cons "Tool" "009")
      (cons "Version" "1.01")
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
)
; =========================================================================================== ;
(defun cd:009_MainDialog (/ _Sub _SetTiles _CheckScale fd tmp dc res clst llst lwlst
                            bpos tall tann tcol cpos tlay lpos tlt ltpos tsca sbox tlw lwpos blst le)
  (defun _Sub ()
    (cond
      ( (and *bnam *bann)
        (mode_tile "TANN" 0)
        (set_tile "TANN" "1")
        1
      )
      ( (and (not *bnam) *bann)
        (mode_tile "TANN" 1)
        (set_tile "TANN" "1")
        1
      )
      ( (and *bnam (not *bann))
        (mode_tile "TANN" 1)
        (set_tile "TANN" "0")
        0
      )
    )
  )
  (defun _SetTiles ()
    (mapcar (quote mode_tile)
      (list "BLST"   "TCOL" "CLST" "TLAY" "LLST" "TLT" "LTLST" "TSCA" "SBOX" "TLW" "LWLST"   "OK")
      (cond
        ( (and (zerop tall) (zerop (length (cd:CON_Value2List (setq bpos (get_tile "BLST"))))))
          (list 0   1 1 1 1 1 1 1 1 1 1   1)
        )
        ( (and (zerop tcol) (zerop tlay) (zerop tlw) (zerop tsca))
          (list tall   0 (abs (1- tcol)) 0 (abs (1- tlay)) 0 (abs (1- tlt)) 0 (abs (1- tsca)) 0 (abs (1- tlw))   1)
        )
        ( (not (zerop tall))
          (list 1   0 (abs (1- tcol)) 0 (abs (1- tlay)) 0 (abs (1- tlt)) 0 (abs (1- tsca)) 0 (abs (1- tlw))   0)
        )
        ( T
          (list 0   0 (abs (1- tcol)) 0 (abs (1- tlay)) 0 (abs (1- tlt)) 0 (abs (1- tsca)) 0 (abs (1- tlw))   0)
        )
      )
    )
  )
  (defun _CheckScale (Val / res)
    (if
      (or
        (not (setq res (distof Val 3)))
        (<= res 0)
      )
      (setq res sbox)
    )
    (set_tile "SBOX" (cd:CON_Real2Str res 2 nil))
    res
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
                "RedBlockProp : dialog { label = \"RedefineBlockProperties\";"
                "  : row {"
                "    : boxed_column { label = \""
                (nth *l (list "Bloki w rysunku" "Blocks in drawing")) "\";" ;LANG;
                "      : list_box { key = \"BLST\"; label = \""
                (nth *l (list "&Wybierz:" "&Select:")) "\";" ;LANG;
                "        width = 25; height = 17; multiple_select = true; vertical_margin = none; }"
                "      : toggle { key = \"TALL\"; label = \""
                (nth *l (list "Wybierz w&szystkie" "S&elect all")) "\"; }" ;LANG;
                "      : toggle { key = \"TANN\"; label = \""
                (nth *l (list "&Poka¿ anonimowe" "S&how annonymous")) "\"; }  }" ;LANG;
                "    : column {"
                "      : boxed_column { label = \""
                (nth *l (list "Cechy" "Properties")) "\";" ;LANG;
                "        : toggle { key = \"TCOL\"; label = \""
                (nth *l (list "&Kolor:" "Co&lor:")) "\"; }" ;LANG;
                "        : _POPUP { key = \"CLST\"; }"
                "        : image { key = \"CIM\"; height = 0.2; vertical_margin = none; } spacer;"
                "        : toggle { key = \"TLAY\"; label = \""
                (nth *l (list "Wa&rstwa:" "L&ayer:")) "\"; }" ;LANG;
                "        : _POPUP { key = \"LLST\"; } spacer;"
                "        : toggle { key = \"TLT\"; label = \""
                (nth *l (list "Ro&dzaj linii:" "Line&type:")) "\"; }" ;LANG;
                "        : _POPUP { key = \"LTLST\"; } spacer;"
                "        : toggle { key = \"TSCA\"; label = \""
                (nth *l (list "Ska&la rodzaju linii:" "Linetype sca&le:")) "\"; }" ;LANG;
                "        : edit_box { key = \"SBOX\"; vertical_margin = none; } spacer;"                
                "        : toggle { key = \"TLW\"; label = \""
                (nth *l (list "S&zerokoœæ linii:" "Line&weight:")) "\"; }" ;LANG;
                "        : _POPUP { key = \"LWLST\"; } spacer;"
                "      } OK_CANCEL; }}}"
                "_TOGGLE : toggle { vertical_margin = none; }"
                "_POPUP : popup_list { vertical_margin = none; }"
                "B13 : button { width = 13; fixed_width = true; horizontal_margin = none; }"
                "OK_CANCEL : row { fixed_width = true; alignment = centered;"
                "    : B13 { key = \"OK\"; is_default = true; label = \""
                (nth *l (list "&Ok" "&Ok")) "\"; }" ;LANG;
                "    : B13 { key = \"CANCEL\"; is_cancel = true; label = \""
                (nth *l (list "&Anuluj" "&Cancel")) "\"; }}" ;LANG;
              )
            )
            (write-line % fd)
          )
          (not (close fd))
          (< 0 (setq dc (load_dialog tmp)))
          (new_dialog "RedBlockProp" dc ""
            (cond
              (*cd-TempDlgPosition*)
              ( (quote (-1 -1)) )
            )
          )
        )
      )
    )
    (T
      (setq clst (cd:009_ColorList)
            llst (acad_strlsort (cd:009_GetLayers))
            ltlst (cd:009_LinetypeList)
            lwlst (cd:009_LineweightList)
      )
      (setq bpos "0"
            tall 0
            tann (_Sub)
            tcol 1
            cpos 256
            tlay 1
            lpos (vl-position "0" llst)
            tlt 0
            ltpos 0
            tsca 0
            sbox 1.
            tlw 0
            lwpos 0
      )
      (cd:DCL_SetList "BLST" (setq blst (cd:009_UpdateBlockList tall tann)) bpos)
      (cd:DCL_FillColorList "CLST" clst (itoa cpos))
      (cd:DCL_FillColorImage "CIM" cpos)
      (cd:DCL_SetList "LLST" llst lpos)
      (cd:DCL_SetList "LTLST" ltlst 0)
      (set_tile "SBOX" (cd:CON_Real2Str sbox 2 nil))
      (cd:DCL_SetList "LWLST" lwlst lwpos)
      (set_tile "TCOL" "1")
      (set_tile "TLAY" "1")

      (_SetTiles)

      (action_tile "BLST" "(setq bpos $value) (_SetTiles)")
      (action_tile "TALL" "(setq tall (atoi $value)) (cd:009_UpdateBlockList tall tann) (_SetTiles)")
      (action_tile "TANN" "(setq tann (atoi $value)) (setq blst (cd:009_UpdateBlockList tall tann)) (_SetTiles)")

      (action_tile "TCOL" "(setq tcol (atoi $value)) (_SetTiles)")
      (action_tile "CLST" "(setq cpos (atoi (cd:DCL_ChangeColorList \"CLST\" \"CIM\" clst $value (itoa cpos))))")
      (action_tile "TLAY" "(setq tlay (atoi $value)) (_SetTiles)")
      (action_tile "LLST" "(setq lpos (atoi $value))")
      (action_tile "TLT" "(setq tlt (atoi $value)) (_SetTiles)")
      (action_tile "LTLST" "(setq ltpos (atoi $value))")
      (action_tile "TSCA" "(setq tsca (read $value)) (_SetTiles)")
      (action_tile "SBOX" "(setq sbox (_CheckScale $value))")
      (action_tile "TLW" "(setq tlw (atoi $value)) (_SetTiles)")
      (action_tile "LWLST" "(setq lwpos (atoi $value))")

      (action_tile "OK" "(done_dialog 1)")
      (action_tile "CANCEL" "(done_dialog 0)")
      (setq res (start_dialog))
    )
  )
  (if (< 0 dc) (unload_dialog dc))
  (if (setq tmp (findfile tmp)) (vl-file-delete tmp))
  (cond
    ( (= res 1)
      (cd:SYS_UndoBegin)
      (setq le (itoa (cd:009_UpdateObjects)))
      (cd:SYS_UndoEnd)
      (vla-regen (cd:ACX_ADoc) acActiveViewport)
      (princ
      	(strcat
          (nth *l (list "\nZmieniono " "\nChanged "))
          le
          (nth *l (list " bloków " " blocks "))
        )
      )
    )
    ( T nil )
  )
)
; =========================================================================================== ;
(defun cd:009_GetBlocks ()
  (list
    (cd:SYS_CollList "BLOCK" (+ 1 2 4 8))
    (vl-remove-if-not
      (function
        (lambda (%)
          (= "U" (substr % 2 1)))
      )
      (vl-remove-if
        (function
          (lambda (%)
            (cd:XDT_GetXData
              (cdr (assoc 330 (entget (tblobjname "BLOCK" %))))
              "AcDbBlockRepBTag"
            )
          )
        )
        (cd:SYS_CollList "BLOCK" (+ 1 4 16))
      )
    )
  )
)
; =========================================================================================== ;
(defun cd:009_GetLayers ()
  (cd:SYS_CollList "LAYER" (+ 4))
)
; ====================================================================================== ;
(defun cd:009_ColorList ()
  (list
    (nth *l (list "JakWarstwa" "ByLayer")) ;LANG;
    (nth *l (list "JakBlok" "ByBlock")) ;LANG;
    (nth *l (list "1 - Czerwony" "1 - Red")) ;LANG;
    (nth *l (list "2 - ¯ó³ty" "2 - Yellow")) ;LANG;
    (nth *l (list "3 - Zielony" "3 - Green")) ;LANG;
    (nth *l (list "4 - B³êkitny" "4 - Cyan")) ;LANG;
    (nth *l (list "5 - Niebieski" "5 - Blue")) ;LANG;
    (nth *l (list "6 - Fioletowy" "6 - Magenta")) ;LANG;
    (nth *l (list "7 - Bia³y" "7 - White")) ;LANG;
    (nth *l (list "Inny..." "Other...")) ;LANG;
  )
)
; =========================================================================================== ;
(defun cd:009_LinetypeList ()
  (append
    (list
      (nth *l (list "JakWarstwa" "ByLayer")) ;LANG;
      (nth *l (list "JakBlok" "ByBlock")) ;LANG;
    )
    (acad_strlsort
      (vl-remove-if
        (function
          (lambda (%)
            (or
              (= (strcase "ByLayer") (strcase %)) ;LANG;
              (= (strcase "ByBlock") (strcase %)) ;LANG;
            )
          )
        )
        (cd:SYS_CollList "LTYPE" (+ 4))
      )
    )
  )
)
; ====================================================================================== ;
(defun cd:009_LineweightList ()
  (append
    (list
      (nth *l (list "JakWarstwa" "ByLayer")) ;LANG;
      (nth *l (list "JakBlok" "ByBlock")) ;LANG;
      (nth *l (list "Standard" "Default")) ;LANG;
    )
    (if (zerop (getvar "lwunits"))
      (list "0.000''" "0.002''" "0.004''" "0.005''" "0.006''" "0.007''" "0.008''" "0.010''"
            "0.012''" "0.014''" "0.016''" "0.020''" "0.021''" "0.024''" "0.028''" "0.031''"
            "0.035''" "0.039''" "0.042''" "0.047''" "0.055''" "0.062''" "0.079''" "0.083''"
      )
      (list "0.00 mm" "0.05 mm" "0.09 mm" "0.13 mm" "0.15 mm" "0.18 mm" "0.20 mm" "0.25 mm"
            "0.30 mm" "0.35 mm" "0.40 mm" "0.50 mm" "0.53 mm" "0.60 mm" "0.70 mm" "0.80 mm"
            "0.90 mm" "1.00 mm" "1.06 mm" "1.20 mm" "1.40 mm" "1.58 mm" "2.00 mm" "2.11 mm"
      )
    )
  )
)
; ====================================================================================== ;
(defun cd:009_UpdateBlockList (All Ann / res)
  (if (zerop Ann)
    (setq res (acad_strlsort *bnam))
    (setq res (acad_strlsort (append *bnam *bann)))
  )
  (cd:DCL_SetList "BLST" res bpos)
  (if (= All 1)
    (set_tile "BLST"
      (vl-string-trim "()"
        (vl-princ-to-string 
          (cd:CAL_Sequence 0 (length res) 1)
        )
      )
    )
    (progn
      (set_tile "BLST" "")
      (set_tile "BLST" bpos)
    )
  )
  res
)
; ====================================================================================== ;
(defun cd:009_UpdateObjects (/ _Sub lg lst1 lst2)
  (defun _Sub (Name)
    (if (not (zerop tlay))
      (cd:ACX_SetProp (tblobjname "BLOCK" Name) '(("Layer" . "0")))
    )
    (foreach % (cd:BLK_GetEntity Name nil)
      (cd:ENT_SetBasicDXF %
        (if (zerop tlay) nil (nth lpos llst))
        (if (zerop tcol) nil cpos)
        (if (zerop tlt) nil (nth ltpos lst1))
        (if (zerop tsca) nil sbox)
        (if (zerop tlw) nil (nth lwpos lst2))
      )
    )
  )
  (setq lg (vl-position (cadddr (cd:SYS_AcadInfo)) (list "PL" "EN"))) ;LANG;
  (setq lst1
    (append
      (list
        (nth lg (list "JakWarstwa" "ByLayer")) ;LANG;
        (nth lg (list "JakBlok" "ByBlock")) ;LANG;
      )
      (cddr ltlst)
    )
  )
  (setq lst2
    (list acLnWtByLayer acLnWtByBlock acLnWtByLwDefault acLnWt000 acLnWt005 acLnWt009
          acLnWt013 acLnWt015 acLnWt018 acLnWt020 acLnWt025 acLnWt030 acLnWt035 acLnWt040
          acLnWt050 acLnWt053 acLnWt060 acLnWt070 acLnWt080 acLnWt090 acLnWt100 acLnWt106
          acLnWt120 acLnWt140 acLnWt158 acLnWt200 acLnWt211
    )
  )
  (if (= tall 1)
    (foreach % blst
      (cond
        ( (= (substr % 1 2) "*U")
          (_Sub %)
        )
        ( T
          (foreach %% (cd:BLK_GetDynBlockNames %)
            (_Sub %%)
          )
        )
      )
    )
    (foreach % (cd:CON_Value2List bpos)
      (cond
        ( (= (substr (nth % blst) 1 2) "*U")
          (_Sub (nth % blst))
        )
        ( T
          (foreach %% (cd:BLK_GetDynBlockNames (nth % blst))
            (_Sub %%)
          )
        )
      )
    )
  )
  (if (= tall 1)
    (length blst)
    (length (cd:CON_Value2List bpos))
  )
)
; =========================================================================================== ;
(defun cd:009_BlockNameFilter ()
  (cons 2 (strcat "`*U*," (cd:STR_ReParse (cd:SYS_CollList "BLOCK" (+ 2 4 8)) ",")))
)
; =========================================================================================== ;
(princ "\n [RedefineBlockProperties v1.01]: (RBP RBPS -RBP) ")
(princ)
