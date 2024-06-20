; =========================================================================================== ;
; DrawingNotes.lsp - Zapisuje notatki w rysunku / Saves notes in drawing                      ;
; =========================================================================================== ;
;  Project : CADPL (http://forum.cad.pl/cadpl-zapisywanie-notatek-w-rysunku-t78051.html)      ;
;  Ver     : 1.00                                                                             ;
;  Date    : 2012-10-17                                                                       ;
;  Library : CADPL-Pack-v1.lsp                                                                ;
; =========================================================================================== ;
; Historia zmian: / History of changes:                                                       ;
;  2012-10-17 - ver. 1.00 : Pierwsza wersja / First version                                   ;
;  2013-09-17 - ver. 2.00 : zgodnosc z CAD-Util.lsp / compatibility with CAD-Util.lsp | (CPL) ;
; =========================================================================================== ;
; Polecenia: / Commands:                                                                      ;
;  NOT     - Polecenie glowne / Main command                                                  ;
;  NOTA    - Dodaje notatki do rysunku / Adds a note to drawing                               ;
;  NOTD    - Usuwa wszystkie notatki z rysunku / Deletes all notes from drawing               ;
;  NOTFL   - Oznacza notatki flagami / Mark notes by flags                                    ;
;  NOTFLD  - Usuwa flagi (aktualna przestrzen) / Deletes flags (actual space)                 ;
;  NOTFLDA - Usuwa flagi (z calego rysunku) / Deletes flags (from the whole drawing)          ;
;  NOTIF   - Wl/Wyl komunikat o notatkach w rysunku / Turn On/Off info about notes in drawing ;
;  NOTO    - Opcje programu (dcl) / Program options (dcl)                                     ;
;  -NOT    - Wersja w linii polecen / Command line version                                    ;
; =========================================================================================== ;
;  (cd:SYS_RW "CADPL\\Tools\\DrawingNotes" "GlobalNotification" "nil") - for experts ;)       ;
; =========================================================================================== ;
; Funkcje / Functions:                                                                        ;
;  cd:005_AddEditDialog       - okienko dodawania/edycji / add/edit window                    ;
;  cd:005_CheckColor          - sprawdza poprawnosc wprowadzonego koloru /                    ;
;                               check the correctness of the specified color                  ;
;  cd:005_CheckFlagType       - sprawdza poprawnosc wprowadzonego rodzaju flagi /             ;
;                               check the correctness of the specified flag type              ;
;  cd:005_CheckLayer          - sprawdza poprawnosc wprowadzonej warstwy /                    ;
;                               check the correctness of the specified color                  ;
;  cd:005_CheckNotification   - sprawdza poprawnosc globalnego przelacznika komunikatow /     ;
;                               check the correctness of the global switch info               ;
;  cd:005_CheckSeparator      - sprawdza poprawnosc wprowadzonego separatora daty /           ;
;                               check the correctness of the specified data separator         ;
;  cd:005_ColorList           - lista kolorow (dcl) / list of colors (dcl)                    ;
;  cd:005_CommandLine         - wersja w linii polecen / command line version                 ;
;  cd:005_CreateBlockFlag     - tworzy blok flagi / creates a block flag                      ;
;  cd:005_DeleteAllFlags      - usuwa flagi / deletes flags                                   ;
;  cd:005_DeleteLayerState    - usuwa filtry warstw / deletes layer states                    ;
;  cd:005_DeleteNote          - usuwa notatke / deletes note                                  ;
;  cd:005_DictionaryUpdate    - zapisuje notatki w slowniku / writes notes in the dictionary  ;
;  cd:005_DrawingNotes        - glowna funkcja programu / program main function               ;
;  cd:005_DrawingNotification - wl/wyl komunikat / turn on/off info                           ;
;  cd:005_Error               - funkcja obslugi bledow / error handling function              ;
;  cd:005_FlagSelectionSet    - wybiera flagi w rysunku / choose the flag in the drawing      ;
;  cd:005_FlagTypeList        - lista rozmiarow flag (dcl) / list sizes flag (dcl)            ;
;  cd:005_GetNoteArea         - ustala zakres widoku notatki / sets out the note view scope   ;
;  cd:005_GetNoteData         - pobiera rekord notatki / gets note record                     ;
;  cd:005_GetNoteFlagHandle   - pobiera uchwyty flag / gets flag handle                       ;
;  cd:005_GoToNote            - idzie do wskazanej notatki / goes to a designated note        ;
;  cd:005_ImageBorder         - ramka w wycinku "image" / border in the "image" tile          ;
;  cd:005_ImageFlag           - flaga w wycinku "image" / flag in the "image" tile            ;
;  cd:005_ImageLayer          - warstwy w wycinku "image" / layers in the "image" tile        ;
;  cd:005_ImageSeparator      - data w wycinku "image" / date in the "image" tile             ;
;  cd:005_InsertAllFlag       - wstawia wszystkie flagi / inserts all flags                   ;
;  cd:005_InsertFlag          - wstawia flage / inserts the flag                              ;
;  cd:005_MainDialog          - glowne okno programu / program main window                    ;
;  cd:005_MainDialogHeight    - wysokosc glownego okna / height of mian window                ;
;  cd:005_OptionsDialog       - okienko opcji / options window                                ;
;  cd:005_ReadNotes           - czyta notatki ze slownika / reads a note from a dictionary    ;
;  cd:005_RegData             - ustawienia programu / program settings                        ;
;  cd:005_RemLostFlags        - usuwa nieaktualne flagi / deletes outdated flags              ;
;  cd:005_RemLostLayerStates  - usuwa nieuzywane stany warstw / removes unused layer states   ;
;  cd:005_RemLostLayout       - usuwa notatke gdy arkusz nie istnieje /                       ;
;                               deletes a note when the layout does not exist                 ;
;  cd:005_SaveLayerState      - zapisuje stan warstw / saves layer states                     ;
;  cd:005_SaveView            - zapisuje aktualny widok / saves actual view                   ;
;  cd:005_SeparatorList       - lista separatorow (dcl) / list of separators (dcl)            ;
;  cd:005_SetAddEditTiles     - ustawia wycinki okna dodaj/edytuj / sets add/edit dialog tiles;
;  cd:005_SetMainDialogTiles  - ustawia wycinki okna glownego / sets the main dialog tiles    ;
;  cd:005_SetNoteData         - tworzy rekord notatki / creates a note record                 ;
;  cd:005_SortNotes           - sortowanie notatek / sort notes                               ;
;  cd:005_UpdateImageButton   - aktualizuje ikony sortownia / updates the sorting icons       ;
;  cd:005_UpdateList          - aktualizuje liste notatek / updates the list of notes         ;
; =========================================================================================== ;
(if (not cd:ACX_ADoc) (load "CADPL-Pack-v1.lsp" -1))
; =========================================================================================== ;
(defun C:NOT     () (cd:005_DrawingNotes 0) (princ))
(defun C:NOTA    () (cd:005_DrawingNotes 1) (princ))
(defun C:NOTD    () (cd:005_DrawingNotes 2) (princ))
(defun C:NOTIF   () (cd:005_DrawingNotes 3) (princ))
(defun C:NOTFL   () (cd:005_DrawingNotes 4) (princ))
(defun C:NOTFLD  () (cd:005_DrawingNotes 5) (princ))
(defun C:NOTFLDA () (cd:005_DrawingNotes 6) (princ))
(defun C:NOTO    () (cd:005_DrawingNotes 7) (princ))
(defun C:-NOT    () (cd:005_DrawingNotes 8) (princ))
; =========================================================================================== ;
(defun cd:005_Error (Msg)
  (cd:SYS_UndoEnd)
  (princ (strcat "\nDrawingNotes error: " Msg))
  (if olderr (setq *error* olderr))
  (princ)
)
; =========================================================================================== ;
(defun cd:005_DrawingNotes (Mode / olderr *key *key_help *tra *l *def *pos *dic *den *del *ver *lst *lst_in
                                   *dno *tmp_dno *pnt *tmp_pnt *rad *tmp_rad *lay *tmp_lay
                                   *d1pos *im *or *by *sv1 *sv2 *var *dc2 *aed *gna *err *tmp *fla
                                   dic
                           )
  (setq olderr *error*
        *error* cd:005_Error
        *key "CADPL\\Tools\\DrawingNotes"
        *key_help "\\HelpStrings"
        *tra (list "PL" "EN") ;LANG;
        *l (cond ( (vl-position (cd:SYS_RW *key "Language" nil) *tra) ) ( 1 ) )
        *def (cd:005_RegData)
        *pos (read (cd:SYS_RW *key "DialogPosition" nil))
        *dic "CADPL_DrawingNotes"
        *den (cd:DCT_GetDict (namedobjdict) *dic)
        *del T
        *ver (if (or (<= (cadr (cd:SYS_AcadInfo)) 17.0) (= (car (cd:SYS_AcadInfo)) "ZWCAD")) nil T)
  )
  (cd:005_RemLostLayout)
  (setq *lst_in (reverse (cd:005_ReadNotes))
        *lst *lst_in
  )
  (if *ver (cd:005_RemLostLayerStates))
  (cd:005_RemLostFlags)
  (redraw)
  (setq *d1pos 0
        *im (list 0 12 0 nil 0 nil)
        *or 1
        *by 0
        *sv1 1
  )
  (cd:005_SaveView)
  (cond
    ( (zerop Mode)
      (if *lst
        (setq *dc2 nil)
        (setq *dc2 T)
      )
      (cd:005_MainDialog)
    )
    ( T
      (cond
        ( (= Mode 1)
          (setq *dc2 T)
          (cd:005_MainDialog)
        )
        ( (= Mode 2)
          (if *den
            (progn
              (cd:SYS_UndoBegin)
              (cd:DCT_RemoveDict (namedobjdict) *dic)
              (setq *lst nil)
              (cd:005_RemLostLayerStates)
              (cd:005_RemLostFlags)
              (cd:SYS_UndoEnd)
              (princ (nth *l (list "\nUsuniêto z rysunku wszystkie notatki " "\nAll notes removed from drawing "))) ;LANG;
            )
            (princ (nth *l (list "\nRysunek nie zawiera notatek " "\nDrawing does not include notes "))) ;LANG;
          )
        )
        ( (= Mode 3)
          (cd:005_DrawingNotification)
        )
        ( (= Mode 4)
          (cd:005_InsertAllFlags)
        )
        ( (= Mode 5)
          (cd:005_DeleteAllFlags nil)
        )
        ( (= Mode 6)
          (cd:005_DeleteAllFlags T)
        )
        ( (= Mode 7)
          (cd:005_OptionsDialog)
        )
        ( (= Mode 8)
          (cd:005_CommandLine)
        )
        ( (= Mode 20)
          (if
            (and
              *den
              (cd:DCT_GetDict (cd:DCT_GetExtDictVLA *den nil) "Autoload")
              (read (nth 5 *def))
            )
            ; (alert (nth *l (list "Rysunek zawiera notatki. U¿yj polecenia NOT." "Drawing contains notes. Use NOT command. "))) ;LANG;
            (cd:005_DrawingNotes 0)
          )
        )
      )
    )
  )
  (if olderr (setq *error* olderr))
  (princ)
)
; =========================================================================================== ;
(defun cd:005_CommandLine (/ op)
  (setq op
    (cd:USR_GetKeyWord
      (nth *l (list "\nNotatki:" "\nNotes:")) ;LANG;
      (vl-remove (quote nil)
        (list
          (if *den (nth *l (list "Poka¿" "Show"))) ;LANG;
          (nth *l (list "Dodaj" "Add")) ;LANG;
          (if *den (nth *l (list "Usuñ" "Delete"))) ;LANG;
          (if
            (type
              (vl-remove (quote nil)
                (mapcar
                  (function
                    (lambda (%)
                      (and
                        (=
                          (getvar "ctab")
                          (cdr (assoc 1 (reverse (entget (handent (cdr (assoc 9 %)))))))
                        )
                        (cdr (assoc 10 %))
                      )
                    )
                  )
                  *lst
                )
              )
            )
            (nth *l (list "wstaw Flagi" "insert Flags")) ;LANG;
          )
          (if (cd:005_FlagSelectionSet nil) (nth *l (list "usuñ flagi z PRzestrzeni" "delete SPace flags"))) ;LANG;
          (if (cd:005_FlagSelectionSet T) (nth *l (list "usuñ flagi z Rysunku" "delete DRawing flags"))) ;LANG;
          (if *den (nth *l (list "Komunikat" "Info"))) ;LANG;
          (nth *l (list "Opcje" "Options")) ;LANG;
          (nth *l (list "WyjdŸ" "Exit")) ;LANG;
        )
      )
      (nth *l (list "WyjdŸ" "Exit")) ;LANG;
    )
  )
  (cond
    ( (= op (nth *l (list "Poka¿" "Show"))) (cd:005_DrawingNotes 0)) ;LANG;
    ( (= op (nth *l (list "Dodaj" "Add"))) (cd:005_DrawingNotes 1)) ;LANG;
    ( (= op (nth *l (list "Usuñ" "Delete"))) (cd:005_DrawingNotes 2)) ;LANG;
    ( (= op (nth *l (list "Flagi" "Flags"))) (cd:005_DrawingNotes 4)) ;LANG;
    ( (= op (nth *l (list "PRzestrzeni" "SPace"))) (cd:005_DrawingNotes 5)) ;LANG;
    ( (= op (nth *l (list "Rysunku" "DRawing"))) (cd:005_DrawingNotes 6)) ;LANG;
    ( (= op (nth *l (list "Komunikat" "Info"))) (cd:005_DrawingNotes 3)) ;LANG;
    ( (= op (nth *l (list "Opcje" "Options"))) (cd:005_DrawingNotes 7)) ;LANG;
    ( T nil )
  )
)
; =========================================================================================== ;
(defun cd:005_RegData (/ n h1 h2)
  (setq n 0)
  (setq h1
    (list
      (cons "NOT"     (list "Polecenie g³ówne" "Main command")) ;LANG;
      (cons "NOTA"    (list "Dodaje notatki do rysunku" "Adds a note to drawing")) ;LANG;
      (cons "NOTD"    (list "Usuwa wszystkie notatki z rysunku" "Deletes all notes from drawing")) ;LANG;
      (cons "NOTFL"   (list "Oznacza notatki flagami" "Mark notes by flags")) ;LANG;
      (cons "NOTFLD"  (list "Usuwa flagi (aktualna przestrzeñ)" "Deletes flags (actual space)")) ;LANG;
      (cons "NOTFLDA" (list "Usuwa flagi (z ca³ego rysunku)" "Deletes flags (from the whole drawing)")) ;LANG;
      (cons "NOTIF"   (list "W³/Wy³ komunikat o notatkach w rysunku" "Turn On/Off info about notes in drawing")) ;LANG;
      (cons "NOTO"    (list "Opcje programu (dcl)" "Program options (dcl)")) ;LANG;
      (cons "-NOT"    (list "Wersja w linii poleceñ" "Command line version")) ;LANG;
    )
  )
  (setq h2
    (list
      (cons "Description" (list "Zapisuje notatki w rysunku" "Saves notes in drawing")) ;LANG;
    )
  )
  (foreach %
    (list
      (cons "AcadLanguage" (cadddr (cd:SYS_AcadInfo)))
      (cons "Command" (cd:STR_ReParse (mapcar (quote car) h1)  ","))
      (cons "DialogPosition" "T")
      (cons "File" "DrawingNotes.lsp")
      (cons "Group" "Drawing")
      (cons "Tool" "005")
      (cons "Translations" (cd:STR_ReParse *tra ","))
      (cons "Version" "2.00")

      (cons "DataSeparator" (nth *l (list "- <myœlnik>" "- <dash>"))) ;LANG;
      (cons "FlagColor" "0")
      (cons "FlagLayer" "0")
      (cons "FlagType" "0")
      (cons "GlobalNotification" "T")
      (cons "RangePointerColor" "2")
      (cons "RemLostLayout" "T")
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
      (lambda (%1 %2)
        (%2 (cd:SYS_RW *key %1 nil))
      )
    )
    (list "DataSeparator" "FlagColor" "FlagLayer" "FlagType" "RangePointerColor" "GlobalNotification")
    (list cd:005_CheckSeparator cd:005_CheckColor cd:005_CheckLayer cd:005_CheckFlagType cd:005_CheckColor cd:005_CheckNotification)
  )
)
; =========================================================================================== ;
(defun cd:005_SaveView ()
  (setq *var
    (mapcar
      (function
        (lambda (%)
          (getvar %)
        )
      )
      (list "ctab" "viewsize" "viewctr")
    )
  )
  (if *ver (layerstate-save "CADPL_005_Temp" 255 nil))
)
; =========================================================================================== ;
(defun cd:005_MainDialog (/ fd tmp *dc bp res var)
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
                "DrawingNotes : dialog { key = \"NOT\"; label = \"DrawingNotes\"; fixed_width = true;"
                "  : column { : row {"
                (apply
                  (quote strcat)
                  (mapcar
                    (function
                      (lambda (da% ke% w%)
                        (strcat
                          "    : column { horizontal_margin = none;"
                          "      : text { label = \"" da% ":\"; }"
                          "      : IMAGE_BUTTON { key = \"" ke% "\"; width = " w% "; }}"
                        )
                      )
                    )
                    (list
                      (nth *l (list "Data | Czas" "Date | Time")) ;LANG;
                      (nth *l (list "Opis" "Description")) ;LANG;
                      (nth *l (list "Autor" "Author")) ;LANG;
                    )
                    (list "IM1" "IM2" "IM3")
                    (list "17" "71" "18")
                  )
                )
                "    }"
                "    : row {"
                "      : list_box { horizontal_margin = none; vertical_margin = none;"
                "        key = \"LIST\"; height = " (itoa (cd:005_MainDialogHeight)) "; tabs = \"0 17 89\"; }}}"
                "  : row { alignment = centered; fixed_width = true;"
                "    : B13 { key = \"ADD\"; label = \""
                (nth *l (list "&Dodaj..." "&Add...")) "\"; }" ;LANG;
                "    : B13 { key = \"EDIT\"; label = \""
                (nth *l (list "&Edytuj..." "&Edit...")) "\"; }" ;LANG;
                "    : B13 { key = \"DEL\"; label = \""
                (nth *l (list "&Usuñ" "&Delete")) "\"; }" ;LANG;
                "    spacer;"
                "    : B13 { key = \"GOTO\"; label = \""
                (nth *l (list "&IdŸ do" "&Goto")) "\"; }" ;LANG;
                "    : B13 { key = \"FLAG\"; label = \""
                (nth *l (list "&Flaga" "&Flag")) "\"; }" ;LANG;
                "    spacer;"
                "    : B13 { key = \"SAVE\"; label = \""
                (nth *l (list "&Zapisz" "&Save")) "\";" ;LANG;
                "      is_default = true; }"
                "    : B13 { key = \"CANCEL\"; label = \""
                (nth *l (list "&Anuluj" "&Cancel")) "\";" ;LANG;
                "      is_cancel = true; }}}"
                "DrawingNotesAdd : dialog {"
                "  key = \"ADDEDIT\";"
                "  : column { width = 75;"
                "    : boxed_column { label = \""
                (nth *l (list "Notatka" "Note")) ":\";" ;LANG;
                "      : edit_box { key = \"EDIT\"; edit_limit = 60; } spacer;"
       (if *ver "      : toggle { key = \"LS\"; label = \"" "")
       (if *ver (strcat (nth *l (list "&Zapamiêtaj aktualny stan warstw" "&Remember the current layer state")) "\"; }}") "}") ;LANG;
                "    : boxed_column { width = 30;"
                "      label = \"" (nth *l (list "Punkt" "Point")) ":\";" ;LANG;
                "      : row { : text { key = \"PT\"; }"
                "        : row { alignment = right; fixed_width = true;"
                "          : B13 { key = \"DEL\"; label = \""
                (nth *l (list "&Usuñ" "&Delete")) "\"; }" ;LANG;
                "          : B13 { key = \"PICK\"; label = \""
                (nth *l (list "&Dodaj" "&Add")) "\"; }" ;LANG;
                "}} spacer; }}"
                "  : row { alignment = centered; fixed_width = true;"
                "    : B13 { key = \"OK\"; label = \""
                (nth *l (list "&Ok" "&Ok")) "\"; is_default = true; }" ;LANG;
                "    : B13 { key = \"CANCEL\"; label = \""
                (nth *l (list "&Anuluj" "&Cancel")) "\"; is_cancel = true; }}" ;LANG;
                "  errtile; }"
                "IMAGE_BUTTON : image_button { horizontal_margin = none; vertical_margin = none; height = 1; }"
                "B13 : button { width = 13; fixed_width = true; horizontal_margin = none; }"
              )
            )
            (write-line % fd)
          )
          (not (close fd))
          (< 0 (setq *dc (load_dialog tmp)))
          (new_dialog "DrawingNotes" *dc ""
            (cond
              (*cd-TempDlgPosition*)
              ( (quote (-1 -1)) )
            )
          )
        )
      )
    )
    (T
      (cd:005_UpdateImageButton)
      (if *dc2
        (progn
          (cd:005_AddEditDialog)
          (if (not *lst) (done_dialog))
          (if *dc2 (done_dialog))
        )
      )
      (action_tile "LIST" "(setq *d1pos (atoi $value)) (if (= $reason 4) (cd:005_GoToNote (cd:005_GetNoteData 10))) (cd:005_SetMainDialogTiles)")
      (action_tile "IM1" "(setq *im (cd:LST_ReplaceItem 0 *im (abs (- 1 (nth 0 *im)))) *or (abs (- 1 (nth 0 *im))) *by 0) (cd:005_UpdateImageButton)")
      (action_tile "IM2" "(setq *im (cd:LST_ReplaceItem 2 *im (abs (- 1 (nth 2 *im)))) *or (abs (- 1 (nth 2 *im))) *by 1) (cd:005_UpdateImageButton)")
      (action_tile "IM3" "(setq *im (cd:LST_ReplaceItem 4 *im (abs (- 1 (nth 4 *im)))) *or (abs (- 1 (nth 4 *im))) *by 2) (cd:005_UpdateImageButton)")
      (action_tile "ADD" "(setq *aed nil) (cd:005_AddEditDialog) (if *dc2 (done_dialog 2))")
      (action_tile "EDIT" "(setq *aed T) (cd:005_GoToNote (cd:005_GetNoteData 10)) (cd:005_AddEditDialog) (if *dc2 (done_dialog 2))")
      (action_tile "DEL" "(cd:005_DeleteNote)")
      (action_tile "GOTO" "(cd:005_GoToNote (cd:005_GetNoteData 10))")
      (action_tile "FLAG" 
        (vl-prin1-to-string
          (quote
            (progn
              (cd:005_GoToNote (setq bp (cd:005_GetNoteData 10)))
              (cd:005_InsertFlag (cd:005_CreateBlockFlag (nth *d1pos *lst)) bp (cd:005_GetNoteData 40))
              (setq *fla (cdr (assoc 5 (entget (entlast))))
                    *lst (cd:LST_ReplaceItem *d1pos *lst (append (nth *d1pos *lst) (list (cons 8 *fla))))
                    *fla nil
                    *sv1 0
              )
              (redraw)
              (cd:005_UpdateImageButton)
            )
          )
        )
      )
      (action_tile "SAVE" "(done_dialog 1)")
      (action_tile "CANCEL" "(done_dialog 0)")
      (setq res (start_dialog))
    )
  )
  (if (< 0 *dc) (unload_dialog *dc))
  (if (setq tmp (findfile tmp)) (vl-file-delete tmp))
  (if *dc2 (setq res 2))
  (cond
    ( (zerop res)
      (setvar "ctab" (car *var))
      (vla-ZoomCenter (vlax-get-acad-object) (vlax-3d-Point (trans (caddr *var) 1 0)) (cadr *var))
      (setq *lst *lst_in)
      (if *ver (layerstate-restore "CADPL_005_Temp" nil nil))
      (if *ver (cd:005_RemLostLayerStates))
      (cd:005_RemLostFlags)
      (princ (nth *l (list "\nNie zaktualizowano notatek " "\nNotes not updated "))) ;LANG;
    )
    ( (= res 1)
      (cd:SYS_UndoBegin)
      (if *ver (cd:005_RemLostLayerStates))
      (cd:005_RemLostFlags)
      (cd:005_DictionaryUpdate)
      (cd:SYS_UndoEnd)
      (princ (nth *l (list "\nZaktualizowano notatki " "\nNotes updated "))) ;LANG;
    )
    ( (= res 2)
      (if (setq *gna (cd:005_GetNoteArea))
        (if  (= (car (last *gna)) 3)
          (progn
            (setq *tmp_pnt (car *gna))
            (princ (setq *tmp_rad (cadr *gna)))
            (princ " ")
          )
          (setq *err (nth *l (list "Niepoprawny zakres" "Invalid range"))) ;LANG;
        )
        (setq *err (nth *l (list "Niepoprawny punkt" "Invalid point"))) ;LANG;
      )
      (princ)
      (cd:005_MainDialog)
    )
    ( T nil )
  )
)
; =========================================================================================== ;
(defun cd:005_MainDialogHeight (/ len)
  (setq len (length *lst))
  (cond
    ( (<= len 10) 12 )
    ( (< 10 len 30) (+ len 2) )
    ( T 30 )
  )
)
; =========================================================================================== ;
(defun cd:005_AddEditDialog (/ res)
  (cond
    ( (not (new_dialog "DrawingNotesAdd" *dc))
      (alert (strcat (nth *l (list "B³¹d ³adowania okienka " "Error loading DCL.")) "DrawingNotes.dcl")) ;LANG;
    )
    (T
      (if *aed ; T=Edit | nil=Add
        (progn
          (set_tile "ADDEDIT" (strcat "DrawingNotes \\ " (nth *l (list "Edytuj" "Edit")))) ;LANG;
          (setq *dno (cd:005_GetNoteData 2)
                *lay (cd:005_GetNoteData 4)
                *fla (cd:005_GetNoteFlagHandle (nth *d1pos *lst))
                *pnt (cd:005_GetNoteData 10)
                *rad (cd:005_GetNoteData 40)
          )
          (setq *sv2 (list *dno *pnt *rad (if *lay "1" "0")))
        )
        (progn
          (set_tile "ADDEDIT" (strcat "DrawingNotes \\ " (nth *l (list "Dodaj" "Add")))) ;LANG;
          (if *lst
            (setq *dno (cd:005_GetNoteData 2))
          )
        )
      )
      (if (not *tmp_dno) (setq *tmp_dno *dno))
      (if (not *tmp_lay) (setq *tmp_lay (if *lay "1" "0")))
      (if (not *tmp_pnt) (setq *tmp_pnt *pnt))
      (if (not *tmp_rad) (setq *tmp_rad *rad))
      (cd:005_SetAddEditTiles)
      (mode_tile "EDIT" 2)
      (action_tile "EDIT" "(setq *tmp_dno $value) (cd:005_SetAddEditTiles)")
      (action_tile "LS" "(setq *tmp_lay $value) (cd:005_SetAddEditTiles)")
      (action_tile "DEL" "(setq *tmp_pnt nil *tmp_rad nil) (cd:005_SetAddEditTiles)")
      (action_tile "PICK" "(done_dialog 2)")
      (action_tile "OK" "(done_dialog 1)")
      (action_tile "CANCEL" "(done_dialog 0)")
      (setq res (start_dialog))
      (cond
        ( (zerop res)
          (setq *dno nil
                *lay nil
                *fla nil
                *pnt nil
                *rad nil
                *tmp_dno nil
                *tmp_lay nil
                *tmp_pnt nil
                *tmp_rad nil
                *dc2 nil
                *sv2 nil

          )
        )
        ( (= res 1)
          (setq *dno *tmp_dno
                *pnt *tmp_pnt
                *rad *tmp_rad
                *tmp_dno nil
                *tmp_pnt nil
                *tmp_rad nil
                *dc2 nil
                *sv1 0
                *sv2 nil
          )
          (cond
            ( (= *tmp_lay "0")
              (setq *lay nil)
            )
            ( (= *tmp_lay "1")
              (setq *lay (cd:005_SaveLayerState))
            )
          )
          (if *aed
            (setq *lst (cd:LST_ReplaceItem *d1pos *lst (cd:005_SetNoteData)))
            (setq *lst (append *lst (list (cd:005_SetNoteData))))
          )
          (if *fla
            (foreach % *fla
              (vla-delete (vlax-ename->vla-object (handent %)))
            )
          )
          (setq *dno nil *lay nil *fla nil *pnt nil *rad nil *tmp_lay nil)
          (cd:005_UpdateList)
        )
        ( (= res 2)
          (setq *dc2 T)
        )
      )
    )
  )
)
; =========================================================================================== ;
(defun cd:005_ReadNotes (/ dic rec old new)
  (if (setq dic (cd:DCT_GetDictList (cd:DCT_GetDict (namedobjdict) *dic) T))
    (progn
      (foreach % (mapcar (quote cdr) dic)
        (setq *lst
          (cons
            (progn
              (setq rec (cd:DCT_GetXrecord %)
                    old (cdr (assoc 1 rec))
                    new (strcat
                          (substr old 1 4) (substr (car *def) 1 1)
                          (substr old 6 2) (substr (car *def) 1 1)
                          (substr old 9 2)
                          (substr old 11)
                        )
              )
              (cd:LST_ReplaceItem 0 rec (cons 1 new))
            )
            *lst
          )
        )
      )
    )
    (setq *lst nil)
  )
)
; =========================================================================================== ;
(defun cd:005_SetNoteData (/ _Sub)
  (defun _Sub (/ str)
    (setq str (cd:SYS_GetDateTime "YYYY-MO-DD | HH:MM"))
    (strcat
      (substr str 1 4)
      (substr (car *def) 1 1)
      (substr str 6 2)
      (substr (car *def) 1 1)
      (substr str 9)
    )
  )
  ;;  1 - date
  ;;  2 - note
  ;;  3 - login
  ;;  4 - layer state
  ;;  9 - layout handle
  ;; 10 - point
  ;; 40 - radius
  (vl-remove-if
    (function
      (lambda (%)
        (not (cdr %))
      )
    )
    (list
      (cons 1 (_Sub))
      (cons 2 *dno)
      (cons 3 (getvar "loginname"))
      (cons 4 *lay)
      (cons 9
        (cdr
          (assoc 5
            (entget
              (cd:DCT_GetDict
                (cd:DCT_GetDict (namedobjdict) "ACAD_LAYOUT")
                (if (= (getvar "cvport") 1)
                  (getvar "ctab")
                  "Model"
                )
              )
            )
          )
        )
      )
      (cons 10 *pnt)
      (cons 40 *rad)
    )
  )
)
; =========================================================================================== ;
(defun cd:005_GetNoteData (Dxf)
  (cdr (assoc Dxf (nth *d1pos *lst)))
)
; =========================================================================================== ;
(defun cd:005_GetNoteArea (/ g i l n p q r)    
  (if (setq p (getpoint (nth *l (list "\nOkreœl punkt: " "\nSelect point: ")))) ;LANG;
    (progn
      (princ (trans p 1 0))
      (setq n (/ pi -25.0) i (abs n))
      (repeat 50
        (setq l (cons (polar '(0.0 0.0) (setq n (+ n i)) 1.0) l))
      )
      (setq l (cons
                (atoi (nth 4 *def))
                (apply
                  (quote append)
                  (mapcar (quote list)
                    (cons (last l) l)
                    l
                  )
                )
              )
            q (trans p 1 2)
            q (list (car q) (cadr q))
      )
      (princ (nth *l (list "\nOkreœl zakres: " "\nSelect range: "))) ;LANG;
      (while (= 5 (car (setq g (grread t 4 0))))
        (redraw)
        (setq r (distance q (trans (cadr g) 1 2)))
        (grdraw p (cadr g) 8 1)
        (grvecs l
          (list
            (list r 0.0 0.0 (car  q))
            (list 0.0 r 0.0 (cadr q))
            (list 0.0 0.0 r 0.0)
           '(0.0 0.0 0.0 1.0)
          )
        )
      )
      (redraw)
      (list (trans p 1 0) r g)
    )
    nil
  )
)
; =========================================================================================== ;
(defun cd:005_GoToNote (Point / ra ls)
  (setvar "ctab" (cdr (assoc 1 (reverse (entget (handent (cd:005_GetNoteData 9)))))))
  (if (and *ver (setq ls (cd:005_GetNoteData 4)))
    (layerstate-restore ls nil nil)
  )
  (if (setq ra (cd:005_GetNoteData 40))
    (vla-ZoomCenter
      (vlax-get-acad-object)
      (vlax-3D-point Point)
      (* ra 2)
    )
  )
)
; =========================================================================================== ;
(defun cd:005_DeleteNote ()
  (setq *lst (cd:LST_RemoveItem *d1pos *lst)
        *sv1 0
  )
  (cond
    ( (zerop (length *lst))
      (setq *d1pos 0)
    )
    ( (>= *d1pos (length *lst))
      (setq *d1pos (1- (length *lst)))
    )
  )
  (cd:005_UpdateList)
)
; =========================================================================================== ;
(defun cd:005_CreateBlockFlag (Data / _Flag _Dot _Range ftyp)
  (defun _Flag ()
    (entmake
      (list
        (cons 0 "LWPOLYLINE")
        (cons 100 "AcDbEntity")
        (cons 67 0)
        (cons 8 (caddr *def))
        (cons 62 (atoi (cadr *def)))
        (cons 100 "AcDbPolyline")
        (cons 90 3)
        (cons 70 0)
        (cons 38 0.0)
        (cons 10 '(0.0 0.0))
        (cons 40 0.0)
        (cons 41 0.0)
        (cons 10 '(0.0 0.3))
        (cons 40 0.22)
        (cons 41 0.0)
        (cons 10 '(0.3 0.3))
        (cons 40 0.0)
        (cons 41 0.0)
        (cons 210 '(0.0 0.0 1.0))
      )
    )
  )
  (defun _Dot ()
    (entmake
      (list
        (cons 0 "LWPOLYLINE")
        (cons 100 "AcDbEntity")
        (cons 67 0)
        (cons 8 (caddr *def))
        (cons 62 (atoi (cadr *def)))
        (cons 100 "AcDbPolyline")
        (cons 90 3)
        (cons 70 0)
        (cons 38 0.0)
        (cons 10 '(0.05 0.0))
        (cons 42 1)
        (cons 10 '(-0.05 0.0))
        (cons 42 1)
        (cons 10 '(0.05 0.0))
        (cons 42 0.0)
        (cons 210 '(0.0 0.0 1.0))
      )
    )
  )
  (defun _Range ()
    (entmake
      (list
        (cons 0 "CIRCLE")
        (cons 8 (caddr *def))
        (cons 62 (atoi (cadr *def)))
        (cons 10 '(0.0 0.0))
        (cons 40 (/ 4. 7.))
        (cons 210 '(0.0 0.0 1.0))
      )
    )
  )
  (setq ftyp (atoi (cadddr *def)))
  (cd:ENT_MakeBlockHead "*U" (list 0 0 0) 1)
  (cond
    ( (zerop ftyp) (_Flag) (_Dot) )  ; Flag
    ( (= ftyp 1) (_Range) )          ; Range
    ( (= ftyp 2) (_Flag) (_Range) )  ; Flag+Range
  )
  (mapcar
    (function
      (lambda (%1 %2)
        (entmake
          (mapcar (quote cons)
            (list 0 8 1 62 10 11 40 50 72 73)
            (list "TEXT" (caddr *def) (cdr (assoc %1 Data)) (atoi (cadr *def)) (list 0 %2 0) (list 0 %2 0) 0.01 0 1 2)
          )
        )
      )
    )
    (list 1 2 3)
    (list 0.47 0.45 0.43)
  )
  (cd:ENT_MakeBlockEnd)
)
; =========================================================================================== ;
(defun cd:005_InsertFlag (Block Point Range / sc v)
  (setq sc (* 1.75 Range)
        v (trans (getvar "viewdir") 1 0 T)
  )
  (entmake
    (list
     '(0 . "INSERT")
      (cons 2 Block)
      (cons 8 (caddr *def))
      (cons 10 (trans (trans Point 0 1) 1 v))
      (cons 41 sc)
      (cons 42 sc)
      (cons 43 sc)
      (cons 50 (- (getvar "viewtwist")))
      (cons 210 v)
    )
  )
  (cd:XDT_PutXData (entlast) "CADPL_005" '((1000 . "Flag")))
)
; =========================================================================================== ;
(defun cd:005_InsertAllFlags (/ ct bp pt n)
  (if *den
    (progn
      (setq n 0)
      (setq *lst
        (mapcar
          (function
            (lambda (%)
              (if
                (=
                  (getvar "ctab")
                  (cdr (assoc 1 (reverse (entget (handent (cdr (assoc 9 %)))))))
                )
                (progn
                  (setq ct (cons 1 ct))
                  (if (setq bp (cdr (assoc 10 %)))
                    (progn
                      (cd:005_InsertFlag (cd:005_CreateBlockFlag %) bp (cdr (assoc 40 %)))
                      (setq n (1+ n)
                            pt (cons 1 pt)
                      )
                      (append % (list (cons 8 (cdr (assoc 5 (entget (entlast)))))))
                    )
                    (progn
                      (setq pt (cons 0 pt))
                      %
                    )
                  )
                )
                (progn
                  (setq ct (cons 0 ct))
                  %
                )
              )
            )
          )
          *lst
        )
      )
      (cd:005_DictionaryUpdate)
      (cond
        ( (vl-every (quote zerop) ct)
          (princ (nth *l (list "\nBrak notatek w aktualnej przestrzeni " "\nThere are no notes in the current space "))) ;LANG;
        )
        ( (vl-every (quote zerop) pt)
          (princ (nth *l (list "\nBrak punktów w notatkach " "\nNo points in notes "))) ;LANG;
        )
        ( T
          (princ
            (strcat
              (nth *l (list "\nWstawiono " "\nInserted ")) ;LANG;
              (itoa n)
              (nth *l (list " flag(i) " " flag(s) ")) ;LANG;
            )
          )
        )
      )
    )
    (princ (nth *l (list "\nRysunek nie zawiera notatek " "\nDrawing does not include notes "))) ;LANG;
  )
)
; =========================================================================================== ;
(defun cd:005_DeleteAllFlags (Mode / ss)
  (if (setq ss (cd:005_FlagSelectionSet Mode))
    (progn
      (cd:SYS_UndoBegin)
      (foreach % (cd:SSX_Convert ss 1)
        (vla-delete %)
      )
      (cd:005_RemLostFlags)
      (cd:SYS_UndoEnd)
      (princ
        (strcat
          (nth *l (list "\nUsuniêto " "\nRemoved ")) ;LANG;
          (itoa (sslength ss))
          (nth *l (list " flag(i) " " flag(s) ")) ;LANG;
        )
      )
    )
    (if Mode
      (princ (nth *l (list "\nBrak flag w rysunku " "\nNo flags in drawing "))) ;LANG;
      (princ (nth *l (list "\nBrak flag w aktualnej przestrzeni " "\nNo flags in current space"))) ;LANG;
    )
  )
)
; =========================================================================================== ;
(defun cd:005_FlagSelectionSet (Mode / xd)
  (setq xd (cons -3 (list (list "CADPL_005"))))
  (if Mode
   (ssget "_X" (list xd))
   (ssget "_X"
     (list
       (if (= (getvar "cvport") 1)
         (cons 410 (getvar "ctab"))
         (cons 410 "Model")
       )
       xd
     )
   )
  )
)
; =========================================================================================== ;
(defun cd:005_GetNoteFlagHandle (Note)
  (mapcar
    (quote cdr)
    (vl-remove-if-not
      (function
        (lambda (%)
          (= (car %) 8)
        )
      )
      Note
    )
  )
)
; =========================================================================================== ;
(defun cd:005_SaveLayerState (/ res n)
  (setq res (strcat "CADPL_005_" (cd:STR_FillChar "1" "0" 5 nil))
        n 2
  )
  (while (member res (layerstate-getnames))
    (setq res (strcat "CADPL_005_" (cd:STR_FillChar (itoa n) "0" 5 nil))
          n (1+ n)
    )
  )
  (if (layerstate-save res 255 nil)
    res
  )
)
; =========================================================================================== ;
(defun cd:005_DeleteLayerState (/ ls)
  (and
    (setq ls (cd:005_GetNoteData 4))
    (layerstate-has ls)
    (layerstate-delete ls)
  )
)
; =========================================================================================== ;
(defun cd:005_UpdateList ()
  (set_tile "LIST" "")
  (cd:DCL_SetList "LIST"
    (mapcar
      (function
        (lambda (%)
          (strcat (nth 0 %) "\t" (nth 1 %) "\t" (nth 2 %))
        )
      )
      (mapcar
        (function
          (lambda (%)
            (mapcar (quote cdr) %)
          )
        )
        (setq *lst (cd:005_SortNotes *or *by *lst))
      )
    )
    *d1pos
  )
  (cd:005_SetMainDialogTiles)
)
; =========================================================================================== ;
(defun cd:005_SortNotes (Order Pos Lst)
  (vl-sort Lst
    (function
      (lambda (%1 %2)
        (if (zerop Order)
          (> (cdr (nth Pos %1)) (cdr (nth Pos %2)))
          (< (cdr (nth Pos %1)) (cdr (nth Pos %2)))
        )
      )
    )
  )
)
; =========================================================================================== ;
(defun cd:005_DictionaryUpdate (/ _Sub dold dnew n)
  (defun _Sub ()
    (if
      (and
        *lst
        (setq dnew (cd:DCT_AddDict (namedobjdict) *dic))
      )
      (progn
        (setq n 0)
        (foreach % *lst
          (cd:DCT_AddXrecord
            dnew
            (strcat "N" (cd:STR_FillChar (itoa (setq n (1+ n))) "0" 5 nil))
            %
          )
        )
      )
    )
  )
  (if (setq dold (cd:DCT_RemoveDict (namedobjdict) *dic))
    (and
      (_Sub)
      (cd:DCT_GetDictList (cd:DCT_GetExtDictVLA dold nil) nil)
      (cd:DCT_AddXrecord (cd:DCT_GetExtDictVLA dnew T) "AutoLoad" (list))
    )
    (progn
      (_Sub)
      (cd:DCT_AddXrecord (cd:DCT_GetExtDictVLA dnew T) "AutoLoad" (list))
    )
  )
)
; =========================================================================================== ;
(defun cd:005_UpdateImageButton (/ n)
  (setq n 0)
  (foreach % (list "IM1" "IM2" "IM3")
    (cd:DCL_ImgBtnSortIcon
      %
      (nth n *im)
      (if (= (/ n 2) *by) 12 nil)
    )
    (setq n (+ n 2))
  )
  (cd:005_UpdateList)
)
; =========================================================================================== ;
(defun cd:005_SetMainDialogTiles ()
  (mapcar (quote mode_tile)
    (list "EDIT" "DEL" "GOTO" "FLAG")
    (cond
      ( (not *lst)
        (list 1 1 1 1)
      )
      ( (cd:005_GetNoteData 10)
        (list 0 0 0 0)
      )
      ( T
        (list 0 0 1 1)
      )
    )
  )
  (mode_tile "SAVE" *sv1)
)
; =========================================================================================== ;
(defun cd:005_SetAddEditTiles (/ _Sub)
  (defun _Sub (Ls Del Pick Ok)
    (mapcar (quote mode_tile)
      (list "LS" "DEL" "PICK" "OK")
      (list Ls Del Pick Ok)
    )
  )
  (cond
    ( *err
      (_Sub 0 1 0 0)
    )
    ( (not *tmp_dno)
      (setq *err (nth *l (list "Wpisz notakê i zatwierdŸ TAB lub ENTER" "Enter and confirm note with TAB or ENTER"))) ;LANG;
      (_Sub 1 1 1 1)
    )
    ( (= *tmp_dno "")
      (setq *err (nth *l (list "Nie mo¿na dodaæ pustej notatki" "Can't add empty note"))) ;LANG;
      (_Sub 1 1 1 1)
    )
    ( (not (vl-remove (quote 32) (vl-string->list *tmp_dno)))
      (setq *err (nth *l (list "Niepoprawna notatka" "Invalid note"))) ;LANG;
      (_Sub 1 1 1 1)
    )
    ( (and
        *aed
        (equal *sv2 (list *tmp_dno *tmp_pnt *tmp_rad *tmp_lay))
      )
      (setq *err (nth *l (list "Nic nie zmieniono" "Nothing changed"))) ;LANG;
      (if *tmp_pnt
        (_Sub 0 0 1 1)
        (_Sub 0 1 0 1)
      )
    )
    ( (not *tmp_pnt)
      (setq *err "")
      (set_tile "PT" "...")
      (_Sub 0 1 0 0)
    )
    ( T
      (setq *err "")
      (if *tmp_pnt
        (_Sub 0 0 1 0)
        (_Sub 0 1 0 0)
      )
    )
  )
  (if *tmp_dno (set_tile "EDIT" *tmp_dno))
  (if *tmp_pnt
    (set_tile "PT"
      (cd:STR_ReParse
        (mapcar
          (function
            (lambda (%)
              (cd:CON_Real2Str % nil nil)
            )
          )
          *tmp_pnt
        )
        " , "
      )
    )
    (set_tile "PT" "...")
  )
  (set_tile "LS" *tmp_lay)
  (set_tile "error" *err)
  (setq *err nil)
)
; =========================================================================================== ;
(defun cd:005_RemLostLayout (/ dn lx)
  (if
    (and
      (setq dn (cd:DCT_GetDict (namedobjdict) *dic))
      (setq lx (cd:DCT_GetDictList dn T))
      *del
    )
    (foreach %
      (mapcar
        (function
          (lambda (%1)
            (cons (cdr (assoc 9 (cd:DCT_GetXRecord (cdr %1)))) (car %1))
          )
        )
        lx
      )
      (if (not (entget (handent (car %))))
        (cd:DCT_RemoveDict dn (cdr %))
      )
    )
  )
)
; =========================================================================================== ;
(defun cd:005_RemLostLayerStates (/ res)
  (and
    *lst
    (setq res
      (mapcar
        (function
          (lambda (%)
            (vl-remove-if
              (function
                (lambda (%1)
                  (and
                    (= (car %1) 4)
                    (not (member (cdr %1) (layerstate-getnames)))
                  )
                )
              )
              %
            )
          )
        )
        *lst
      )
    )
    (not (equal *lst res))
    (setq *lst res)
    (cd:005_DictionaryUpdate)
  )
  (foreach % (layerstate-getnames)
    (and
      (not
        (member % 
          (mapcar
            (function
              (lambda (%)
                (cdr (assoc 4 %))
              )
            )
            *lst
          )
        )
      )
      (wcmatch (strcase %) "CADPL_005_*")
      (layerstate-delete %)
    )
  )
)
; =========================================================================================== ;
(defun cd:005_RemLostFlags (/ res ha ss n en)
  (and
    (setq res
      (mapcar
        (function
          (lambda (%)
            (vl-remove-if
              (function
                (lambda (%1 / en)
                  (and
                    (= (car %1) 8)
                    (setq ha (append ha (list (cdr %1))))
                    (setq en (handent (cdr %1)))
                    (not (entget en))
                    
                  )
                )
              )
              %
            )
          )
        )
        *lst
      )
    )
    (not (equal *lst res))
    (setq *lst res)
    (cd:005_DictionaryUpdate)
  )
  (if (setq ss (cd:005_FlagSelectionSet T))
    (repeat (setq n (sslength ss))
      (setq en (ssname ss (setq n (1- n))))
      (if (not (member (cdr (assoc 5 (entget en))) ha))
        (vla-delete (vlax-ename->vla-object en))
      )
    )
  )
)
; =========================================================================================== ;
(defun cd:005_DrawingNotification (/ key)
  (if *den
    (if
      (setq key
        (cd:USR_GetKeyWord
          (nth *l (list "\nWy³¹czyæ powiadomienie o notatkach: " "Disable notification about notes: ")) ;LANG;
          (list
            (nth *l (list "Nie" "No")) ;LANG;
            (nth *l (list "Tak" "Yes")) ;LANG;
          )
          (nth *l (list "Nie" "No")) ;LANG;
        )
      )
      (if
        (and
          (= key (nth *l (list "Nie" "No"))) ;LANG;
          *den
        )
        (progn
          (cd:DCT_AddXrecord (cd:DCT_GetExtDictVLA *den T) "AutoLoad" (list))
          (princ (nth *l (list "\nPowiadomienie o notatkach w³¹czone " "Notes notification enabled "))) ;LANG;
        )
        (progn
          (cd:DCT_RemoveDict (cd:DCT_GetExtDictVLA *den T) "AutoLoad")
          (princ (nth *l (list "\nPowiadomienie o notatkach wy³¹czone " "\nNotes notification disabled "))) ;LANG;
        )
      )
    )
    (princ (nth *l (list "\nRysunek nie zawiera notatek " "\nDrawing does not include notes "))) ;LANG;
  )
)
; =========================================================================================== ;
(defun cd:005_CheckNotification (Flag)
  (cond
    ( (member Flag (list "nil" "T")) Flag )
    ( (cd:SYS_RW *key "GlobalNotification" "T") )
  )
)
; =========================================================================================== ;
(defun cd:005_OptionsDialog (/ fd tmp dc res fcol_lst flay_lst ftyp_lst dsep_lst
                               fcol flay ftyp rcol dsep flay_new dsep_new)
  (if (not *pos) (setq *cd-TempDlgPosition* (list -1 -1)))
  (cond
    ( (not
        (and
          (setq fd
            (open
              (setq tmp (vl-FileName-MkTemp nil nil ".dcl")) "w"
            )
          )
          (write-line
            (strcat
              "DrawingNotesOptions : dialog {"
              "  label = \"DrawingNotes - " (nth *l (list "Opcje" "Options")) "\";" ;LANG;
              "  : boxed_column {"
              "    label = \"" (nth *l (list "Flaga" "Flag")) ":\";" ;LANG;
              "    : row {"
              "      : POPUP { key = \"FTYP\";"
              "        label = \"" (nth *l (list "&Typ" "&Type")) ":\"; }" ;LANG;
              "      : IMAGE_STRIPE { key = \"FTIM\"; width = 3.5; }"
              "    } spacer;"
              "    : row {"
              "      : POPUP { key = \"FCOL\";"
              "        label = \"" (nth *l (list "&Kolor" "C&olor")) ":\"; }" ;LANG;
              "      : IMAGE_STRIPE { key = \"FCIM\"; width = 3.5; }"
              "    } spacer;"
              "    : row {"
              "      : POPUP { key = \"FLAY\";"
              "        label = \"" (nth *l (list "&Warstwa" "&Layer")) ":\"; }" ;LANG;
              "      : IMAGE_STRIPE { key = \"FLIM\"; width = 3.5; }"
              "    } spacer; }"
              "  : boxed_column {"
              "    label = \"" (nth *l (list "WskaŸnik zakresu" "Range pointer")) ":\";" ;LANG;
              "    : row {"
              "      : POPUP { key = \"RCOL\";"
              "        label = \"" (nth *l (list "&Kolor" "C&olor")) ":\"; }" ;LANG;
              "      : IMAGE_STRIPE { key = \"RCIM\"; width = 3.5; }"
              "      } spacer; }"
              "  : boxed_column {"
              "    label = \"" (nth *l (list "Data" "Date")) ":\";" ;LANG;
              "    : row {"
              "      : POPUP { key = \"DSEP\";"
              "        label = \"" (nth *l (list "&Separator" "&Separator")) ":\"; }" ;LANG;
              "      : IMAGE_STRIPE { key = \"DSIM\"; width = 3.5; }"
              "    } spacer; } OK_CANCEL; }"
              "POPUP"
              "  : popup_list { width = 30; fixed_width = true; edit_width = 15;"
              "    alignment = left; vertical_margin = none; }"
              "IMAGE_STRIPE"
              "  : image { vertical_margin = none; horizontal_margin = none; fixed_width = true; }"
              "OK_CANCEL"
              "  : row { fixed_width = true; alignment = centered;"
              "    : B13 { key = \"OK\";"
              "      label = \"" (nth *l (list "&Ok" "&Ok")) "\";" ;LANG;
              "      is_default = true; }"
              "    : B13 { key = \"CANCEL\";"
              "      label = \"" (nth *l (list "&Anuluj" "&Cancel")) "\";" ;LANG;
              "      is_cancel = true; }}"
              "B13 : button { width = 13; horizontal_margin = none; }"
            ) fd
          )
          (not (close fd))
          (< 0 (setq dc (load_dialog tmp)))
          (new_dialog "DrawingNotesOptions" dc ""
            (cond
              (*cd-TempDlgPosition*)
              ( (quote (-1 -1)) )
            )
          )
        )
      )
    )
    ( T
      (setq ftyp_lst (cd:005_FlagTypeList *l)
            fcol_lst (cd:005_ColorList *l)
            flay_lst (acad_strlsort (cd:SYS_CollList "LAYER" (+ 4 8)))
            dsep_lst (cd:005_SeparatorList *l)
            ftyp (cadddr *def)
            fcol (cadr *def)
            flay (caddr *def)
            rcol (nth 4 *def)
            dsep (car *def)
            flay_new (nth *l (list "Nowa..." "New...")) ;LANG;
            dsep_new (nth *l (list "Nowy..." "New...")) ;LANG;
      )
      (cd:DCL_SetList "FTYP" ftyp_lst ftyp)
      (cd:005_ImageFlag "FTIM" (atoi fcol) (atoi ftyp)) (cd:005_ImageBorder "FTIM")
      (cd:DCL_FillColorList "FCOL" fcol_lst fcol)
      (cd:DCL_FillColorImage "FCIM" (atoi fcol))
      (cd:005_ImageBorder "FCIM")
      (cd:DCL_FillStringList "FLAY" flay_lst flay flay_new)
      (cd:DCL_FillColorImage "FLIM" -15)
      (cd:005_ImageBorder "FLIM")
      (cd:005_ImageLayer "FLIM")
      (cd:DCL_FillColorList "RCOL" fcol_lst rcol)
      (cd:DCL_FillColorImage "RCIM" (atoi rcol))
      (cd:005_ImageBorder "RCIM")
      (cd:DCL_FillStringList "DSEP" dsep_lst dsep dsep_new)
      (cd:DCL_FillColorImage "DSIM" -15)
      (cd:005_ImageBorder "DSIM")
      (cd:005_ImageSeparator "DSIM")
      (action_tile "FCOL"
        (vl-prin1-to-string
          (quote
            (progn
              (setq fcol (cd:DCL_ChangeColorList "FCOL" "FCIM" fcol_lst $value fcol))
              (cd:005_ImageBorder "FCIM")
              (cd:005_ImageFlag "FTIM" (atoi fcol) (atoi ftyp))
              (cd:005_ImageBorder "FTIM")
            )
          )
        )
      )
      (action_tile "FTYP" "(setq ftyp $value) (cd:005_ImageFlag \"FTIM\" (atoi fcol) (atoi ftyp)) (cd:005_ImageBorder \"FTIM\")")
      (action_tile "RCOL" "(setq rcol (cd:DCL_ChangeColorList \"RCOL\" \"RCIM\" fcol_lst $value rcol)) (cd:005_ImageBorder \"RCIM\")")
      (action_tile "FLAY"
        (vl-prin1-to-string
          (quote
            (progn
              (setq flay
                (cd:DCL_ChangeStringList "FLAY" flay_lst (atoi $value) flay flay_new
                 '(cd:DCL_StdEditBoxDialog 
                    (list 1
                      (list
                        (cons 2 (nth *l (list "Niepoprawna nazwa warstwy" "Invalid layer name")))
                        (cons 4 (nth *l (list "Warstwa wystêpuje w rysunku" "Layer already exist in drawing")))
                      )
                      "" "LAYER"
                    )
                    (nth *l (list "Opcje - Nowa warstwa" "Options - New layer")) ;LANG;
                    (nth *l (list "WprowadŸ nazwê:" "Enter name:")) ;LANG;
                    40 13
                    (list
                      (nth *l (list "&Ok" "&Ok")) ;LANG;
                      (nth *l (list "&Anuluj" "&Cancel")) ;LANG;
                    )
                    T nil
                  )
                )
              )
            )
          )
        )
      )
      (action_tile "DSEP"
        (vl-prin1-to-string
          (quote
            (progn
              (setq dsep
                (cd:DCL_ChangeStringList "DSEP" dsep_lst (atoi $value) dsep dsep_new
                 '(cd:DCL_StdEditBoxDialog 
                    (list 1
                      (list
                        (cons 16 (nth *l (list "Opis niezgodny ze wzorcem" "Description inconsistent with pattern")))
                        (cons 32 (nth *l (list "Symbol wystêpuja na liœcie" "Symbol already exist on the list")))
                      )
                      "" nil "? <?*>" dsep_lst
                    )                
                    (nth *l (list "Opcje - Nowy separator" "Options - New separator")) ;LANG;
                    (strcat
                      (nth *l (list "WprowadŸ symbol z opisem" "Enter symbol with description")) ;LANG;
                      (nth *l (list " (np. - <myœlnik>" " (ex. - <dash>")) ;LANG;
                    )
                    40 13
                    (list
                      (nth *l (list "&Ok" "&Ok")) ;LANG;
                      (nth *l (list "&Anuluj" "&Cancel")) ;LANG;
                    )
                    T nil
                  )
                )
              )
            )
          )
        )
      )
      (action_tile "OK" "(done_dialog 1)")
      (action_tile "CANCEL" "(done_dialog 0)")
      (setq res (start_dialog))
    )
  )
  (if (< 0 dc) (unload_dialog dc))
  (if (setq tmp (findfile tmp)) (vl-file-delete tmp))
  (cond
    ( (= res 0)
      (princ (nth *l (list "\nNie zmieniono ustawieñ " "\nSettings unchanged "))) ;LANG;
    )
    ( (= res 1)
      (mapcar
        (function
          (lambda (%1 %2)
            (cd:SYS_RW *key %1 %2)
          )
        )
        (list "DataSeparator" "FlagColor" "FlagLayer" "FlagType" "RangePointerColor")
        (list dsep fcol flay ftyp rcol)
      )
      (princ (nth *l (list "\nZapisano ustawienia " "\nSettings saved "))) ;LANG;
    )
  )
)
; =========================================================================================== ;
(defun cd:005_CheckColor (Color)
  (cond
    ( (member Color (cd:CON_All2Str (cd:CAL_Sequence 0 257 1) nil)) Color )
    ( "0" )
  )
)
; =========================================================================================== ;
(defun cd:005_CheckLayer (Layer)
  (if (and Layer (snvalid Layer)) Layer (cd:SYS_RW *key "FlagLayer" "0"))
)
; =========================================================================================== ;
(defun cd:005_CheckFlagType (Size)
  (cond
    ( (member Size (list "0" "1" "2")) Size )
    ( (cd:SYS_RW *key "FlagType" "0") )
  )
)
; =========================================================================================== ;
(defun cd:005_CheckSeparator (Sep)
  (if (and Sep (wcmatch Sep "? <?*>"))
    Sep
    (cd:SYS_RW *key "DataSeparator" (nth 2 (cd:005_SeparatorList *l)))
  )
)
; =========================================================================================== ;
(defun cd:005_ColorList (Lang)
  (list
    (nth Lang (list "JakWarstwa" "ByLayer")) ;LANG;
    (nth Lang (list "JakBlok" "ByBlock")) ;LANG;
    (nth Lang (list "1 - Czerwony" "1 - Red")) ;LANG;
    (nth Lang (list "2 - ¯ó³ty" "2 - Yellow")) ;LANG;
    (nth Lang (list "3 - Zielony" "3 - Green")) ;LANG;
    (nth Lang (list "4 - B³êkitny" "4 - Cyan")) ;LANG;
    (nth Lang (list "5 - Niebieski" "5 - Blue")) ;LANG;
    (nth Lang (list "6 - Fioletowy" "6 - Magenta")) ;LANG;
    (nth Lang (list "7 - Bia³y" "7 - White")) ;LANG;
    (nth Lang (list "Inny..." "Other...")) ;LANG;
  )
)
; =========================================================================================== ;
(defun cd:005_FlagTypeList (Lang)
  (list
    (nth Lang (list "Flaga" "Flag")) ;LANG;
    (nth Lang (list "Zakres" "Range")) ;LANG;
    (nth Lang (list "Flaga+Zakres" "Flag+Range")) ;LANG;

  )
)
; =========================================================================================== ;
(defun cd:005_SeparatorList (Lang)
  (list
    (nth Lang (list "  <spacja>" "  <space>")) ;LANG;
    (nth Lang (list ". <kropka>" ". <dot>")) ;LANG;
    (nth Lang (list "- <myœlnik>" "- <dash>")) ;LANG;
    (nth Lang (list "/ <ukoœnik>" "/ <slash>")) ;LANG;
  )
)
; =========================================================================================== ;
(defun cd:005_ImageBorder (Key)
  (start_image Key)
  (mapcar (quote vector_image)
    (list  20   0  20   0)
    (list  20  20   0   0)
    (list  20   0  20   0)
    (list  20  20   0   0)
    (list -15 -15 -15 -15)
  )
  (mapcar (quote vector_image)
    (list  19  19  20   1   1   0  19  19  20   1   1   0)
    (list  19  20  19  19  20  19   1   0   1   1   0   1)
    (list  19  19  20   1   1   0  19  19  20   1   1   0)
    (list  19  20  19  19  20  19   1   0   1   1   0   1)
    (list 253 253 253 253 253 253 253 253 253 253 253 253)
  )
  (mapcar (quote vector_image)
    (list  18   3   2  19  18   1   3   2)
    (list  18  19  18   3   2   3   1   2)
    (list  18  17   2  19  18   1  17   2)
    (list  18  19  18  17   2  17   1   2)
    (list 255 255 255 255 255 255 255 255)
  )
  (mapcar (quote vector_image)
    (list  18  19   2   1  18  19   2   1)
    (list  19  18  19  18   1   2   1   2)
    (list  18  19   2   1  18  19   2   1)
    (list  19  18  19  18   1   2   1   2)
    (list 254 254 254 254 254 254 254 254)
  )
  (mapcar (quote vector_image)
    (list   2  20   0   2)
    (list  20   2   2   0)
    (list  18  20   0  18)
    (list  20  18  18   0)
    (list 252 252 252 252)
  )
  (end_image)
)
; =========================================================================================== ;
(defun cd:005_ImageFlag (Key Color Flag)
  (if (member Color (list 0 256)) (setq Color 7))
  (start_image Key)
  (fill_image 0 0 (dimx_tile Key) (dimy_tile Key) 0) 
  (cond
    ( (zerop Flag)
      (mapcar (quote vector_image)
        (list 11  7  8  8 10 10 10 10 10  9)
        (list 13 13 12 16  8  7  6  4  5  4)
        (list 11  7 10 10 10 12 14 10 12  9)
        (list 15 15 12 16  8  7  6  4  5 14)
        (list Color Color Color Color Color Color Color Color Color Color)
      )
    )
    ( (= Flag 1)
      (mapcar (quote vector_image)
    (list 15 13 14  5  6  5 15 13 14 5 6 5  8 16  4  8)
    (list 13 15 14 13 15 14  7  5  6 7 5 6  4  8  8 16)
    (list 15 14 15  5  7  6 15 14 15 5 7 6 12 16  4 12)
    (list 13 15 14 13 15 14  7  5  6 7 5 6  4 12 12 16)
    (list Color Color Color Color Color Color Color Color Color Color Color Color Color Color Color Color)
      )
    )
    ( (= Flag 2)
      (mapcar (quote vector_image)
        (list 15 13 14  5  6  5 15 13 14 5 6 5  8 16  4  8  9  9  9 9  9  8)
        (list 13 15 14 13 15 14  7  5  6 7 5 6  4  8  8 16 11 10  9 7  8  7)
        (list 15 14 15  5  7  6 15 14 15 5 7 6 12 16  4 12  9 11 13 9 11  8)
        (list 13 15 14 13 15 14  7  5  6 7 5 6  4 12 12 16 11 10  9 7  8 13)
        (list Color Color Color Color Color Color Color Color Color Color Color Color Color Color Color Color Color Color Color Color Color Color)
      )
    )
  )
  (end_image)
)
; =========================================================================================== ;
(defun cd:005_ImageLayer (Key)
  (start_image Key)
  (mapcar (quote vector_image)
    (list   4  12  12  16  16  16   8  12   4  14  14  15  15   6   5   7   6   5  15  14  13  14  13  14  13   6   5   9   5   5   5)
    (list   9   9  12   8  11   5   5  15  15   8  11  12   9  10  11   6   7   8   6   7   8  10  11  13  14  13  14   5   9  12  15)
    (list   4  12  12  16  16  16   8  12   4  15  15  15  15   6   5   7   6   5  15  14  13  14  13  14  13   6   5  15  11  11  11)
    (list   9   9  12   8  11   5   5  15  15   8  11  12   9  10  11   6   7   8   6   7   8  10  11  13  14  13  14   5   9  12  15)
    (list 250 250 250 250 250 250 250 250 250 250 250 250 250 250 250 250 250 250 250 250 250 250 250 250 250 250 250 250 250 250 250)
  )
  (mapcar (quote vector_image)
    (list   8   7   6   7   6   7   6)
    (list   6   7   8  10  11  13  14)
    (list  14  13  12  13  12  13  12)
    (list   6   7   8  10  11  13  14)
    (list 255 255 255 255 255 255 255)
  )
  (end_image)
)
; =========================================================================================== ;
(defun cd:005_ImageSeparator (Key)
  (start_image Key)
  (mapcar (quote vector_image)
    (list   5  15   9   7  13  11  11  13  10   7  14   6)
    (list   6   6   7   7   7   7  13  13   7  14   6   6)
    (list   5  15   9   7  13  11  11  13  10  13  14   6)
    (list  14  14   7   7   7   7  13  13  13  14  14  14)
    (list 255 255 255 255 255 255 255 255 255 255 255 255)
  )
  (mapcar (quote vector_image)
    (list   9   8   8   7   7   7  12  12  11  12  13  11)
    (list   8  10   7   8  11  13   7  10  12  13   8   8)
    (list   9   8   8   7   7   9  12  12  11  12  13  11)
    (list   9  10   7   8  12  13   7  10  12  13  12   9)
    (list 250 250 250 250 250 250 250 250 250 250 250 250)
  )
  (mapcar (quote vector_image)
    (list  8  9  7 12 11 12  7 8)
    (list 11 10  9  8 10 11  6 8)
    (list  8  9  7 12 11 12 13 8)
    (list 12 12 10  9 11 12  6 9)
    (list  7  7  7  7  7  7  7 7)
  )
  (mapcar (quote vector_image)
    (list  16   4)
    (list   6   6)
    (list  16   4)
    (list  14  14)
    (list 254 254)
  )
  (mapcar (quote vector_image)
    (list   4   4)
    (list   4  16)
    (list  16  16)
    (list   4  16)
    (list 252 252)
  )
  (mapcar (quote vector_image)
    (list   4   4)
    (list   5  15)
    (list  16  16)
    (list   5  15)
    (list 253 253)
  )
  (end_image)
)
; =========================================================================================== ;
(princ "\n [DrawingNotes v2.00]: (NOT NOTA NOTD NOTFL NOTFLD NOTFLDA NOTIF NOTO -NOT) ")
(princ)
(cd:005_DrawingNotes 20)
