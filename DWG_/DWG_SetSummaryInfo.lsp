; =========================================================================================== ;
; Zmiana wlasciwosci dokumentu / Set summary drawing properties                               ;
;  Doc  [VLA-Object] - document / document                                                    ;
;  Data [LIST/nil] - LIST = lista par kropkowych / list of dotted pairs                       ;
;                    nil  = usuwa wszystkie / delete all                                      ;
; ------------------------------------------------------------------------------------------- ;
; (cd:DWG_SetSummaryInfo (cd:ACX_ADoc) '(("Author" . "Me")("Title" . "123-ABC-55")))          ;
; =========================================================================================== ;
(defun cd:DWG_SetSummaryInfo (Doc Data / si)
  (setq si (vla-get-SummaryInfo Doc))
  (if (not Data)
    (mapcar
      (function
        (lambda (%)
          (vlax-put-property si % "")
        )
      )
      (list "Author" "Comments" "HyperLinkBase" "Keywords" "LastSavedBy"
            "RevisionNumber" "Subject" "Title"
      )
    )
    (mapcar
      (function
        (lambda (%)
          (if (vlax-property-available-p si (car %))
            (vlax-put-property si (car %) (cdr %))
          )
        )
      )
      Data
    )
  )
  nil
)