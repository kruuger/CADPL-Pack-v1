; =========================================================================================== ;
; Zwraca liste obiektow wybranego typu / Returns a list of objects of the selected type       ;
;  Coll [STR] - typ obiektu / object type                                                     ;
;  Bit  [INT] - liczba calkowita (suma bitow) / integer number (sum of the bits)              ;
;               0 = bezwzglednie wszystkie / absolutely all                                   ;
;               1 = bez Model/Papier dla BLOCK i "" dla STYLE /                               ;
;                   without Model/Paper for Block and "" for STYLE                            ;
;               2 = bez anonimowych / without anonymous | BLOCK, GROUP, TABLE, VPORT          ;
;               4 = bez zaleznych od odnosnikow zewnetrznych /                                ;
;                   without dependent from external references                                ;
;               8 = bez odnosnikow zewnetrznych / without external references                 ;
;              16 = wszystkie anonimowe / all anonymous | BLOCK,GROUP,TABLE,VPORT,Model/Paper ;
;              32 = tylko odnosniki zewnetrzne / only external references                     ;
; ------------------------------------------------------------------------------------------- ;
; (cd:SYS_CollList "BLOCK" (+ 1 2 4))                                                         ;
; =========================================================================================== ;
(defun cd:SYS_CollList (Coll Bit / lst con res nam)
  (setq lst (list
              '("APPID" . "RegisteredApplications")
              '("BLOCK" . "Blocks")
              '("DIMSTYLE" . "DimStyles")
              '("GROUP" . "Groups")
              '("LAYER" . "Layers")
              '("LAYOUT" . "Layouts")
              '("LTYPE" . "LineTypes")
              '("MATERIAL" . "Materials")
              '("PLOTCONFIGURATION" . "PlotConfigurations")
              '("STYLE" . "TextStyles")
              '("UCS" . "UserCoordinateSystems")
              '("VIEW" . "Views")
              '("VPORT" . "ViewPorts")
            )
  )
  (if
    (member
      (setq con (strcase Coll))
      (mapcar (quote car) lst)
    )
    (vlax-for % (vlax-get (cd:ACX_ADoc) (cdr (assoc con lst)))
      (progn
        (setq nam (vla-get-name %))
        (cond
          ((and
             (= 1 (logand Bit 1))
             (or
               (= "" nam)
               (and
                 (= con "BLOCK")
                 (eq (vla-get-IsLayout %) :vlax-true)
               )
             )
           )
          )
          ((and
             (= 2 (logand Bit 2))
             (wcmatch nam "[*]@#*")
           )
          )
          ((and
             (= 4 (logand Bit 4))
             (wcmatch nam "*|*")
           )
          )
          ((and
             (= 8 (logand Bit 8))
             (= con "BLOCK")
             (eq (vla-get-isXRef %) :vlax-true)
           )
          )
          ((and
             (= 16 (logand Bit 16))
             (not (wcmatch nam "[*]*"))
           )
          )
          ((and
             (= 32 (logand Bit 32))
             (= con "BLOCK")
             (eq (vla-get-isXRef %) :vlax-false)
           )
          )
          (T (setq res (cons nam res)))
        )
      )
    )
  )
  res
)