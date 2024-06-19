; =========================================================================================== ;
; Tworzy poczatek definicji bloku / Creates a block definition head                           ;
;  Name [STR]  - nazwa bloku / block name                                                     ;
;  Pb   [LIST] - punkt bazowy bloku / block base point                                        ;
;  Flag [INT]  - typ bloku (bit-kody, mozna laczyc) / block type (bit-codes, may be combined) ;
;                0 = standardowy block / standard block                                       ;
;                1 = blok anonimowy / anonymous block                                         ;
;                2 = definicje atrybutow (nie-stale) / attribute definitions (non-constant)   ;
; ------------------------------------------------------------------------------------------- ;
; (cd:ENT_MakeBlockHead "NOWY" (list 0 0 0) 0), (cd:ENT_MakeBlockHead "*U" (list 0 0 0) 1)    ;
; =========================================================================================== ;
(defun cd:ENT_MakeBlockHead (Name Pb Flag)
  (entmakex
    (list
      (cons 0 "BLOCK")
      (cons 2 Name)
      (cons 8 "0")
      (cons 10 Pb)
      (cons 70
            (if (member Flag (list 0 1 2 3))
              Flag
              0
            )
      )
    )
  )
)