; =========================================================================================== ;
; Lista wlasciwosci dokumentu / Summary drawing properties list                               ;
;  Doc [VLA-Object] - document / document                                                     ;
; ------------------------------------------------------------------------------------------- ;
; (cd:DWG_GetSummaryInfo (cd:ACX_ADoc))                                                       ;
; =========================================================================================== ;
(defun cd:DWG_GetSummaryInfo (Doc)
  (mapcar
    (function
      (lambda (%)
        (cons
          %
          (vlax-get-property
            (vla-get-SummaryInfo Doc)
            %
          )
        )
      )
    )
    (list "Author" "Comments" "HyperLinkBase" "Keywords" "LastSavedBy"
          "RevisionNumber" "Subject" "Title"
    )
  )
)