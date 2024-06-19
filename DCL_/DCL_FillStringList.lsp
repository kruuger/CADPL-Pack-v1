; =========================================================================================== ;
; Wypelnia wycinek "popup_list" lista lancuchow tekstowych /                                  ;
; Fills "popup_list" tiles with list of strings                                               ;
;  Key   [STR]  - nazwa wycinka / tile name                                                   ;
;  Lst   [LIST] - lista lancuchow tekstowych / list of strings                                ;
;  Str   [STR]  - aktualny lancuch tekstowy / current string                                  ;
;  Label [STR]  - etykieta dla pozycji "Nowa..." / label for "New..." position                ;
; =========================================================================================== ;
(defun cd:DCL_FillStringList (Key Lst Str Label / pos)
  (if (setq pos (vl-position (strcase Str) (mapcar (quote strcase) Lst)))
    (setq Lst (append Lst (list Label)))
    (setq Lst (append Lst (list Label Str))
          pos (1- (length Lst))
    )
  )
  (cd:DCL_SetList Key Lst pos)
)